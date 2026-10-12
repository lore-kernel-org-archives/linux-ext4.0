Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F36C3D9DDE;
	Mon, 12 Oct 2026 23:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791846749; cv=none; b=QzEp55cEJFk8MlHvMGeeiZmShK8eFnrmxd2bIT+MJuGQ1DrYPue3rcLrPxAYtBHWYo7iPpCVm+OlBl3J3H0fxoqfiBOZFW91FW+7bb81cUSAGmptw4vo/kqj77ZWhbH0f585TOFYLwu+VEU2LTWBZ7/Ol/NfC2Z1R9NGjzClFRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791846749; c=relaxed/simple;
	bh=LNiSkc+l44F1CNMFar4p5MSEuORzy/KrMOUckNW0Fl8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NSUwJkh1mrxDPurLqlgVtjAmEHWdueMq/XRbIxVOZTT0butFhM+8XPr3oc3pkmATYy7HfBVlcxrUdSH2dpQ9A2lPCFYqVjk+wUfDZITj4J30kXJM61Pa8DL859jSP0p7RVfQ8ssXfpBa/dfo5frBRI7N/qN5QHvvdXs0iyNjq0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FnXQ5IGt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FnXQ5IGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487C61F008A2;
	Mon, 12 Oct 2026 23:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791846748;
	bh=cTm9lF3SIW4dpzW4FrKnPGedoaeqZzRXpuYRh4YqDEg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FnXQ5IGtXcPV3vQ09/AwKy22Lt7iD+Y7Qg1u/zJCL8ENovI15vuWGnystNIu22Vj9
	 ISIESCw4y3v0WgDWu40rqiLlcjrsqYsaC1FFLivWxe/I6Xt5RifviQ+LRksUFAHeEi
	 qe5SsJor6wF+L6oKVzTrYMrG8yGLAylqm2AC96CNQ9Q/ufgolUJWoQkbVtjF5z60Vm
	 UNA+vUuzsAna/0oSJWfTvqLv41ui1oqXmmPgFhRiUgyclQoLY6Ff2+dRJ5WWxZkauI
	 J1OX9/HunW4ESSWdOxCynA45bKTyGHiINg4Lmj1FED2bv/YYaILJXv9fID4mq+7oIZ
	 agVyFlITFbKdw==
From: Mark <broonie@kernel.org>
Date: Tue, 13 Oct 2026 00:10:13 +0100
Subject: [PATCH 3/9] ext4: Give the extents KUnit cases distinct names
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-kunit-param-names-v1-3-4b22ec5b85b9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1883; i=broonie@kernel.org;
 h=from:subject:message-id; bh=LNiSkc+l44F1CNMFar4p5MSEuORzy/KrMOUckNW0Fl8=;
 b=owGbwMvMwCWm/754w+YLFp2Mp9WSGLLOZlpPMdUv27mw1Db2qhqnq/StU1wfGpR0e/XeSWY0i
 gqv3PSqo5SFQYyLQVZMkSUui/tlfcnrNXwHF7bBzGFlAhnCwMUpABPpZGT4Z/vWql/y5ef1D1fM
 m1x3+NdVvrx6x+1cdSl//dU/f1PqaWT4X7Q/LHbJ3icGdo5/5eZZK020yN+zsaXcP2HpN59vZlO
 4WQE=
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

The ext4_extents_test suite runs test_split_convert() against three
different parameter arrays by listing it three times with
KUNIT_CASE_PARAM_WITH_INIT(), which names each case after the function.
All three cases are therefore called test_split_convert, so they cannot
be told apart in the results.

Use KUNIT_CASE_PARAM_WITH_INIT_UNIQUE() for these entries so that each
case is also named for the param_init() function which registers its
parameter array, for example
test_split_convert-test_convert_initialized_param_init.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 fs/ext4/extents-test.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
index c3836ecb89f9..5e70542b718b 100644
--- a/fs/ext4/extents-test.c
+++ b/fs/ext4/extents-test.c
@@ -1043,12 +1043,12 @@ static int test_handle_unwritten_init(struct kunit *test)
  * https://lore.kernel.org/linux-kselftest/aULJpTvJDw9ctUDe@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com/
  */
 static struct kunit_case extents_test_cases[] = {
-	KUNIT_CASE_PARAM_WITH_INIT(test_split_convert, kunit_array_gen_params,
-				   test_split_convert_param_init, NULL),
-	KUNIT_CASE_PARAM_WITH_INIT(test_split_convert, kunit_array_gen_params,
-				   test_convert_initialized_param_init, NULL),
-	KUNIT_CASE_PARAM_WITH_INIT(test_split_convert, kunit_array_gen_params,
-				   test_handle_unwritten_init, NULL),
+	KUNIT_CASE_PARAM_WITH_INIT_UNIQUE(test_split_convert, kunit_array_gen_params,
+					  test_split_convert_param_init, NULL),
+	KUNIT_CASE_PARAM_WITH_INIT_UNIQUE(test_split_convert, kunit_array_gen_params,
+					  test_convert_initialized_param_init, NULL),
+	KUNIT_CASE_PARAM_WITH_INIT_UNIQUE(test_split_convert, kunit_array_gen_params,
+					  test_handle_unwritten_init, NULL),
 	{}
 };
 

-- 
2.47.3

