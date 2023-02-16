# SPDX-License-Identifier: Apache-2.0
# pylint: disable=W0221

import numpy as np

from ._op import OpRunUnaryNum


class Softmax(OpRunUnaryNum):
    def _run(self, X, axis=None):  # type: ignore
        axis = axis or self.axis  # type: ignore
        tmp = X - X.max(axis=axis, keepdims=1)  # type: ignore
        Y = np.exp(tmp)
        Y /= Y.sum(axis=axis, keepdims=1)  # type: ignore
        return (Y.astype(X.dtype),)