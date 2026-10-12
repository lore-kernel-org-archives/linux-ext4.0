Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C788B3DAAC8;
	Mon, 12 Oct 2026 23:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791846767; cv=none; b=YYjmxnWO7ShMRC7ZuewSVZn9ftqbRS83Ln5i5ng5sIO8Om9ZntZGZITk/LhANX9lWy6AJPrEg88yMG6pO/VotJ3XX9+2WT93X9Ot75zGeT7WLuH+68yVUZBjowRoLbJPqaqPa++bF0oVFeDNNv8KvmMZ4KNoFpaHnsc60jZdIkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791846767; c=relaxed/simple;
	bh=MEiGMuIMeKi9yCXG6aTCD6OFCqWg0MeVSSSRTs9G8ec=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Z80nKxMXnPdMY6+wi27GNFcM8eDX5V8Y/AR3cymm1fxGXPNO1gKeP96EWq/gTeCHbwQlvyLjM5dcqTXI+TBoLMk+lIjKokPH8IqXiVvRaxbBezUm6P0cg1na/MUNdWXbBW+jIsh3Q3EVG2ULppYOjHYTFhp7nd+0Ha0Uf7+S2mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=coMGTIfP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="coMGTIfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9C81F008A1;
	Mon, 12 Oct 2026 23:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791846765;
	bh=Rgj6FPJ8PZ51oyocHcD7YfkOLJMRw+u1Cm8J8vmBa14=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=coMGTIfPpFTYuK8P0gljisUAmx2uxPCpKkQiIm0FzkrfbXfKTqzaRr7VlSfq+4Wtp
	 ecWLBagsiRcaJOPIUzE4N3WEObow+XdLu+Z9BRGe71+TxAftbjHGrXRG5vXId107hN
	 7FEAYQziOtUIiOC3xi5lLAr4prTywoHm4xBzPSARI+9wkmOZUGjfG0BnOXR/UZCHSI
	 seJZ/vxC8XblEgOu4GEi48yu1XiNfh19SZD0U83ebnDjokazWKhpr6CzVekVTg+BWW
	 1YRrZ1fMACtQT9R2ziDXHdETjC4qd4QEGqgRuxZIE6FafBMBpuoBCy9JXdkASMPaSY
	 FF/f+zNJ6Jqng==
From: Mark <broonie@kernel.org>
Date: Tue, 13 Oct 2026 00:10:16 +0100
Subject: [PATCH 6/9] firmware: cs_dsp: Give the wmfw block error KUnit
 cases distinct names
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-kunit-param-names-v1-6-4b22ec5b85b9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6838; i=broonie@kernel.org;
 h=from:subject:message-id; bh=MEiGMuIMeKi9yCXG6aTCD6OFCqWg0MeVSSSRTs9G8ec=;
 b=owGbwMvMwCWm/754w+YLFp2Mp9WSGLLOZloHb7hcfr/D8V4Ii/L0c1+PzUlL3rnDd4FyvejTX
 PY/9s5nO0pZGMS4GGTFFFnisrhf1pe8XsN3cGEbzBxWJpAhDFycAjARk05GhvMvZ++tllwUtWFd
 z/opIW9n/I+a7vzbfgdzlJKKd8HR7C6G/8kZp6td589ZfG3pRz/t7TwaAUL3FFam7PsaaZDyM/U
 bEysA
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

