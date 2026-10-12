Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D753A4F50;
	Mon, 12 Oct 2026 23:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791846728; cv=none; b=LelyAq+b78OYxAjKjqwnV9PMu6O6dGXfaCtmnNJUWB3tfdCWwM/yBt417S3Wnpa+1I4ns4iE5S2g4zbpF7uGxFEASL+JrS2YDmNU+TnB/AEzhzbZxU+KHvQpH0qHDMwO1B0DUUKafYnzorfO2gZLapw9KZ0/xXzNMiLEMaVIsqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791846728; c=relaxed/simple;
	bh=93CgcEuzyQ6Ai/8akTBe6/1yGYR33rXNQbNRSyzAZPc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Lo3VehAX14fanqqj2/hx2Id+FkPr7hupXhlJr9QUDuqpOJZr1h0AjCaGYplnr/resobafhkB3T6qdltiyW5psudxHf4sV7odzH0RUyG4wnsTX/NhOuRO2VcIR1Fwsb5YVThHRe5ION+7sGvlJtQdfLEioULpz3Nm3LVD5a+aioM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WvQzkUoH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WvQzkUoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03E81F008A2;
	Mon, 12 Oct 2026 23:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791846727;
	bh=a2bb0eoGuGyhcfyI3fwC72JX7HBf84eKj7ndJ4mNd0E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WvQzkUoH7qxJOymEMT9jJoRIdmxRl21am4AVcpDWw00bbXvAMmSoTChASoJ93mcIv
	 pk/AFzi/pcLSn35OuQbUlI/knxek2cKTbcSd10+6TwmVc8h0KnZ/eeA4B5qEtYMjrc
	 ZoFCXL8QCDFD5UQwmbqE7IV/gBrTNYv5uSlYccW25fSJFKJ4MJImUtRpPnqvvr3iz6
	 JdnEDmtAo5Cp3EqAgqXDf3G1NRlSA3LugFfv2mk3G2DrxET8A+weYCP6r/nUC+qTCb
	 /0qXYB/GVQLWMorVErq6AgrAJ5A5fnacFS85ycdmttOwFwSLI5uOPGtYosdBPvIPFw
	 3J2qXXXMM3Tww==
From: Mark <broonie@kernel.org>
Date: Tue, 13 Oct 2026 00:10:11 +0100
Subject: [PATCH 1/9] firmware: cs_dsp: Run the wmfw payload error tests
 with invalid block types
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-kunit-param-names-v1-1-4b22ec5b85b9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4843; i=broonie@kernel.org;
 h=from:subject:message-id; bh=93CgcEuzyQ6Ai/8akTBe6/1yGYR33rXNQbNRSyzAZPc=;
 b=owGbwMvMwCWm/754w+YLFp2Mp9WSGLLOZlonWi9lNVSsEVWL5+u0+MMbHNFaf79VuXaF1sUPS
 YsEv+7uKGVhEONikBVTZInL4n5ZX/J6Dd/BhW0wc1iZQIYwcHEKwEQ+1TH8D735w1jtKpvm7M2p
 09pWn10wedpUi421YZvFV/GffiK+cDXD/9R1ol+YNet+TZ6lup7n37eWxWkeii2rXkcXiLXMNZr
 XwAMA
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Each of the wmfw error suites lists the truncated block header, truncated
block payload and garbage payload length tests twice, once with valid
block types and once with invalid block types. For the payload and
garbage length tests the second entry names wmfw_too_short_for_block_header
rather than the test on the preceding line, so the block header test is
run four times with invalid block types while the other two are only ever
run with valid ones.

Point the second entries at the intended tests so that
wmfw_too_short_for_block_payload() and wmfw_block_payload_len_garbage()
are also run with invalid block types, as the header test already is.

Fixes: feb5fb0615f3 ("firmware: cs_dsp: Add KUnit testing of wmfw error cases")
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/firmware/cirrus/test/cs_dsp_test_wmfw_error.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/firmware/cirrus/test/cs_dsp_test_wmfw_error.c b/drivers/firmware/cirrus/test/cs_dsp_test_wmfw_error.c
index e7bf5dc474f5..b07978d90fa9 100644
--- a/drivers/firmware/cirrus/test/cs_dsp_test_wmfw_error.c
+++ b/drivers/firmware/cirrus/test/cs_dsp_test_wmfw_error.c
@@ -1222,9 +1222,9 @@ static struct kunit_case cs_dsp_wmfw_err_test_cases_v0[] = {
 	KUNIT_CASE_PARAM(wmfw_too_short_for_block_header, wmfw_valid_block_types_adsp2_gen_params),
 	KUNIT_CASE_PARAM(wmfw_too_short_for_block_header, wmfw_invalid_block_types_gen_params),
 	KUNIT_CASE_PARAM(wmfw_too_short_for_block_payload, wmfw_valid_block_types_adsp2_gen_params),
-	KUNIT_CASE_PARAM(wmfw_too_short_for_block_header, wmfw_invalid_block_types_gen_params),
+	KUNIT_CASE_PARAM(wmfw_too_short_for_block_payload, wmfw_invalid_block_types_gen_params),
 	KUNIT_CASE_PARAM(wmfw_block_payload_len_garbage, wmfw_valid_block_types_adsp2_gen_params),
-	KUNIT_CASE_PARAM(wmfw_too_short_for_block_header, wmfw_invalid_block_types_gen_params),
+	KUNIT_CASE_PARAM(wmfw_block_payload_len_garbage, wmfw_invalid_block_types_gen_params),
 
 	{ } /* terminator */
 };
