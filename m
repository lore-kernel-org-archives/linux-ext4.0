Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03C9397B09;
	Mon, 12 Oct 2026 23:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791846744; cv=none; b=EAXpULTEmd8iKmf6FmpEt2kBaXyET6tss2KQJgdxG08wLAyFt9agVV6SLCmLCYQO+1nmGUIdTkk23fI9RXG6R3Di6SRTGd/aa9YXIQ5NB8I/RHYHmJen7FiJqdCEF66TBffRnyq1G4R7XQWuN0slxe5q5CWhHq2fSphyyVs2Ly8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791846744; c=relaxed/simple;
	bh=WuiZGD9HJDIwIqOF4+bnUymcl2EgwzNG0GKr4Mewi0Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GeUtu2XcEcxr7/OjFLevGNp2eevjB6APuUbWwv20iE2Ybb2Q/DI9D83HUleIDNavGYrmZtUpTFPyjdiEINqepRsUQyGRaNM8h3xMWpatV/89CAx3fKXthYBEdQzwelH5SuIFhQSYlEOrbkIDsQoAI4A/sg562sgQ6f+PRcdBhRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K9MbJrYn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K9MbJrYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE79B1F008A1;
	Mon, 12 Oct 2026 23:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791846742;
	bh=0tbNgtHEViWgRTsKN7TQ8sY7isFMNzaagThy05w1+S0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=K9MbJrYn6y57m0DVEXdCDRq3kjSeyySUDZqeeuTxJV4rv4hk24bLBew7uyaKl5CRv
	 UJeUcW0T+7iclAqoesVhRw351Er/vWPswDz6DWy797mSHWTRBtMJxcto9xYqAstvz5
	 K9xPl9VuULkZXNVXJVLu9ba5tvnr7a9mHZ+VQCYs2zcaPS829R+Xk7xwNxYs31Do9k
	 Lq3UCWBDOVXsSZZM1Cy+JS5LHkZZkVNLJfI4oKuNXnq7dcm9WLeoKDnaMZPbV1U+G9
	 mRxMvEzMTufpXJ0ep8aWdMPIgx+aFl5ffDd/AaSeDyUFldy19nuHSXhLw0qE3s/Myh
	 EMAZ8RBIcyC6w==
From: Mark <broonie@kernel.org>
Date: Tue, 13 Oct 2026 00:10:12 +0100
Subject: [PATCH 2/9] kunit: Add KUNIT_CASE_PARAM_UNIQUE() and
 KUNIT_CASE_PARAM_WITH_INIT_UNIQUE()
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-kunit-param-names-v1-2-4b22ec5b85b9@kernel.org>
References: <20261013-kunit-param-names-v1-0-4b22ec5b85b9@kernel.org>
In-Reply-To: <20261013-kunit-param-names-v1-0-4b22ec5b85b9@kernel.org>
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
 h=from:subject:message-id; bh=WuiZGD9HJDIwIqOF4+bnUymcl2EgwzNG0GKr4Mewi0Q=;
 b=owGbwMvMwCWm/754w+YLFp2Mp9WSGLLOZlo33YqpEdo+Y+PaXysLFVaG3a28P/20Sxe3pqnm9
 yLPsnkaHaUsDGJcDLJiiixxWdwv60ter+E7uLANZg4rE8gQBi5OAZjINDuGv4L5tzIrZnS/z/yR
 knSbl0HvwgXjtgPp1tcequbM/nShlZXhr+TrjeHBz5kmfRSZ1116uYPHbbvB+3N3TksXV57/pvG
 ThQsA
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
index da5312e0dfa5..e43f5e007f20 100644
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

