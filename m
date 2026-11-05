Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894546;
	b=hTxBLHFX1wfTOKt2C02nVBxHI9BYLtGs9mFGwL8wNlVGP+Kul7qd96j3rQS62Lk7WGeq
	 1Ck7r62gRQEZYDEgd80mTMx8rwWvyvhyUBOllwkZTambU9j2H0sI1b7G85X3RBYRmH/XI
	 bx2AjYlZ0WxcpRweRbB25BtnT+NOn5KGCykFcgh+a350meNpKzNxcvAuFbQ1qcCoRvqxn
	 aoBBfPS9q124WlervDdtgH37RAFVaph4ynxFX499OyJ2lM626ytF7H0RHoosnnHPNr/+W
	 UFLYfgis/x6TVN3N2tUMvXtHN7Ti4wWmOY73uwltrYvobTM1xzXzPu4+B32YmDT497A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894546;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=b2Zql0BOJ6GNf1ExnXOzQ7P6x9P0MEjoge6xF3wstrA=;
	b=RDMEyxTZCIWJXere2pwN+0eVlvAiBW6UMFgh4477s8M8hq7RMO0gKOphI1a5r1+A4XHY
	 7C1jqn1kwhh3EoPQ+6M9sV0ANTfxw/LFUm+PY4QhEmc2dO+fsM2dA2v3zKTc7zBpF5wQ5
	 s7WlekAOtY8917hYhT/UCZ35R1sYcvEwunTGb3IaSv+fkMBv9jhaAzeoGSXzYJToD7TIU
	 0fkC31t4QEjLzNEEL8kU26AxYDumsiBf+qnxsr8fNyiMRocN7g4AMRCPZ8giJRYQJPugq
	 2oHGauHFvFEAAOdQT3xUOLaONnAp69EX7dL9fR4MyHi9Z+rBXdH9ftI0n3/sW656H2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="jMldzfp/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E7A6070785;
	Thu,  5 Nov 2026 16:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jMldzfp/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15011F0093A;
	Thu,  5 Nov 2026 16:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894545;
	bh=b2Zql0BOJ6GNf1ExnXOzQ7P6x9P0MEjoge6xF3wstrA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jMldzfp/VXU78etT1bunKnkj39/IRguCK/YLG2YLvs1J27INd9C9BFxsE70+e1T9z
	 3KsChF9N3k9UAPjc+bZqJkkRucSvEQnzfZa/DsxkWiJYywmheZdYs4ziCFO+xVBmXa
	 GujjzUSYIi2coW+PQh3PwRUQdMj1STQMtdxvibdL3XhvTAv1cOoPmU4ea1diEjxSr2
	 jEyvc7P43/lWzSrIe6w9siqvI/zUYSxkJPYD2232uNPRgZKhdc7oB3xHs/Cg5pXija
	 sA4ErXTqw4fgYD/A+YfZmgNDuFQSzWZL89tDsM1IGQQ4oXaO7LC/p06SvqH59VJNnJ
	 mG0lBEdCd0MOQ==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 05 Nov 2026 16:00:33 +0000
Subject: [PATCH v2 6/9] firmware: cs_dsp: Give the wmfw block error KUnit
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
Message-Id: <20261105-kunit-param-names-v2-6-765b3d5275d2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6898; i=broonie@kernel.org;
 h=from:subject:message-id; bh=98pCo3T2yVlCTpQMqxhJrOE+JeR9FAR8IosLCvLVJug=;
 b=owGbwMvMwCWm/754w+YLFp2Mp9WSGLLerEitU20t/fU9cPOqnTUbPt13LOEXftGyZXHF2SrXm
 m0Ts1TKO0pZGMS4GGTFFFnisrhf1pe8XsN3cGEbzBxWJpAhDFycAjCRjZ0M/0MXNjpOdHlZnepc
 mu4v8uGAziQjs5SpVabyou8PrHq1eQUjw6QNizo0pyV+cfPOt55fNqPY6PraF7wJrdMl90Ve18r
 iZAEA
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

