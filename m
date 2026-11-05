Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894535;
	b=C+iForxTkEOIPp7kN1gobOCo0gBcGCzl4khUagrC/PkGkd19ra1L957FNoQkk8ap8BMu
	 yB3PN48zuE1FZ4OyK+rdjqFEpRMeG7CdUHopJk33pge/R2WpXdNYfL1icqB/lIxcmO4uP
	 9Xqp+Qzflgc1RvkVxQUqfYhdaNLhRXl5wI+GRJOjl7eRP4iz/W4L28/8m1yxvFMW4GPdz
	 EUo/RfIMIsPWIgXB7qpEeBSK5T41nlDUN+TSI2KCYRW4isILSLiur0J/p8GP5Pn2WLZvf
	 uqRE/rOdl3Y+gwMizrJ7yBu9Pl6q2dc9XjmnqQ3EgeU6oCh6mGAtqu0G2K4IPPvS1Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894535;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=ArMtkVmSk4mC/embS5DFwPfMiPXAH0deYij5/ijmTw4=;
	b=IrZdqyMcJ4BOaNOeCwwCjtOeUbSL+hPtJATdj4a/jwyzFrR1LcmAxje/8MWJrzR45BOU
	 JGBeHoxQLIGWMm0d7sbWIw56ROEho3XXon2MWvIVxFzf0mJuMyn4HrkcztlNHnVZ1rnBm
	 tZ5cm6YY6ZD4jM5OsRIOtWcmiweTy/SjYCC0Lz10HbKpM86X+/2oUkk4u79LDxxBIGohM
	 cWMuLM4FCWV9aZIv2mq8MXeeLevy4SDSZfnG+hWd6xshOvfhMYV7h9WE0W6xCA1Uiulf3
	 0iVo/V/s7zDE+De6jEHalzjt3BiCFkcgbjRi+2ZMc0vXLgWcyIeMnqfjxXxovOyelmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jrGiqL3o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DA6606EEAC;
	Thu,  5 Nov 2026 16:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jrGiqL3o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C181F00919;
	Thu,  5 Nov 2026 16:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894534;
	bh=ArMtkVmSk4mC/embS5DFwPfMiPXAH0deYij5/ijmTw4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jrGiqL3o+evVEIt0Z+4Sv6tKQ79YqhwJKZK/XGQC1jo3d4JKnoduHLcJEcypkS+nI
	 U4jFyLLwcXlC5tt3QZmexs+Az47OVUF0sku0NR3PTekR6k683NBNK3VG0X1eQLIn7G
	 17wz6ybQ74wlAI6p/3yMW40bOPG+F8hw7N/Y9+1aiaVDjMwdLQUH/Ikt9S7k+XRpFw
	 FSg+3R11EjsjoS3BrrSuRpFXeCYt3JpHBMOQiysuSscnbsjmlN43iOKpI5962vw/qR
	 wcv649XCa9Ue5OvrVvAxAUdWzb2y6f50Q6EynwJ84fiZoBwsQkGBh7siTM3Ml950kI
	 GmNqHY8rXPpqQ==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 05 Nov 2026 16:00:31 +0000
Subject: [PATCH v2 4/9] firmware: cs_dsp: Give the control read/write KUnit
 cases distinct names
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
Message-Id: <20261105-kunit-param-names-v2-4-765b3d5275d2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5163; i=broonie@kernel.org;
 h=from:subject:message-id; bh=3FdMiRqeGL3u3D5GJK5SJFAO1j8EsUqY840M964fbe0=;
 b=owGbwMvMwCWm/754w+YLFp2Mp9WSGLLerEj1evI5u71gNbv5gSssvmL7HLychf3fiJpa5Ns4O
 Ucxq8R1lLIwiHExyIopssRlcb+sL3m9hu/gwjaYOaxMIEMYuDgFYCJ66Qx/OBsFVjkVi0lbNp60
 mbk/xPnjzSwPDf+XKzgbPGJvLyq2Y/jvv3Z70y8WlYVHQ/Z4+bAb823lPxFzZvOh15+itiTZJhz
 nAgA=
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

Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
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

