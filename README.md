
## Boolean Expression Parser (Swift)

* Supports AND (&), OR (|), and NOT (!) operators.

* Supports parenthesis grouping.

* Supports input error handling.


### The algorithm

The algorithm works as follows:

When `evaluator.evaluate(expression: input)` called, the expression is validated against the following criteria:

1. There are only allowed characters.

2. There are no unmatched parentheses.

3. The syntax of all unary and binary operators is valid.

  

If the validation fails, the corresponding exception is thrown.

  

Next, if the validation is successful, the following steps are repeated until the entire input string is transformed into a single value of `"true"` or `"false"`:

  

1. Find the first sub-expression inside parentheses that does not have nested parentheses.

2. Evaluate the sub-expression:

    2.1 Find all the unary operations, evaluate them, and replace them with the evaluated values. This leaves only the `AND` and `OR` operators in the sub-expression.

    2.2 Split the sub-expression into more sub-expressions by the `OR` operator, since the `AND` operations must be evaluated before the `OR` operations.

    2.3 Evaluate and replace these AND operation sub-expressions with the evaluated values. This leaves only the OR operators in the sub-expression.

    2.4 Evaluate the values of all `OR` operations in the resulting expression and replace the original expression inside the parentheses with its result - true or false.

3. Repeat the steps 1-2 until all parentheses in the input expression, and then the final expression, have been replaced with their evaluated values.

Thus, as a result, we get a single value of `"true"` or `"false"`, which should be returned as the boolean result of the function.

#### Example:

`((true & false) | !(true | !false))`

`(false | !(true | !false))`

`(false | !(true | true))`

`(false | !true)`

`(false | false)`

`false`