The wmfw error suites run wmfw_too_short_for_block_header(),
wmfw_too_short_for_block_payload() and wmfw_block_payload_len_garbage()
both with valid and with invalid block types by listing each twice with
KUNIT_CASE_PARAM(), which names the case after the function. The two
cases for each function share a name, so they cannot be told apart in
the results.

Use KUNIT_CASE_PARAM_UNIQUE() for these entries so that each case is
also named for the parameter generator it is run with, for example
wmfw_too_short_for_block_header-wmfw_invalid_block_types_gen_params.

Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 .../firmware/cirrus/test/cs_dsp_test_wmfw_error.c  | 72 ++++++++++++++--------
 1 file changed, 48 insertions(+), 24 deletions(-)

diff --git a/drivers/firmware/cirrus/test/cs_dsp_test_wmfw_error.c b/drivers/firmware/cirrus/test/cs_dsp_test_wmfw_error.c
index b07978d90fa9..44f9c8d71326 100644
--- a/drivers/firmware/cirrus/test/cs_dsp_test_wmfw_error.c
+++ b/drivers/firmware/cirrus/test/cs_dsp_test_wmfw_error.c
@@ -1219,12 +1219,18 @@ static struct kunit_case cs_dsp_wmfw_err_test_cases_v0[] = {
 	KUNIT_CASE(wmfw_err_bad_header_length),
 	KUNIT_CASE(wmfw_err_bad_core_type),
 
-	KUNIT_CASE_PARAM(wmfw_too_short_for_block_header, wmfw_valid_block_types_adsp2_gen_params),
-	KUNIT_CASE_PARAM(wmfw_too_short_for_block_header, wmfw_invalid_block_types_gen_params),
-	KUNIT_CASE_PARAM(wmfw_too_short_for_block_payload, wmfw_valid_block_types_adsp2_gen_params),
-	KUNIT_CASE_PARAM(wmfw_too_short_for_block_payload, wmfw_invalid_block_types_gen_params),
-	KUNIT_CASE_PARAM(wmfw_block_payload_len_garbage, wmfw_valid_block_types_adsp2_gen_params),
-	KUNIT_CASE_PARAM(wmfw_block_payload_len_garbage, wmfw_invalid_block_types_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wmfw_too_short_for_block_header,
+				wmfw_valid_block_types_adsp2_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wmfw_too_short_for_block_header,
+				wmfw_invalid_block_types_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wmfw_too_short_for_block_payload,
+				wmfw_valid_block_types_adsp2_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wmfw_too_short_for_block_payload,
+				wmfw_invalid_block_types_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wmfw_block_payload_len_garbage,
+				wmfw_valid_block_types_adsp2_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wmfw_block_payload_len_garbage,
+				wmfw_invalid_block_types_gen_params),
 
 	{ } /* terminator */
 };
