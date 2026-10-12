Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54573DAAC8;
	Mon, 12 Oct 2026 23:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791846772; cv=none; b=QRKosxqzKDDToZbkLbwuo/hMs37t/qdX7Olze2tF+rzDG87pQpWdO9qH1pPz3cK7VF3+a1Ag3g+FG3e6/JRkaeQr1qhVo7Y2CadddF1jrb9fA9Ib5fcmwNn0qv0KmefHk66S9bdF8SGjR3ia4wf51wPGzue0BiSAOBGDrtH9HPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791846772; c=relaxed/simple;
	bh=jy+FgEB+Ostl6u9PlpfOew93lEPzoJWO9gkmmIpDPIU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SnGKV7Uy5yCNpexhmnCH5I5viLzAJS4qbJrzJ8CnX7VugcEokEc0Zxer3ykkH4O8OmxHu2PGaXtwSLryGk9aRss1TjKmS6pUvP7CWZmJmR3OSsqQaop8p0l1TJBOiOAXUY5XR5M5GrdKQmgr0yGWJ+8ZO7pdu3pu1YV3L44Iv0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RkUI8JVm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RkUI8JVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAEB01F008A2;
	Mon, 12 Oct 2026 23:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791846770;
	bh=JxPv+Ub9abFUte3C+CFdCPjK8n9McqN8PXHgQONn9Dw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RkUI8JVmL8qE1JvHo5DXbgZr4sz2sG+2MMbnad3zHe97C5XzSLeRMLiH/TfVsW/Jh
	 kgDWnQ5+Hca3BUjmItwHH3UTieJC+Me5wfiSHwIzcdnqbl2NDv1znQrff4fX3eeXie
	 3yM+qbVUhUnK3ZAnHD5TLxci0hPWigkjAq6ajMQI8jw4NWRYgxKCbqlnHgsVI2JWaC
	 UA9iBhT1BcnsEij1YV/WPDnU3V7xYeRC8V9xleetaw28ouQDxR4t+qcX5ekYgGBo3G
	 H3wYQuekI+O/yNjZ51DbwIOlNZDTboVff7xDSHPtAMluBWPraP9IJL7Dw7PtvGlB5a
	 eWIEhPlDkHGhQ==
From: Mark <broonie@kernel.org>
Date: Tue, 13 Oct 2026 00:10:17 +0100
Subject: [PATCH 7/9] firmware: cs_dsp: Give the bin file KUnit cases
 distinct names
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-kunit-param-names-v1-7-4b22ec5b85b9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=16871; i=broonie@kernel.org;
 h=from:subject:message-id; bh=jy+FgEB+Ostl6u9PlpfOew93lEPzoJWO9gkmmIpDPIU=;
 b=owGbwMvMwCWm/754w+YLFp2Mp9WSGLLOZlqvmeL3tzSo9DFX2LVJLhfO8hyqNnNWX3rdwebxo
 u83/jGwdpSyMIhxMciKKbLEZXG/rC95vYbv4MI2mDmsTCBDGLg4BWAi9i4Mf0UiZA58muSc6jOh
 eD674aEP5042nuEy6pkf8vFfxdnyXHZGhqsLah3n9mcwfDjxqHvF4aZt5jFhkxofzpvto5yh0WX
 IxA0A
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

The cs_dsp_bin suites run many of their test functions against more
than one set of parameters, listing the function once per set with
KUNIT_CASE_PARAM(), which names the case after the function:

 - the ADSP2 suites run the XM/YM tests again for ZM,
 - the WMDR v3 suite runs the whole set again with long offset blocks,
 - the multiple memory tests are run varying the offset and the
   algorithm.

The resulting cases share a name, so they cannot be told apart in the
results.

Use KUNIT_CASE_PARAM_UNIQUE() for these entries so that each case is
also named for the parameter generator it is run with, for example
bin_patch_one_word-x_or_y_and_offset_gen_params and
bin_patch_one_word-z_and_offset_gen_params.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/firmware/cirrus/test/cs_dsp_test_bin.c | 222 ++++++++++++-------------
 1 file changed, 111 insertions(+), 111 deletions(-)

