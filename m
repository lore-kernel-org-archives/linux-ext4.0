Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADED0397B09;
	Mon, 12 Oct 2026 23:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791846762; cv=none; b=OBwpRnVpu/S6SoHzeSCDMl3JtfZB4Lxhqsuob2HnXLlLkFLBiCwGxI1kvcgy895q28kTjqPldR2l6elzLcztxnhxPfWecIxXP7ADhOVzs3KKqNOuMd23LahIBOUCBbCuapgCWHpiF0MHTmjMCuneHHJIOfvpKqQ0Fmr08+yC56w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791846762; c=relaxed/simple;
	bh=D+rLdKs8LbigS4VPRZszv6toc9HonorZ8w9ZXpKACug=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=my6T0OkUKEogsFN6bg4Sg+qU8ZB0PnjWuiDL9QqjZVm3zcplacL+VOIxnLgIDqpIGSdwjAioev+rfpsuGHIIN623RpL+oLlQ/+1pNovA4Rc2TV8YQGsV5wyVmfiBDol5PocqIQRKOhAUaNfhi4YO6PpZMsXAhYPT+iyjY7H8m3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mBfUlrwa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mBfUlrwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683E01F008A2;
	Mon, 12 Oct 2026 23:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791846760;
	bh=fMe8LMS2I1pbu8u+4zGMMHT6c8nXOjTiyQHao+T7Ip0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mBfUlrwav+V99yMsEMtc1WbF6gGxMWWaDUiFqFPlCanONdWwSkYRfqeyTsevgbSHg
	 EnQpyInlCtjg06OwppU04d7wSkDYGbcbC31OZJIp7/GvRCdgcWH1FGN7jVEgmvP0FA
	 vMJENjdOTcM/YYsJABS+paHrVIRMCwVVIRNPalFfp6iz5nvay0oDCG8W1cICnFwiDf
	 f5doLJWPf7zw/WT/AaedfV/M5hk2JCFcvOU98+hzHqBnPLe4ZhWVYx5f6tAkgun3iU
	 n6CK8fXSaSpBJBnpAdXwLa714ZMZchtwpUld9eaS0hGQgxgsgJBgIT1MO/23DdolTZ
	 909/PpxnPWWYQ==
From: Mark <broonie@kernel.org>
Date: Tue, 13 Oct 2026 00:10:15 +0100
Subject: [PATCH 5/9] firmware: cs_dsp: Give the control cache KUnit cases
 distinct names
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-kunit-param-names-v1-5-4b22ec5b85b9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=12227; i=broonie@kernel.org;
 h=from:subject:message-id; bh=D+rLdKs8LbigS4VPRZszv6toc9HonorZ8w9ZXpKACug=;
 b=owGbwMvMwCWm/754w+YLFp2Mp9WSGLLOZlrfn2PcsvFNooRzqBPjij0rm4WS3/ofzLC6+LVd8
 VQOg4ZtRykLgxgXg6yYIktcFvfL+pLXa/gOLmyDmcPKBDKEgYtTACZi95uRYbHFo4B758tyHaPs
 I+yfJc66Z+H5bU2mHnfLnIv8a959OsHwP/aoZSO7+LPyQ8ypT25eD3Hqtfl74/vpqqmzb4lZ60/
 x4wYA
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

The cs_dsp_ctl_cache suites run cs_dsp_ctl_cache_init(),
cs_dsp_ctl_cache_writethrough() and
cs_dsp_ctl_cache_writethrough_unchanged() against several sets of
parameters by listing each function several times with
KUNIT_CASE_PARAM(), which names the case after the function. The
resulting cases all share a name, so they cannot be told apart in the
results.

Use KUNIT_CASE_PARAM_UNIQUE() for these entries so that each case is
also named for the parameter generator it is run with, for example
cs_dsp_ctl_cache_init-all_pop_varying_len_gen_params.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 .../cirrus/test/cs_dsp_test_control_cache.c        | 143 +++++++++++----------
 1 file changed, 72 insertions(+), 71 deletions(-)

diff --git a/drivers/firmware/cirrus/test/cs_dsp_test_control_cache.c b/drivers/firmware/cirrus/test/cs_dsp_test_control_cache.c
index b03cd7c37f6e..0a072063dfa7 100644
--- a/drivers/firmware/cirrus/test/cs_dsp_test_control_cache.c
+++ b/drivers/firmware/cirrus/test/cs_dsp_test_control_cache.c
@@ -2987,12 +2987,12 @@ KUNIT_ARRAY_PARAM(all_pop_nonvol_write_only_length,
 		  cs_dsp_ctl_all_param_desc);
 
 static struct kunit_case cs_dsp_ctl_cache_test_cases_v1[] = {
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_init, all_pop_varying_len_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_init, all_pop_varying_offset_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_init, all_pop_varying_xy_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_init, all_pop_z_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_init, all_pop_varying_alg_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_init, all_pop_nonvol_readable_flags_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_init, all_pop_varying_len_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_init, all_pop_varying_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_init, all_pop_varying_xy_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_init, all_pop_z_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_init, all_pop_varying_alg_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_init, all_pop_nonvol_readable_flags_gen_params),
 
 	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_init_write_only,
 			 all_pop_nonvol_write_only_length_gen_params),