@@ -1236,12 +1242,18 @@ static struct kunit_case cs_dsp_wmfw_err_test_cases_v1[] = {
 	KUNIT_CASE(wmfw_err_bad_header_length),
 	KUNIT_CASE(wmfw_err_bad_core_type),
 
-	KUNIT_CASE_PARAM(wmfw_too_short_for_block_header, wmfw_valid_block_types_adsp2_gen_params),
-	KUNIT_CASE_PARAM(wmfw_too_short_for_block_header, wmfw_invalid_block_types_gen_params),
-	KUNIT_CASE_PARAM(wmfw_too_short_for_block_payload, wmfw_valid_block_types_adsp2_gen_params),
-	KUNIT_CASE_PARAM(wmfw_too_short_for_block_payload, wmfw_invalid_block_types_gen_params),
-	KUNIT_CASE_PARAM(wmfw_block_payload_len_garbage, wmfw_valid_block_types_adsp2_gen_params),
-	KUNIT_CASE_PARAM(wmfw_block_payload_len_garbage, wmfw_invalid_block_types_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wmfw_too_short_for_block_header,
+				wmfw_valid_block_types_adsp2_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wmfw_too_short_for_block_header,
+				wmfw_invalid_block_types_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wmfw_too_short_for_block_payload,
+				wmfw_valid_block_types_adsp2_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wmfw_too_short_for_block_payload,
+				wmfw_invalid_block_types_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wmfw_block_payload_len_garbage,
+				wmfw_valid_block_types_adsp2_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wmfw_block_payload_len_garbage,
+				wmfw_invalid_block_types_gen_params),
 
 	KUNIT_CASE(wmfw_too_short_for_alg_header),
 	KUNIT_CASE(wmfw_v1_alg_name_unterminated),
@@ -1258,12 +1270,18 @@ static struct kunit_case cs_dsp_wmfw_err_test_cases_v2[] = {
 	KUNIT_CASE(wmfw_err_bad_header_length),
 	KUNIT_CASE(wmfw_err_bad_core_type),
 
-	KUNIT_CASE_PARAM(wmfw_too_short_for_block_header, wmfw_valid_block_types_adsp2_gen_params),
-	KUNIT_CASE_PARAM(wmfw_too_short_for_block_header, wmfw_invalid_block_types_gen_params),
-	KUNIT_CASE_PARAM(wmfw_too_short_for_block_payload, wmfw_valid_block_types_adsp2_gen_params),
-	KUNIT_CASE_PARAM(wmfw_too_short_for_block_payload, wmfw_invalid_block_types_gen_params),
-	KUNIT_CASE_PARAM(wmfw_block_payload_len_garbage, wmfw_valid_block_types_adsp2_gen_params),
-	KUNIT_CASE_PARAM(wmfw_block_payload_len_garbage, wmfw_invalid_block_types_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wmfw_too_short_for_block_header,
+				wmfw_valid_block_types_adsp2_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wmfw_too_short_for_block_header,
+				wmfw_invalid_block_types_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wmfw_too_short_for_block_payload,
+				wmfw_valid_block_types_adsp2_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wmfw_too_short_for_block_payload,
+				wmfw_invalid_block_types_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wmfw_block_payload_len_garbage,
+				wmfw_valid_block_types_adsp2_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wmfw_block_payload_len_garbage,
+				wmfw_invalid_block_types_gen_params),
 
 	KUNIT_CASE(wmfw_too_short_for_alg_header),
 	KUNIT_CASE(wmfw_v2_alg_name_exceeds_block),
@@ -1284,12 +1302,18 @@ static struct kunit_case cs_dsp_wmfw_err_test_cases_v3[] = {
 	KUNIT_CASE(wmfw_err_bad_header_length),
 	KUNIT_CASE(wmfw_err_bad_core_type),
 
-	KUNIT_CASE_PARAM(wmfw_too_short_for_block_header, wmfw_valid_block_types_halo_gen_params),
-	KUNIT_CASE_PARAM(wmfw_too_short_for_block_header, wmfw_invalid_block_types_gen_params),
-	KUNIT_CASE_PARAM(wmfw_too_short_for_block_payload, wmfw_valid_block_types_halo_gen_params),
-	KUNIT_CASE_PARAM(wmfw_too_short_for_block_payload, wmfw_invalid_block_types_gen_params),
-	KUNIT_CASE_PARAM(wmfw_block_payload_len_garbage, wmfw_valid_block_types_halo_gen_params),
-	KUNIT_CASE_PARAM(wmfw_block_payload_len_garbage, wmfw_invalid_block_types_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wmfw_too_short_for_block_header,
+				wmfw_valid_block_types_halo_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wmfw_too_short_for_block_header,
+				wmfw_invalid_block_types_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wmfw_too_short_for_block_payload,
+				wmfw_valid_block_types_halo_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wmfw_too_short_for_block_payload,
+				wmfw_invalid_block_types_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wmfw_block_payload_len_garbage,
+				wmfw_valid_block_types_halo_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wmfw_block_payload_len_garbage,
+				wmfw_invalid_block_types_gen_params),
 
 	KUNIT_CASE(wmfw_too_short_for_alg_header),
 	KUNIT_CASE(wmfw_v2_alg_name_exceeds_block),

-- 
2.47.3