diff --git a/drivers/firmware/cirrus/test/cs_dsp_test_bin.c b/drivers/firmware/cirrus/test/cs_dsp_test_bin.c
index 63416838f865..40a827120d6c 100644
--- a/drivers/firmware/cirrus/test/cs_dsp_test_bin.c
+++ b/drivers/firmware/cirrus/test/cs_dsp_test_bin.c
@@ -2654,8 +2654,8 @@ static struct kunit_case cs_dsp_bin_test_cases_halo[] = {
 	KUNIT_CASE_PARAM(bin_patch_one_multiword, x_or_y_and_offset_gen_params),
 	KUNIT_CASE_PARAM(bin_patch_multi_oneword, x_or_y_and_offset_gen_params),
 	KUNIT_CASE_PARAM(bin_patch_multi_oneword_unordered, x_or_y_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_one_word_multiple_mems, offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_one_word_multiple_mems, alg_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_one_word_multiple_mems, offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_one_word_multiple_mems, alg_gen_params),
 	KUNIT_CASE_PARAM(bin_patch_multi_oneword_sparse_unordered, x_or_y_and_alg_gen_params),
 	KUNIT_CASE_PARAM(bin_patch_one_word_multiple_algs, x_or_y_and_offset_gen_params),
 	KUNIT_CASE_PARAM(bin_patch_one_word_multiple_algs_unordered, x_or_y_and_offset_gen_params),
@@ -2687,8 +2687,8 @@ static struct kunit_case cs_dsp_bin_test_cases_halo[] = {
 			 packed_x_or_y_and_offset_gen_params),
 	KUNIT_CASE_PARAM(bin_patch_multi_onepacked_unordered,
 			 packed_x_or_y_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_1_packed_multiple_mems, offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_1_packed_multiple_mems, alg_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_1_packed_multiple_mems, offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_1_packed_multiple_mems, alg_gen_params),
 	KUNIT_CASE_PARAM(bin_patch_multi_onepacked_sparse_unordered,
 			 packed_x_or_y_and_alg_gen_params),
 	KUNIT_CASE_PARAM(bin_patch_1_packed_multiple_algs,
@@ -2705,103 +2705,100 @@ static struct kunit_case cs_dsp_bin_test_cases_halo[] = {
 
 static struct kunit_case cs_dsp_bin_test_cases_halo_wmdr3[] = {
 	/* Unpacked memory */
-	KUNIT_CASE_PARAM(bin_patch_one_word, x_or_y_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_one_multiword, x_or_y_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_multi_oneword, x_or_y_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_multi_oneword_unordered, x_or_y_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_one_word_multiple_mems, offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_one_word_multiple_mems, alg_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_multi_oneword_sparse_unordered, x_or_y_and_alg_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_one_word_multiple_algs, x_or_y_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_one_word_multiple_algs_unordered, x_or_y_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_one_word, x_or_y_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_one_multiword, x_or_y_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_multi_oneword, x_or_y_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_multi_oneword_unordered, x_or_y_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_one_word_multiple_mems, offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_one_word_multiple_mems, alg_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_multi_oneword_sparse_unordered,
+				x_or_y_and_alg_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_one_word_multiple_algs, x_or_y_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_one_word_multiple_algs_unordered,
+				x_or_y_and_offset_gen_params),
 
 	/* Packed memory tests */
-	KUNIT_CASE_PARAM(bin_patch_1_packed,
-			 packed_x_or_y_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_1_packed_1_single_trailing,
-			 packed_x_or_y_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_1_packed_2_single_trailing,
-			 packed_x_or_y_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_1_packed_3_single_trailing,
-			 packed_x_or_y_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_1_packed_2_trailing,
-			 packed_x_or_y_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_1_packed_3_trailing,
-			 packed_x_or_y_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_1_single_leading_1_packed,
-			 packed_x_or_y_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_2_single_leading_1_packed,
-			 packed_x_or_y_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_2_leading_1_packed,
-			 packed_x_or_y_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_3_single_leading_1_packed,
-			 packed_x_or_y_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_3_leading_1_packed,
-			 packed_x_or_y_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_multi_onepacked,
-			 packed_x_or_y_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_multi_onepacked_unordered,
-			 packed_x_or_y_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_1_packed_multiple_mems, offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_1_packed_multiple_mems, alg_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_multi_onepacked_sparse_unordered,
-			 packed_x_or_y_and_alg_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_1_packed_multiple_algs,
-			 packed_x_or_y_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_1_packed_multiple_algs_unordered,
-			 packed_x_or_y_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_mixed_packed_unpacked_random,
-			 packed_x_or_y_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_1_packed, packed_x_or_y_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_1_packed_1_single_trailing,
+				packed_x_or_y_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_1_packed_2_single_trailing,
+				packed_x_or_y_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_1_packed_3_single_trailing,
+				packed_x_or_y_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_1_packed_2_trailing, packed_x_or_y_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_1_packed_3_trailing, packed_x_or_y_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_1_single_leading_1_packed,
+				packed_x_or_y_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_2_single_leading_1_packed,
+				packed_x_or_y_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_2_leading_1_packed, packed_x_or_y_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_3_single_leading_1_packed,
+				packed_x_or_y_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_3_leading_1_packed, packed_x_or_y_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_multi_onepacked, packed_x_or_y_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_multi_onepacked_unordered,
+				packed_x_or_y_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_1_packed_multiple_mems, offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_1_packed_multiple_mems, alg_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_multi_onepacked_sparse_unordered,
+				packed_x_or_y_and_alg_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_1_packed_multiple_algs,
+				packed_x_or_y_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_1_packed_multiple_algs_unordered,
+				packed_x_or_y_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_mixed_packed_unpacked_random, packed_x_or_y_gen_params),
 
 	/* Unpacked memory with long-offset blocks */
-	KUNIT_CASE_PARAM(bin_patch_one_word, x_or_y_and_long_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_one_multiword, x_or_y_and_long_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_multi_oneword, x_or_y_and_long_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_multi_oneword_unordered, x_or_y_and_long_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_one_word_multiple_mems, long_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_one_word_multiple_mems, alg_long_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_multi_oneword_sparse_unordered, x_or_y_and_alg_long_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_one_word_multiple_algs, x_or_y_and_long_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_one_word_multiple_algs_unordered,
-			   x_or_y_and_long_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_one_word, x_or_y_and_long_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_one_multiword, x_or_y_and_long_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_multi_oneword, x_or_y_and_long_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_multi_oneword_unordered,
+				x_or_y_and_long_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_one_word_multiple_mems, long_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_one_word_multiple_mems, alg_long_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_multi_oneword_sparse_unordered,
+				x_or_y_and_alg_long_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_one_word_multiple_algs,
+				x_or_y_and_long_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_one_word_multiple_algs_unordered,
+				x_or_y_and_long_offset_gen_params),
 
 	/* Packed memory tests with long offset blocks */
-	KUNIT_CASE_PARAM(bin_patch_1_packed,
-			 packed_x_or_y_and_long_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_1_packed_1_single_trailing,
-			 packed_x_or_y_and_long_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_1_packed_2_single_trailing,
-			 packed_x_or_y_and_long_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_1_packed_3_single_trailing,
-			 packed_x_or_y_and_long_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_1_packed_2_trailing,
-			 packed_x_or_y_and_long_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_1_packed_3_trailing,
-			 packed_x_or_y_and_long_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_1_single_leading_1_packed,
-			 packed_x_or_y_and_long_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_2_single_leading_1_packed,
-			 packed_x_or_y_and_long_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_2_leading_1_packed,
-			 packed_x_or_y_and_long_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_3_single_leading_1_packed,
-			 packed_x_or_y_and_long_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_3_leading_1_packed,
-			 packed_x_or_y_and_long_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_multi_onepacked,
-			 packed_x_or_y_and_long_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_multi_onepacked_unordered,
-			 packed_x_or_y_and_long_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_1_packed_multiple_mems, long_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_1_packed_multiple_mems, alg_long_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_multi_onepacked_sparse_unordered,
-			 packed_x_or_y_and_alg_long_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_1_packed_multiple_algs,
-			 packed_x_or_y_and_long_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_1_packed_multiple_algs_unordered,
-			 packed_x_or_y_and_long_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_mixed_packed_unpacked_random,
-			 packed_x_or_y_long_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_1_packed, packed_x_or_y_and_long_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_1_packed_1_single_trailing,
+				packed_x_or_y_and_long_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_1_packed_2_single_trailing,
+				packed_x_or_y_and_long_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_1_packed_3_single_trailing,
+				packed_x_or_y_and_long_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_1_packed_2_trailing,
+				packed_x_or_y_and_long_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_1_packed_3_trailing,
+				packed_x_or_y_and_long_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_1_single_leading_1_packed,
+				packed_x_or_y_and_long_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_2_single_leading_1_packed,
+				packed_x_or_y_and_long_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_2_leading_1_packed,
+				packed_x_or_y_and_long_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_3_single_leading_1_packed,
+				packed_x_or_y_and_long_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_3_leading_1_packed,
+				packed_x_or_y_and_long_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_multi_onepacked,
+				packed_x_or_y_and_long_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_multi_onepacked_unordered,
+				packed_x_or_y_and_long_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_1_packed_multiple_mems, long_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_1_packed_multiple_mems, alg_long_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_multi_onepacked_sparse_unordered,
+				packed_x_or_y_and_alg_long_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_1_packed_multiple_algs,
+				packed_x_or_y_and_long_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_1_packed_multiple_algs_unordered,
+				packed_x_or_y_and_long_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_mixed_packed_unpacked_random,
+				packed_x_or_y_long_gen_params),
 
 	KUNIT_CASE(bin_patch_name_and_info),
 
@@ -2810,26 +2807,29 @@ static struct kunit_case cs_dsp_bin_test_cases_halo_wmdr3[] = {
 
 static struct kunit_case cs_dsp_bin_test_cases_adsp2[] = {
 	/* XM and YM */
-	KUNIT_CASE_PARAM(bin_patch_one_word, x_or_y_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_one_multiword, x_or_y_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_multi_oneword, x_or_y_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_multi_oneword_unordered, x_or_y_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_multi_oneword_sparse_unordered, x_or_y_and_alg_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_one_word_multiple_algs, x_or_y_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_one_word_multiple_algs_unordered, x_or_y_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_one_word, x_or_y_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_one_multiword, x_or_y_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_multi_oneword, x_or_y_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_multi_oneword_unordered, x_or_y_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_multi_oneword_sparse_unordered,
+				x_or_y_and_alg_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_one_word_multiple_algs, x_or_y_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_one_word_multiple_algs_unordered,
+				x_or_y_and_offset_gen_params),
 
 	/* ZM */
-	KUNIT_CASE_PARAM(bin_patch_one_word, z_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_one_multiword, z_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_multi_oneword, z_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_multi_oneword_unordered, z_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_multi_oneword_sparse_unordered, z_and_alg_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_one_word_multiple_algs, z_and_offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_one_word_multiple_algs_unordered, z_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_one_word, z_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_one_multiword, z_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_multi_oneword, z_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_multi_oneword_unordered, z_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_multi_oneword_sparse_unordered, z_and_alg_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_one_word_multiple_algs, z_and_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_one_word_multiple_algs_unordered,
+				z_and_offset_gen_params),
 
 	/* Other */
-	KUNIT_CASE_PARAM(bin_patch_one_word_multiple_mems, offset_gen_params),
-	KUNIT_CASE_PARAM(bin_patch_one_word_multiple_mems, alg_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_one_word_multiple_mems, offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(bin_patch_one_word_multiple_mems, alg_gen_params),
 
 	KUNIT_CASE(bin_patch_name_and_info),
 

-- 
2.47.3

