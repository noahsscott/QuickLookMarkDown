# Math/LaTeX Rendering Test

This document tests Temml math rendering with various LaTeX expressions.

## Inline Math

Einstein's famous equation: $E = mc^2$

The quadratic formula: $x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}$

Greek letters: $\alpha, \beta, \gamma, \Delta, \Omega$

Subscripts and superscripts: $x_1, x_2, x^2, x^{n+1}$

## Display Math (Block)

The Pythagorean theorem:

$$
a^2 + b^2 = c^2
$$

Quadratic formula with all steps:

$$
ax^2 + bx + c = 0 \implies x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}
$$

## Fractions and Complex Expressions

Nested fractions:

$$
\frac{1}{1 + \frac{1}{2 + \frac{1}{3}}}
$$

Binomial coefficient:

$$
\binom{n}{k} = \frac{n!}{k!(n-k)!}
$$

## Summations and Integrals

Summation notation:

$$
\sum_{i=1}^{n} i = \frac{n(n+1)}{2}
$$

Integral:

$$
\int_0^\infty e^{-x^2} dx = \frac{\sqrt{\pi}}{2}
$$

Multiple integrals:

$$
\iint_D f(x,y) \, dA
$$

## Matrices

2x2 Matrix:

$$
\begin{pmatrix}
a & b \\
c & d
\end{pmatrix}
$$

3x3 Identity Matrix:

$$
I = \begin{bmatrix}
1 & 0 & 0 \\
0 & 1 & 0 \\
0 & 0 & 1
\end{bmatrix}
$$

## Aligned Equations

$$
\begin{aligned}
f(x) &= (x+1)^2 \\
     &= x^2 + 2x + 1
\end{aligned}
$$

## Special Symbols and Accents

Limits: $\lim_{x \to \infty} f(x)$

Derivatives: $\frac{dy}{dx}, \frac{\partial f}{\partial x}$

Vector notation: $\vec{v}, \hat{u}$

Overline and underline: $\overline{AB}, \underline{text}$

## Trigonometry and Logarithms

$$
\sin^2\theta + \cos^2\theta = 1
$$

$$
e^{i\pi} + 1 = 0
$$

Natural logarithm: $\ln(x), \log_2(x)$

## Square Roots and Radicals

$$
\sqrt{2}, \quad \sqrt[3]{8}, \quad \sqrt{x^2 + y^2}
$$

## Mixed Inline and Block

The area of a circle with radius $r$ is given by:

$$
A = \pi r^2
$$

And the circumference is $C = 2\pi r$.

## Edge Cases

Empty inline: $$

Single character: $x$

Numbers only: $123 + 456 = 579$

Parentheses: $(a + b)(c + d) = ac + ad + bc + bd$
