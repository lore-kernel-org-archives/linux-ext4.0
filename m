Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894524;
	b=NU7QW1JZdk4KJXwHfDfvjgxbaTnvRqtQlRJ9/foDoLluSbFB/06DUjjgij0XmX6NJp6U
	 CXKCA4MzzUQ+EN78gsloi8mcx5m2i+VPJEfu2wGpetbkmsSBM9x9cZNlTCuXwPw4LG4EY
	 33vqEhvDn6zRDPL0ruKfhoxHU7GotdX9KJQ6qGjq4bqPP+YVy1VP40AKEFdsXTIugRLNe
	 ItxMXeSt3LsGPO66a+cka0i7uBhVhe9O1ovi8Wtk3oqrwXdfbM6tv4iqRpTjhywXcvCQs
	 f9bIQptZXS82mZKHSvTcwCeokXcOWAu8EGk/fyolvpkCcmD7PRtRcsH11XBku6OFWag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894524;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=x1SCDPxmnNKrNbsHBv5YzrQ8i1IWDNs80oPwvUXJALY=;
	b=B5yoHUEHSkCvmS4ENa27TuzVpc0NC4hxb0xQhZ4d7y22Jr/C2SPIgj2bfg0PbZc4m6a2
	 AKKpyjJ7cxKVoQUkREqv1tboixbfPjKKhem4j1EJAFBiy5Bo3qS4ZWFqz88kYwlYH0xKU
	 epQ4o5LHQR6i1L2fvSvKgw1ltN+u4hXXPUoJFo54iSBKafG/11MfnzWOvVVTpgJHjcvf6
	 6dTsYNMsqb0uYC2+TMcq1zjnv/gFgJrU2VVWwpYV6uLbXaUhGy0pMDlijakmmd5frvZ1e
	 rPBU4s0xMCh2psxHbKqoE14Fz8hFj8jXCtcnz3FprV4+bDZU/eE9dSdsMwhwPUq/kSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dsjoRVhL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAED606B45C;
	Thu,  5 Nov 2026 16:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dsjoRVhL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157131F00A27;
	Thu,  5 Nov 2026 16:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894524;
	bh=x1SCDPxmnNKrNbsHBv5YzrQ8i1IWDNs80oPwvUXJALY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dsjoRVhLEuJyuNewSOtGL5g3UJlt1Ox0FKy17ZkJLWP90V71bgfBalr+cCncOOrkQ
	 192HINuwj+jJYu32w+l1cNw+/+sFFRKWGucVdnVFPqtQya3X/d+Cxwy+3mZja4Crta
	 F/sBgTJ4NnUYipE1D+jIIVf3giYsVhsOEgPfhyDxmfF0nFYaJSYDAfixLT+zKRNo2U
	 cqONTFVKUhy5BA3KAbCzmuk2nVCDHagc/e/xZUVM3jYvRPytL1p+J07rnp3TP8hOzq
	 tzFBAeIsadkvdMtvYO91QmWuyC9mCYyVnd7goqdFMQEo8VVe5u4hy+wAzCZ5ogrkHv
	 VXjXj2dc/TMRg==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 05 Nov 2026 16:00:29 +0000
Subject: [PATCH v2 2/9] kunit: Add KUNIT_CASE_PARAM_UNIQUE() and
 KUNIT_CASE_PARAM_WITH_INIT_UNIQUE()
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-kunit-param-names-v2-2-765b3d5275d2@kernel.org>
References: <20261105-kunit-param-names-v2-0-765b3d5275d2@kernel.org>
In-Reply-To: <20261105-kunit-param-names-v2-0-765b3d5275d2@kernel.org>
To: Simon Trimmer <simont@opensource.cirrus.com>, 
 Charles Keepax <ckeepax@opensource.cirrus.com>, 
 Richard Fitzgerald <rf@opensource.cirrus.com>, 
 Brendan Higgins <brendan.higgins@linux.dev>, David Gow <david@davidgow.net>, 
 Rae Moar <raemoar63@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Zhang Yi <yi.zhang@huawei.com>, David Rhodes <david.rhodes@cirrus.com>, 
 Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>, 
 Takashi Iwai <tiwai@suse.com>
Cc: patches@opensource.cirrus.com, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
 linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org, 
 linux-sound@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=5762; i=broonie@kernel.org;
 h=from:subject:message-id; bh=5TkRHF05z35VbZg0OCADibXZSxGx7uxiMfI1FA4xabA=;
 b=owGbwMvMwCWm/754w+YLFp2Mp9WSGLLerEjdFH9/pm54vIV+V9+pZRdeWCzOvWYn/VFVo/fiu
 hsyP0997ihlYRDjYpAVU2SJy+J+WV/yeg3fwYVtMHNYmUCGMHBxCsBERCoYGZ7tbOD0OySy6f5l
 M8H9S1+tlnv1I3CWMveVioU8Ikvl9f0YGdbd3j59VueZ2xNU+U88u1da6WA+49yRPYqHpr6beWN
 t621+AA==
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

KUNIT_CASE_PARAM() and KUNIT_CASE_PARAM_WITH_INIT() name the test case
after the test function. Several suites reuse one test function with
more than one parameter generator or param_init() function, listing it
once per set of parameters, which leads to multiple tests being created
with the same name. Same-named cases cannot be told apart in the results
and cannot be selected individually with kunit.filter_glob=, so kunit.py
--run_isolated=test boots a kernel for every entry and each kernel runs
all of the same-named cases.

