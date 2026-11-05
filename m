Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894540;
	b=yXUSYmPOCb1zSrDSPQctTB5/9jo3RTG+dZ/WvTy0vOSnrMszye/w7aSNqtNJ2iiC33eB
	 NkP/7ke827ssKRUvyU6I15cEeIzNozNvH4Yn8acp9h/aEyxgWqA6J0sdDjxaC9pFxFJQa
	 X59Ipigc8DALMvFjfMAxxTeaRtYdmqr/dKDe6RH9JUGu5hOnvH6BmQ8npwdRVFaBj161i
	 yCcySH0DqaB+JfsX4ZJQ5BITWkz/5Va6uLQNN5j0qNHC+gjIFrHecqROwjof1ChetfaaK
	 vtr7MgUhD093x3VrjRDinUCrmvi16G2QHlbxjab1Z6mZPyw2YCWO431exx5hV9dScOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894540;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=rAfjjAdZhlk/UOEZOV+gThG9bjemn9ArP1oc727YZec=;
	b=ikVSHM6gK1uzNbXSzj5r0kwn5bSHBchafrmCiF19Iue+FTMMVk4LwU5omQZx3iGPesU1
	 gQyMiDGLSs83IuSgDN/yZtod8xiGwRVoIbvFq1Mxlb1FW/RxqzB7RfFKE9XRO7BNvYBRQ
	 e10YdExCks51cTGKVfZy0n52VNEY2tfqxZ8fRu6o3tNc9Spt2lVzSqSDzap3QaHQ06PjV
	 L1cnqzNGQ8azEMSk9sUuToptp9Nsi323AXHuiwPAosaOHLsP61PFK7R+dHcgDkSN6ohx1
	 jtsBa6+h7SoSSVHGSlPDt7G6Kdasce48ZQd5/bverybnI7JI0gOxjhTqnJ5Nj6HfiPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ofzVeMYt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2C2606F95F;
	Thu,  5 Nov 2026 16:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ofzVeMYt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF461F000C1;
	Thu,  5 Nov 2026 16:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894540;
	bh=rAfjjAdZhlk/UOEZOV+gThG9bjemn9ArP1oc727YZec=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ofzVeMYtgWjC8kZsxmDi3++pCZp7GaqLknfMcb6bV8T7ZoWb0B5ydNM8bwudjaS0m
	 x31nDh9kiTBvQjaCb6CWg0oDE6XGywh/P0JomfSnwCFOisIuRc49j21d27b5tOVaYz
	 dA/g4hL48neW3s4Qkki3NrBy5fArsI2QVMyT+XiPffB61tCrpOrFw6mpBXSMmmPTSP
	 PvsuAsY3tDBdXQODnMIabDPg6xzC8PP5/ro+pe6lWJtBZjRQ7Ef1v0B2QN+EATTyAe
	 QXIbkrBC2RVdPd2wb7bAMfhZ+J56qGh11LonBeCwLp2wzWfFiNxNDm8aSWLIOwMgYB
	 fAF7cpNir0mIg==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 05 Nov 2026 16:00:32 +0000
Subject: [PATCH v2 5/9] firmware: cs_dsp: Give the control cache KUnit
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
Message-Id: <20261105-kunit-param-names-v2-5-765b3d5275d2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=12287; i=broonie@kernel.org;
 h=from:subject:message-id; bh=KB0L8KILb3TD2LIIhg4IYnlI0ANjLj2EznOjG7QhLxI=;
 b=owGbwMvMwCWm/754w+YLFp2Mp9WSGLLerEidNtnr6pVHWy/N1pV1Pz/xk1Tt4oy+22c1BYIq7
 Kq+N5hZd5SyMIhxMciKKbLEZXG/rC95vYbv4MI2mDmsTCBDGLg4BWAiGuKMDBMWm6t8+PVB2zhu
 /9ZH5u1h8QecLhbcsnqVdORO5TXWv1EM/6Oir6U0mK+4+1VRXtDJzGlC3XmTatO+Goa+K//fz1D
 kYgMA
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

Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
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