@@ -3019,25 +3019,25 @@ static struct kunit_case cs_dsp_ctl_cache_test_cases_v1[] = {
 	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_read_running_zero_flags,
 			 all_pop_varying_len_gen_params),
 
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough, all_pop_varying_len_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough, all_pop_varying_offset_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough, all_pop_varying_xy_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough, all_pop_z_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough, all_pop_varying_alg_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough, all_pop_nonvol_writeable_flags_gen_params),
-
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough_unchanged,
-			 all_pop_varying_len_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough_unchanged,
-			 all_pop_varying_offset_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough_unchanged,
-			 all_pop_varying_xy_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough_unchanged,
-			 all_pop_z_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough_unchanged,
-			 all_pop_varying_alg_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough_unchanged,
-			 all_pop_nonvol_writeable_flags_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough, all_pop_varying_len_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough, all_pop_varying_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough, all_pop_varying_xy_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough, all_pop_z_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough, all_pop_varying_alg_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough,
+				all_pop_nonvol_writeable_flags_gen_params),
+
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough_unchanged,
+				all_pop_varying_len_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough_unchanged,
+				all_pop_varying_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough_unchanged,
+				all_pop_varying_xy_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough_unchanged, all_pop_z_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough_unchanged,
+				all_pop_varying_alg_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough_unchanged,
+				all_pop_nonvol_writeable_flags_gen_params),
 
 	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_write_unchanged_not_started,
 			 all_pop_nonvol_writeable_flags_gen_params),
@@ -3075,12 +3075,12 @@ static struct kunit_case cs_dsp_ctl_cache_test_cases_v1[] = {
 static struct kunit_case cs_dsp_ctl_cache_test_cases_v2[] = {
 	KUNIT_CASE(cs_dsp_ctl_v2_cache_alloc),
 
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_init, all_pop_varying_len_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_init, all_pop_varying_offset_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_init, all_pop_varying_xy_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_init, all_pop_z_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_init, all_pop_varying_alg_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_init, all_pop_nonvol_readable_flags_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_init, all_pop_varying_len_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_init, all_pop_varying_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_init, all_pop_varying_xy_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_init, all_pop_z_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_init, all_pop_varying_alg_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_init, all_pop_nonvol_readable_flags_gen_params),
 
 	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_init_write_only,
 			 all_pop_nonvol_write_only_length_gen_params),
@@ -3108,25 +3108,25 @@ static struct kunit_case cs_dsp_ctl_cache_test_cases_v2[] = {
 	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_read_running_zero_flags,
 			 all_pop_varying_len_gen_params),
 
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough, all_pop_varying_len_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough, all_pop_varying_offset_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough, all_pop_varying_xy_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough, all_pop_z_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough, all_pop_varying_alg_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough, all_pop_nonvol_writeable_flags_gen_params),
-
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough_unchanged,
-			 all_pop_varying_len_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough_unchanged,
-			 all_pop_varying_offset_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough_unchanged,
-			 all_pop_varying_xy_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough_unchanged,
-			 all_pop_z_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough_unchanged,
-			 all_pop_varying_alg_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough_unchanged,
-			 all_pop_nonvol_writeable_flags_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough, all_pop_varying_len_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough, all_pop_varying_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough, all_pop_varying_xy_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough, all_pop_z_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough, all_pop_varying_alg_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough,
+				all_pop_nonvol_writeable_flags_gen_params),
+
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough_unchanged,
+				all_pop_varying_len_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough_unchanged,
+				all_pop_varying_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough_unchanged,
+				all_pop_varying_xy_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough_unchanged, all_pop_z_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough_unchanged,
+				all_pop_varying_alg_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough_unchanged,
+				all_pop_nonvol_writeable_flags_gen_params),
 
 	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_write_unchanged_not_started,
 			 all_pop_nonvol_writeable_flags_gen_params),
@@ -3164,11 +3164,11 @@ static struct kunit_case cs_dsp_ctl_cache_test_cases_v2[] = {
 static struct kunit_case cs_dsp_ctl_cache_test_cases_v3[] = {
 	KUNIT_CASE(cs_dsp_ctl_v2_cache_alloc),
 
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_init, all_pop_varying_len_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_init, all_pop_varying_offset_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_init, all_pop_varying_xy_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_init, all_pop_varying_alg_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_init, all_pop_nonvol_readable_flags_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_init, all_pop_varying_len_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_init, all_pop_varying_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_init, all_pop_varying_xy_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_init, all_pop_varying_alg_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_init, all_pop_nonvol_readable_flags_gen_params),
 
 	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_init_write_only,
 			 all_pop_nonvol_write_only_length_gen_params),
@@ -3194,22 +3194,23 @@ static struct kunit_case cs_dsp_ctl_cache_test_cases_v3[] = {
 	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_read_running,
 			 all_pop_nonvol_readable_nonzero_flags_gen_params),
 
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough, all_pop_varying_len_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough, all_pop_varying_offset_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough, all_pop_varying_xy_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough, all_pop_varying_alg_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough, all_pop_nonvol_writeable_flags_gen_params),
-
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough_unchanged,
-			 all_pop_varying_len_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough_unchanged,
-			 all_pop_varying_offset_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough_unchanged,
-			 all_pop_varying_xy_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough_unchanged,
-			 all_pop_varying_alg_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_writethrough_unchanged,
-			 all_pop_nonvol_writeable_flags_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough, all_pop_varying_len_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough, all_pop_varying_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough, all_pop_varying_xy_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough, all_pop_varying_alg_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough,
+				all_pop_nonvol_writeable_flags_gen_params),
+
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough_unchanged,
+				all_pop_varying_len_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough_unchanged,
+				all_pop_varying_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough_unchanged,
+				all_pop_varying_xy_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough_unchanged,
+				all_pop_varying_alg_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_cache_writethrough_unchanged,
+				all_pop_nonvol_writeable_flags_gen_params),
 
 	KUNIT_CASE_PARAM(cs_dsp_ctl_cache_write_unchanged_not_started,
 			 all_pop_nonvol_writeable_flags_gen_params),

-- 
2.47.3