@@ -1239,9 +1239,9 @@ static struct kunit_case cs_dsp_wmfw_err_test_cases_v1[] = {
 	KUNIT_CASE_PARAM(wmfw_too_short_for_block_header, wmfw_valid_block_types_adsp2_gen_params),
 	KUNIT_CASE_PARAM(wmfw_too_short_for_block_header, wmfw_invalid_block_types_gen_params),
 	KUNIT_CASE_PARAM(wmfw_too_short_for_block_payload, wmfw_valid_block_types_adsp2_gen_params),
-	KUNIT_CASE_PARAM(wmfw_too_short_for_block_header, wmfw_invalid_block_types_gen_params),
+	KUNIT_CASE_PARAM(wmfw_too_short_for_block_payload, wmfw_invalid_block_types_gen_params),
 	KUNIT_CASE_PARAM(wmfw_block_payload_len_garbage, wmfw_valid_block_types_adsp2_gen_params),
-	KUNIT_CASE_PARAM(wmfw_too_short_for_block_header, wmfw_invalid_block_types_gen_params),
+	KUNIT_CASE_PARAM(wmfw_block_payload_len_garbage, wmfw_invalid_block_types_gen_params),
 
 	KUNIT_CASE(wmfw_too_short_for_alg_header),
 	KUNIT_CASE(wmfw_v1_alg_name_unterminated),
@@ -1261,9 +1261,9 @@ static struct kunit_case cs_dsp_wmfw_err_test_cases_v2[] = {
 	KUNIT_CASE_PARAM(wmfw_too_short_for_block_header, wmfw_valid_block_types_adsp2_gen_params),
 	KUNIT_CASE_PARAM(wmfw_too_short_for_block_header, wmfw_invalid_block_types_gen_params),
 	KUNIT_CASE_PARAM(wmfw_too_short_for_block_payload, wmfw_valid_block_types_adsp2_gen_params),
-	KUNIT_CASE_PARAM(wmfw_too_short_for_block_header, wmfw_invalid_block_types_gen_params),
+	KUNIT_CASE_PARAM(wmfw_too_short_for_block_payload, wmfw_invalid_block_types_gen_params),
 	KUNIT_CASE_PARAM(wmfw_block_payload_len_garbage, wmfw_valid_block_types_adsp2_gen_params),
-	KUNIT_CASE_PARAM(wmfw_too_short_for_block_header, wmfw_invalid_block_types_gen_params),
+	KUNIT_CASE_PARAM(wmfw_block_payload_len_garbage, wmfw_invalid_block_types_gen_params),
 
 	KUNIT_CASE(wmfw_too_short_for_alg_header),
 	KUNIT_CASE(wmfw_v2_alg_name_exceeds_block),
@@ -1287,9 +1287,9 @@ static struct kunit_case cs_dsp_wmfw_err_test_cases_v3[] = {
 	KUNIT_CASE_PARAM(wmfw_too_short_for_block_header, wmfw_valid_block_types_halo_gen_params),
 	KUNIT_CASE_PARAM(wmfw_too_short_for_block_header, wmfw_invalid_block_types_gen_params),
 	KUNIT_CASE_PARAM(wmfw_too_short_for_block_payload, wmfw_valid_block_types_halo_gen_params),
-	KUNIT_CASE_PARAM(wmfw_too_short_for_block_header, wmfw_invalid_block_types_gen_params),
+	KUNIT_CASE_PARAM(wmfw_too_short_for_block_payload, wmfw_invalid_block_types_gen_params),
 	KUNIT_CASE_PARAM(wmfw_block_payload_len_garbage, wmfw_valid_block_types_halo_gen_params),
-	KUNIT_CASE_PARAM(wmfw_too_short_for_block_header, wmfw_invalid_block_types_gen_params),
+	KUNIT_CASE_PARAM(wmfw_block_payload_len_garbage, wmfw_invalid_block_types_gen_params),
 
 	KUNIT_CASE(wmfw_too_short_for_alg_header),
 	KUNIT_CASE(wmfw_v2_alg_name_exceeds_block),

-- 
2.47.3

