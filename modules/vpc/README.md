# VPC MODULE

## POC Goal

@07-05-25 The purpose of this POC was to understand more about the Terraform meta-arguments, specifically the [for_each](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each.), [count](https://developer.hashicorp.com/terraform/language/meta-arguments/count) meta-arguments.

## SUBNETS 

For this part of the module, the challenge was to create all the specified subnets in the `routes` variable accross different AWS AZs, as it's a requirement for creating an EKS cluster and also a best practice for improving availability. 

To do so, I didn't want to statically assign an AZ or even manually define an index to each route.

*So here's the challenge:*

    During the routes variable iteration, how to iterate over the AZ's and assign each subnet to a different AZ 


### The solution I came

During the `routes` iteration, iterate again over the generated list from the `data.aws_availability_zones.available` data source or lookup it to pick only one single and different value to define the AZ.

### Blocks

- It's not possible to use nested `for_each`
- The same applies for `count`


### The implementation

1. I created a new list variable name `routes_list`, iterated over the `routes` and stored all the `cidr_blocks` in it.

```
locals {
  routes_list = [for route in var.routes : route.cidr_block]
}
```
It gets all the routes that will be created.


2. Now, in the `availability_zone` definition I used the [index](https://developer.hashicorp.com/terraform/language/functions/index_function) function to generate an index for each subnet from the `local.routes_list`.

```
  availability_zone = data.aws_availability_zones.available.names[index("${local.routes_list}","${each.value.cidr_block}")]
```
Basically, the `index` function finds the element index for a given value in a list. It needs two arguments `index(list, value)`. 

Thus, during the iteration it gets the index value of a given route in `local.routes_list` and set this value as the index for `data.aws_availability_zones.available.names[<index value>]`.

    Pey, this will be the selected AZ for the current subnet


### Conclusion

I know this is not an unbreakable solution because the AZ definition creates a dependency between the number of subnets and the number of AZs for a given region.

Let's say we define 10 subnets to be created in `us-east-1` which has 6 AZs. Let's take a look:

List of subnets to be created
```
routes_list = [
    [0] 10.0.0.0/24,
    [1] 10.0.10.0/24,
    [2] 10.0.20.0/24,
    [3] 10.0.30.0/24,
    [4] 10.0.40.0/24,
    [5] 10.0.50.0/24,
    [6] 10.0.60.0/24,
    [7] 10.0.70.0/24,
    [8] 10.0.80.0/24,
    [9] 10.0.90.0/24,
]
```
List of available zones for `us-east-1` (virginia)
```
data.aws_availability_zones.available.names = [
    [0] us-east-1a
    [1] us-east-1b
    [2] us-east-1c
    [3] us-east-1d
    [4] us-east-1e
    [5] us-east-1f

]
```
Let's now break down the AZ definition of the subnet creation resource:

1. The `for_each` resource starts the iteration over the `routes` variable.
2. It defines a bunch of arguments and de `availability_zone`

```
availability_zone = data.aws_availability_zones.available.names[index("${local.routes_list}","${each.value.cidr_block}")]
```

It means, that for a given value from `"${each.value.cidr_block}` it will search this value in  `locals.routes_list` and get its index value. Thus:

```
         ROUTES                 AZ INDEX CALCULATION               AVAILABLE AZs 
    [0] 10.0.0.0/24,  -> [index(routes_list,"10.0.0.0/24")]  ->   [0] us-east-1a
    [1] 10.0.10.0/24, -> [index(routes_list,"10.0.10.0/24")] ->   [1] us-east-1b
    [2] 10.0.20.0/24, -> [index(routes_list,"10.0.20.0/24")] ->   [2] us-east-1c
    [3] 10.0.30.0/24, -> [index(routes_list,"10.0.30.0/24")] ->   [3] us-east-1d
    [4] 10.0.40.0/24, -> [index(routes_list,"10.0.40.0/24")] ->   [4] us-east-1e
    [5] 10.0.50.0/24, -> [index(routes_list,"10.0.50.0/24")] ->   [5] us-east-1f
    [6] 10.0.60.0/24, -> [index(routes_list,"10.0.60.0/24")] ->          X
    [7] 10.0.70.0/24, -> [index(routes_list,"10.0.70.0/24")] ->          X
    [8] 10.0.80.0/24, -> [index(routes_list,"10.0.80.0/24")] ->          X
    [9] 10.0.90.0/24, -> [index(routes_list,"10.0.90.0/24")] ->          X

```
    In summary, if we try to create more subnets than the available AZs in a given region, it will fail.


### Improvements

Update this resource to randomly select an AZ during the subnet creation or following this same approach, it'd have to go back to the beginning of the list when reaching the end to keep creating the subnets in different AZs.