We could fix this by having the KUNIT_CASE_PARAM() macros always include
the parameter name but this would not only rename all existing users but
also result in some awkwardly named tests. Instead introduce some new
macros for use in cases where we need to disambiguate.

Add KUNIT_CASE_PARAM_UNIQUE() and KUNIT_CASE_PARAM_WITH_INIT_UNIQUE()
which behave identically to the existing macros but include the name of
the parameter generator or the param_init() function in the name of
the case, giving names such as sha1_test-sha1_gen_params. The
param_init() function is used for the WITH_INIT variant since currently
all the tests which register parameter arrays from param_init() all
share the generic kunit_array_gen_params() generator.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 Documentation/dev-tools/kunit/usage.rst |  9 ++++++++
 include/kunit/test.h                    | 41 +++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/Documentation/dev-tools/kunit/usage.rst b/Documentation/dev-tools/kunit/usage.rst
index 1c78dfff94e8..193233fd2925 100644
--- a/Documentation/dev-tools/kunit/usage.rst
+++ b/Documentation/dev-tools/kunit/usage.rst
@@ -662,6 +662,15 @@ Custom Parameter Generator Function:
    You can pass the generator function to the ``KUNIT_CASE_PARAM``
    or ``KUNIT_CASE_PARAM_WITH_INIT`` macros.
 
+   These macros name the test case after the test function. If the same test
+   function is listed in a suite with more than one generator (or, for
+   ``KUNIT_CASE_PARAM_WITH_INIT``, more than one ``param_init()`` function)
+   use ``KUNIT_CASE_PARAM_UNIQUE`` or ``KUNIT_CASE_PARAM_WITH_INIT_UNIQUE``
+   instead. These also include the name of the generator or ``param_init()``
+   function in the test case name, for example ``sha1_test-sha1_gen_params``,
+   so that each case has a distinct name which can be selected with
+   ``kunit.filter_glob=``.
+
    The function receives the previously generated parameter as the ``prev`` argument
    (which is ``NULL`` on the first call) and can also access the parameterized
    test context passed as the ``test`` argument. KUnit calls this function
diff --git a/include/kunit/test.h b/include/kunit/test.h
index 31d549578f8e..b2d969c93855 100644
--- a/include/kunit/test.h
+++ b/include/kunit/test.h
@@ -209,6 +209,24 @@ static inline char *kunit_status_to_ok_not_ok(enum kunit_status status)
 		{ .run_case = test_name, .name = #test_name,	\
 		  .generate_params = gen_params, .module_name = KBUILD_MODNAME}
 
+/**
+ * KUNIT_CASE_PARAM_UNIQUE - A helper for creating a parameterized &struct
+ * kunit_case named after both the test and its parameter generator
+ *
+ * @test_name: a reference to a test case function.
+ * @gen_params: a reference to a parameter generator function.
+ *
+ * Identical to KUNIT_CASE_PARAM() except that the case is named
+ * "test_name-gen_params" rather than "test_name". Use this when the same
+ * test function is listed in a suite with more than one parameter generator,
+ * where KUNIT_CASE_PARAM() would give every instance the same name. Test
+ * names must be unique within a suite for the results to be unambiguous and
+ * for filters such as kunit.filter_glob= to be able to select a single case.
+ */
+#define KUNIT_CASE_PARAM_UNIQUE(test_name, gen_params)				\
+		{ .run_case = test_name, .name = #test_name "-" #gen_params,	\
+		  .generate_params = gen_params, .module_name = KBUILD_MODNAME}
+
 /**
  * KUNIT_CASE_PARAM_ATTR - A helper for creating a parameterized &struct
  * kunit_case with attributes
@@ -248,6 +266,29 @@ static inline char *kunit_status_to_ok_not_ok(enum kunit_status status)
 		  .param_init = init, .param_exit = exit,			\
 		  .module_name = KBUILD_MODNAME}
 
+/**
+ * KUNIT_CASE_PARAM_WITH_INIT_UNIQUE - Define a parameterized KUnit test case
+ * with custom param_init() and param_exit() functions, named after both the
+ * test and its param_init() function.
+ * @test_name: The function implementing the test case.
+ * @gen_params: The function to generate parameters for the test case.
+ * @init: A reference to the param_init() function to run before a parameterized test.
+ * @exit: A reference to the param_exit() function to run after a parameterized test.
+ *
+ * Identical to KUNIT_CASE_PARAM_WITH_INIT() except that the case is named
+ * "test_name-init" rather than "test_name". Use this when the same test
+ * function is listed in a suite with more than one param_init() function,
+ * where KUNIT_CASE_PARAM_WITH_INIT() would give every instance the same
+ * name. The param_init() function is used rather than the generator since
+ * tests registering parameter arrays in param_init() all share the generic
+ * kunit_array_gen_params() generator.
+ */
+#define KUNIT_CASE_PARAM_WITH_INIT_UNIQUE(test_name, gen_params, init, exit)	\
+		{ .run_case = test_name, .name = #test_name "-" #init,		\
+		  .generate_params = gen_params,				\
+		  .param_init = init, .param_exit = exit,			\
+		  .module_name = KBUILD_MODNAME}
+
 /**
  * struct kunit_suite - describes a related collection of &struct kunit_case
  *

-- 
2.47.3

