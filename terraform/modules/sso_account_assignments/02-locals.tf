locals {
  account_assignments_aux = flatten([
    for key1, value1 in var.module_args.accounts : concat(
      # For all accounts
      flatten([
        for key2, value2 in var.module_args.default_account_permission_set_group_assignment["all"] : flatten([
          for element1 in value2 : flatten([
            for element2 in (length(regexall("#ITERATE#", element1)) > 0 ?
              flatten([
                for key3, value3 in var.module_args.groups : key3
                if length(regexall(replace(element1, "#ITERATE#", ""), key3)) > 0 &&
                  length(regexall(split("-", key1)[1], key3)) > 0
              ]) 
              : (var.module_args.is_multi_tenant ? flatten([
                split("-", key1)[1]!="global" ? [split("-", key1)[1]] : [],
                !(length(regexall("#BU_SCOPE#", element1)) > 0) ? ["global"] : []
              ]) : [""])
            ) : {
              key = "${key1}-${key2}-${element1}-${element2}"
              permission_set_arn = var.module_args.permission_sets[key2].arn
              principal_id = length(regexall("#ITERATE#", element1)) > 0 ? var.module_args.groups[element2].group_id : var.module_args.groups[
                replace(
                  replace(element1, "#BU_SCOPE#", lookup(value1, "bu", null) != null ? "${value1.bu}-" : ""),
                  "#SCOPE#", element2 != "" ? "${element2}-" : element2
                )
              ].group_id
              principal_type = "GROUP"
              target_id = value1.id
              target_type = "AWS_ACCOUNT"
            }
          ])
        ])
      ]),
      # For management account
      flatten([
        for key2, value2 in var.module_args.default_account_permission_set_group_assignment["management"] : flatten([
          for element1 in value2 : flatten([
            for element2 in (length(regexall("#ITERATE#", element1)) > 0 ?
              flatten([
                for key3, value3 in var.module_args.groups : key3
                if length(regexall(replace(element1, "#ITERATE#", ""), key3)) > 0 &&
                  length(regexall(split("-", key1)[1], key3)) > 0
              ]) 
              : (var.module_args.is_multi_tenant ? flatten([
                split("-", key1)[1]!="global" ? [split("-", key1)[1]] : [],
                !(length(regexall("#BU_SCOPE#", element1)) > 0) ? ["global"] : []
              ]) : [""])
            ) : {
              key = "${key1}-${key2}-${element1}-${element2}"
              permission_set_arn = var.module_args.permission_sets[key2].arn
              principal_id = length(regexall("#ITERATE#", element1)) > 0 ? var.module_args.groups[element2].group_id : var.module_args.groups[
                replace(
                  replace(element1, "#BU_SCOPE#", lookup(value1, "bu", null) != null ? "${value1.bu}-" : ""),
                  "#SCOPE#", element2 != "" ? "${element2}-" : element2
                )
              ].group_id
              principal_type = "GROUP"
              target_id = value1.id
              target_type = "AWS_ACCOUNT"
            }
          ])
        ])
        if length(regexall("management", key1)) > 0
      ]),
      # For tenants
      flatten([
        for key2, value2 in var.module_args.default_account_permission_set_group_assignment["tenant"] : flatten([
          for element1 in value2 : flatten([
            for element2 in (length(regexall("#ITERATE#", element1)) > 0 ?
              flatten([
                for key3, value3 in var.module_args.groups : key3
                if length(regexall(replace(element1, "#ITERATE#", ""), key3)) > 0 &&
                  length(regexall(split("-", key1)[1], key3)) > 0
              ]) 
              : (var.module_args.is_multi_tenant ? flatten([
                split("-", key1)[1]!="global" ? [split("-", key1)[1]] : [],
                !(length(regexall("#BU_SCOPE#", element1)) > 0) ? ["global"] : []
              ]) : [""])
            ) : {
              key = "${key1}-${key2}-${element1}-${element2}"
              permission_set_arn = var.module_args.permission_sets[key2].arn
              principal_id = length(regexall("#ITERATE#", element1)) > 0 ? var.module_args.groups[element2].group_id : var.module_args.groups[
                replace(
                  replace(element1, "#BU_SCOPE#", lookup(value1, "bu", null) != null ? "${value1.bu}-" : ""),
                  "#SCOPE#", element2 != "" ? "${element2}-" : element2
                )
              ].group_id
              principal_type = "GROUP"
              target_id = value1.id
              target_type = "AWS_ACCOUNT"
            }
          ])
        ])
        if (var.module_args.is_multi_tenant && split("-", key1)[1]!="global") || (
          length(regexall("management", key1)) > 0 &&
          length(regexall("security", key1)) > 0 &&
          length(regexall("archive", key1)) > 0 &&
          length(regexall("breakglass", key1)) > 0 &&
          length(regexall("staging", key1)) > 0
        )
      ]),
      # For Workloads Pro
      flatten([
        for key2, value2 in var.module_args.default_account_permission_set_group_assignment["workload_pro"] : flatten([
          for element1 in value2 : flatten([
            for element2 in (length(regexall("#ITERATE#", element1)) > 0 ?
              flatten([
                for key3, value3 in var.module_args.groups : key3
                if length(regexall(replace(element1, "#ITERATE#", ""), key3)) > 0 &&
                  length(regexall(split("-", key1)[1], key3)) > 0
              ]) 
              : (var.module_args.is_multi_tenant ? flatten([
                split("-", key1)[1]!="global" ? [split("-", key1)[1]] : [],
                !(length(regexall("#BU_SCOPE#", element1)) > 0) ? ["global"] : []
              ]) : [""])
            ) : {
              key = "${key1}-${key2}-${element1}-${element2}"
              permission_set_arn = var.module_args.permission_sets[key2].arn
              principal_id = length(regexall("#ITERATE#", element1)) > 0 ? var.module_args.groups[element2].group_id : var.module_args.groups[
                replace(
                  replace(element1, "#BU_SCOPE#", lookup(value1, "bu", null) != null ? "${value1.bu}-" : ""),
                  "#SCOPE#", element2 != "" ? "${element2}-" : element2
                )
              ].group_id
              principal_type = "GROUP"
              target_id = value1.id
              target_type = "AWS_ACCOUNT"
            }
          ])
        ])
        if lookup(value1, "is_workload", false) && length(regexall("pro", key1)) > 0
      ]),
      # For Workloads Non Pro
      flatten([
        for key2, value2 in var.module_args.default_account_permission_set_group_assignment["workload_non_pro"] : flatten([
          for element1 in value2 : flatten([
            for element2 in (length(regexall("#ITERATE#", element1)) > 0 ?
              flatten([
                for key3, value3 in var.module_args.groups : key3
                if length(regexall(replace(element1, "#ITERATE#", ""), key3)) > 0 &&
                  length(regexall(split("-", key1)[1], key3)) > 0
              ]) 
              : (var.module_args.is_multi_tenant ? flatten([
                split("-", key1)[1]!="global" ? [split("-", key1)[1]] : [],
                !(length(regexall("#BU_SCOPE#", element1)) > 0) ? ["global"] : []
              ]) : [""])
            ) : {
              key = "${key1}-${key2}-${element1}-${element2}"
              permission_set_arn = var.module_args.permission_sets[key2].arn
              principal_id = length(regexall("#ITERATE#", element1)) > 0 ? var.module_args.groups[element2].group_id : var.module_args.groups[
                replace(
                  replace(element1, "#BU_SCOPE#", lookup(value1, "bu", null) != null ? "${value1.bu}-" : ""),
                  "#SCOPE#", element2 != "" ? "${element2}-" : element2
                )
              ].group_id
              principal_type = "GROUP"
              target_id = value1.id
              target_type = "AWS_ACCOUNT"
            }
          ])
        ])
        if lookup(value1, "is_workload", false) && !(length(regexall("pro", key1)) > 0)
      ]),
      # For Deployment Pro
      flatten([
        for key2, value2 in var.module_args.default_account_permission_set_group_assignment["deployment_pro"] : flatten([
          for element1 in value2 : flatten([
            for element2 in (length(regexall("#ITERATE#", element1)) > 0 ?
              flatten([
                for key3, value3 in var.module_args.groups : key3
                if length(regexall(replace(element1, "#ITERATE#", ""), key3)) > 0 &&
                  length(regexall(split("-", key1)[1], key3)) > 0
              ]) 
              : (var.module_args.is_multi_tenant ? flatten([
                split("-", key1)[1]!="global" ? [split("-", key1)[1]] : [],
                !(length(regexall("#BU_SCOPE#", element1)) > 0) ? ["global"] : []
              ]) : [""])
            ) : {
              key = "${key1}-${key2}-${element1}-${element2}"
              permission_set_arn = var.module_args.permission_sets[key2].arn
              principal_id = length(regexall("#ITERATE#", element1)) > 0 ? var.module_args.groups[element2].group_id : var.module_args.groups[
                replace(
                  replace(element1, "#BU_SCOPE#", lookup(value1, "bu", null) != null ? "${value1.bu}-" : ""),
                  "#SCOPE#", element2 != "" ? "${element2}-" : element2
                )
              ].group_id
              principal_type = "GROUP"
              target_id = value1.id
              target_type = "AWS_ACCOUNT"
            }
          ])
        ])
        if length(regexall("deployment", key1)) > 0 && length(regexall("pro", key1)) > 0
      ]),
      # For Deployment Non Pro
      flatten([
        for key2, value2 in var.module_args.default_account_permission_set_group_assignment["deployment_non_pro"] : flatten([
          for element1 in value2 : flatten([
            for element2 in (length(regexall("#ITERATE#", element1)) > 0 ?
              flatten([
                for key3, value3 in var.module_args.groups : key3
                if length(regexall(replace(element1, "#ITERATE#", ""), key3)) > 0 &&
                  length(regexall(split("-", key1)[1], key3)) > 0
              ]) 
              : (var.module_args.is_multi_tenant ? flatten([
                split("-", key1)[1]!="global" ? [split("-", key1)[1]] : [],
                !(length(regexall("#BU_SCOPE#", element1)) > 0) ? ["global"] : []
              ]) : [""])
            ) : {
              key = "${key1}-${key2}-${element1}-${element2}"
              permission_set_arn = var.module_args.permission_sets[key2].arn
              principal_id = length(regexall("#ITERATE#", element1)) > 0 ? var.module_args.groups[element2].group_id : var.module_args.groups[
                replace(
                  replace(element1, "#BU_SCOPE#", lookup(value1, "bu", null) != null ? "${value1.bu}-" : ""),
                  "#SCOPE#", element2 != "" ? "${element2}-" : element2
                )
              ].group_id
              principal_type = "GROUP"
              target_id = value1.id
              target_type = "AWS_ACCOUNT"
            }
          ])
        ])
        if length(regexall("deployment", key1)) > 0 && !(length(regexall("pro", key1)) > 0)
      ])
    )
    if lookup(value1, "default_assingment", true)
  ])
  account_assignments = {
    for element in local.account_assignments_aux : element.key => element
  }
}
