Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5203D7D9C;
	Mon, 12 Oct 2026 23:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791846756; cv=none; b=GOVDQ6C6c9UGfZ0eceFQaXeK5qSYnC/1U+lyxy+0V0GoQm+TCBil5zBG2r+SXW976+8PBTTKpSJe6+ei9mfWPy4CyjgDVJBj7+loyCqxwj8H9izREQfcVB0vdO+LyknmQ6EwjmCThLHolikj/hVs6a4MYGN8V+g/NLvhJ6LTgYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791846756; c=relaxed/simple;
	bh=usWP1F3S+Estwtek87LnMwkh5fvzdHdn+o6NTjpIAF8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rrVHC9C3UU1CFYKs7VkS7q9ZBzEbxpNzuNdIBVPASCuLwIs3SGjop1U1I65EyWVqdsg9Q/r0h0m6xhMFh1REc4wXGIn3D37YULvCo9vKSMLyrrKx8LVfn2OL9iH8m/6OAd0QEc0gS7r6TQEKS4E9l9Rq2fajmmM6UBUo0c09JjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IAZ5n3h+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IAZ5n3h+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7100D1F008A1;
	Mon, 12 Oct 2026 23:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791846755;
	bh=d0U/i3xiCgDVx+ljKXCkP/QAHFtITrmEyTUiU58k61w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IAZ5n3h+GYATCzn1s+zjVM89x4uDa48spMBV+pCKYQcz5xaPbx14l5QJXwlDwx5cy
	 5oCJOxEchtgq4y1R33zUkBcxsHgyjgnfEMfSzc6XJcCegvjX/D9ENRSf2ZeHyYvIyM
	 YXqAO0um0229i+YTEGDW3Gvl0SBPFhfjpSfd4E0f2Kc+SDsQFjXLqr3xw9Qw4mHXif
	 Et+daoCDck+ZO6bN5q1xAXTyM2XNKlPxHW+hpE8ejn5C723yLNs9VUz2A25wx81/mg
	 UA8hzipI6u9ib5AlyrBxVuQyfOWsriWB5AsY0Mq9CbdsoD8oGQTyIO2YPyOf2REZdt
	 o6LUqWoSwAcqw==
From: Mark <broonie@kernel.org>
Date: Tue, 13 Oct 2026 00:10:14 +0100
Subject: [PATCH 4/9] firmware: cs_dsp: Give the control read/write KUnit
 cases distinct names
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-kunit-param-names-v1-4-4b22ec5b85b9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5103; i=broonie@kernel.org;
 h=from:subject:message-id; bh=usWP1F3S+Estwtek87LnMwkh5fvzdHdn+o6NTjpIAF8=;
 b=owGbwMvMwCWm/754w+YLFp2Mp9WSGLLOZlpLHlzWpyQ064zheU6HY2+bz6b2Rvw+dY1ro+26R
 5/uOTw92FHKwiDGxSArpsgSl8X9sr7k9Rq+gwvbYOawMoEMYeDiFICJfLrEyHBtevTXZ/YbJ7ku
 4RHm+qLM55q4Y2dlzoS/vOaX2vZtS3/DyPBN2eGsZW7Z86+/F/W9LV9xRTQgeEbZqsXvHa4enOd
 /6BkDAA==
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

The cs_dsp_ctl_rw suites run cs_dsp_ctl_write_running() and
cs_dsp_ctl_read_volatile_running() against several sets of parameters
by listing each function several times with KUNIT_CASE_PARAM(), which
names the case after the function. The resulting cases all share a
name, so they cannot be told apart in the results.

Use KUNIT_CASE_PARAM_UNIQUE() for these entries so that each case is
also named for the parameter generator it is run with, for example
cs_dsp_ctl_write_running-all_pop_varying_len_gen_params.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 .../firmware/cirrus/test/cs_dsp_test_control_rw.c  | 50 +++++++++++-----------
 1 file changed, 26 insertions(+), 24 deletions(-)

diff --git a/drivers/firmware/cirrus/test/cs_dsp_test_control_rw.c b/drivers/firmware/cirrus/test/cs_dsp_test_control_rw.c
index d800f163b099..085a1cb92912 100644
--- a/drivers/firmware/cirrus/test/cs_dsp_test_control_rw.c
+++ b/drivers/firmware/cirrus/test/cs_dsp_test_control_rw.c
@@ -2483,19 +2483,20 @@ KUNIT_ARRAY_PARAM(all_pop_volatile_writeable_flags,
 		  cs_dsp_ctl_all_param_desc);
 
 static struct kunit_case cs_dsp_ctl_rw_test_cases_adsp[] = {
-	KUNIT_CASE_PARAM(cs_dsp_ctl_write_running, all_pop_varying_len_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_write_running, all_pop_varying_offset_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_write_running, all_pop_varying_xy_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_write_running, all_pop_z_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_write_running, all_pop_varying_alg_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_write_running, all_pop_writeable_flags_gen_params),
-
-	KUNIT_CASE_PARAM(cs_dsp_ctl_read_volatile_running, all_pop_varying_len_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_read_volatile_running, all_pop_varying_offset_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_read_volatile_running, all_pop_varying_xy_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_read_volatile_running, all_pop_z_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_read_volatile_running,
-			 all_pop_volatile_readable_flags_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_write_running, all_pop_varying_len_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_write_running, all_pop_varying_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_write_running, all_pop_varying_xy_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_write_running, all_pop_z_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_write_running, all_pop_varying_alg_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_write_running, all_pop_writeable_flags_gen_params),
+
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_read_volatile_running, all_pop_varying_len_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_read_volatile_running,
+				all_pop_varying_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_read_volatile_running, all_pop_varying_xy_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_read_volatile_running, all_pop_z_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_read_volatile_running,
+				all_pop_volatile_readable_flags_gen_params),
 
 	KUNIT_CASE_PARAM(cs_dsp_ctl_read_volatile_not_started,
 			 all_pop_volatile_readable_flags_gen_params),
@@ -2559,17 +2560,18 @@ static struct kunit_case cs_dsp_ctl_rw_test_cases_adsp[] = {
 };
 
 static struct kunit_case cs_dsp_ctl_rw_test_cases_halo[] = {
-	KUNIT_CASE_PARAM(cs_dsp_ctl_write_running, all_pop_varying_len_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_write_running, all_pop_varying_offset_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_write_running, all_pop_varying_xy_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_write_running, all_pop_varying_alg_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_write_running, all_pop_writeable_flags_gen_params),
-
-	KUNIT_CASE_PARAM(cs_dsp_ctl_read_volatile_running, all_pop_varying_len_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_read_volatile_running, all_pop_varying_offset_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_read_volatile_running, all_pop_varying_xy_gen_params),
-	KUNIT_CASE_PARAM(cs_dsp_ctl_read_volatile_running,
-			 all_pop_volatile_readable_flags_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_write_running, all_pop_varying_len_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_write_running, all_pop_varying_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_write_running, all_pop_varying_xy_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_write_running, all_pop_varying_alg_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_write_running, all_pop_writeable_flags_gen_params),
+
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_read_volatile_running, all_pop_varying_len_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_read_volatile_running,
+				all_pop_varying_offset_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_read_volatile_running, all_pop_varying_xy_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs_dsp_ctl_read_volatile_running,
+				all_pop_volatile_readable_flags_gen_params),
 
 	KUNIT_CASE_PARAM(cs_dsp_ctl_read_volatile_not_started,
 			 all_pop_volatile_readable_flags_gen_params),

-- 
2.47.3

