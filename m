Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894562;
	b=aHt3/C6X+V7runF5iWa8oxJ6jCbCAZo/qZkLRWJJgnK12cukufN1c6E9CxtC+fiQRiFU
	 BEGOqZB07VR5QvHzKsvmdQjjREvqdSVLnPFmqhZGbmw1HS83ZzHufAAIDohPOtV9CpkCH
	 vzlH+aOFs4wgClVLrZ5qUbdfxkKlhOVRKGWrIvZxXPaPXmFL+rHV0CKTczTE9dKc+MBk+
	 L2TbsIDx2320gNg5K84U2QowlgDpcVbLFty8HjOUOe3q/VEbQgwYHzfaq9cjPBaoePI9b
	 wrh0NRQmKwqiASI6wRAAT47AMjag1Tl5MAx/ATGGvIt5pEh3wtuVPicLct9QCPuJNeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894562;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=8McZG53fBcXV4teIFZd2EGhPvVQUYCcatV8Mq/vETdw=;
	b=xmRbogp2/P66ZwCVBlfjbUBfu4Lq+v0tXBVl1GBpYzzYOIGhWkqLhpqRBM5xSVJqZR0Z
	 LF5L1fAgdIL8puv6GayZ6u7CkWufD5YJVYd2mDpsJSJnpb26DR+ANH5CLQWc3HEPqU3tr
	 ANkqt0x6iupiGmCJ1rBJjjUKy+HM41DMMn938z/mi2khjeJEoSHTkWKwzd0LMKPGnNaRC
	 5Lv92wyLNhem9Ek+QI0QbAoyfAtNG839qsgrP4icxDxEBEmWwBA+b5GVpPpLdA4b0vshp
	 GyTRabKBtWMZh7ZYu0uThperQtne5kFjd1T/Vl28IuQIstueif6jLKpxSX+suaSiLFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X63+5jyR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A3760707B5;
	Thu,  5 Nov 2026 16:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X63+5jyR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79051F0093A;
	Thu,  5 Nov 2026 16:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894561;
	bh=8McZG53fBcXV4teIFZd2EGhPvVQUYCcatV8Mq/vETdw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=X63+5jyRGQ50JFwEm4cXlywyif5nS1uoR2B9TuBo71uFu50EFQFpM65gJ5cHmLl9Y
	 8DOOUqPyyIbR/nbCT51zCV97i7HSlNSMZU19a8Dp2+swnrLxWx5X5I8Ee3kcxTYN+f
	 5gf3j85DpGVH915jaURtVblqeQI4ppL7d8OxRmnLyL9jS9CmbRCgMdQ4sidAM0cdeu
	 rdGsOXYdPUwzz67o/2FuPnmcFVEtO5OkOpSvRmuXjoqRWVVNg04OHiYdFYU//+cifS
	 mKkn1SJxnZbdeyexR7MYrTpoTTlI2nys1lYDjesSurdIUai7aazJLza4N6eQ4z3ta6
	 dh16aR3ttJBUw==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 05 Nov 2026 16:00:36 +0000
Subject: [PATCH v2 9/9] ASoC: wm_adsp: Give the firmware search order KUnit
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
Message-Id: <20261105-kunit-param-names-v2-9-765b3d5275d2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2541; i=broonie@kernel.org;
 h=from:subject:message-id; bh=DtzMeLR01OBhOU9ryO1Ct2VWOckyOBJFtfrKliPQ+gk=;
 b=owGbwMvMwCWm/754w+YLFp2Mp9WSGLLerEgNEtrzd7b5VLPTrtEq01e7rpuheJVnU9H9TsGKN
 2++7pi2raOUhUGMi0FWTJElLov7ZX3J6zV8Bxe2wcxhZQIZwsDFKQATucDMyPDlgdJZy4YrU7P/
 LJ6w25pjdY6rq5rKnfnc0ho8n9sbsxsZGX5PPXc3oX3H3g3tvxzSZzbozwzkLT93JPTn/6h7aqe
 7e/gA
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

The wm-adsp-fw-find suite runs wm_adsp_fw_find_test_search_order()
against six different sets of parameters by listing it six times with
KUNIT_CASE_PARAM(), which names each case after the function. All six
cases are therefore called wm_adsp_fw_find_test_search_order, which
makes the results ambiguous.

Use KUNIT_CASE_PARAM_UNIQUE() for these entries so that each case is
also named for the parameter generator it is run with, for example
wm_adsp_fw_find_test_search_order-wm_adsp_fw_find_full_search_gen_params.

Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 sound/soc/codecs/wm_adsp_fw_find_test.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/sound/soc/codecs/wm_adsp_fw_find_test.c b/sound/soc/codecs/wm_adsp_fw_find_test.c
index ae686dc4fa94..0b2b7db3f9f9 100644
--- a/sound/soc/codecs/wm_adsp_fw_find_test.c
+++ b/sound/soc/codecs/wm_adsp_fw_find_test.c
@@ -1219,23 +1219,23 @@ KUNIT_ARRAY_PARAM(wm_adsp_fw_find_pick,
 		  wm_adsp_fw_find_test_param_desc);
 
 static struct kunit_case wm_adsp_fw_find_test_cases[] = {
-	KUNIT_CASE_PARAM(wm_adsp_fw_find_test_search_order,
-			 wm_adsp_fw_find_full_search_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wm_adsp_fw_find_test_search_order,
+				wm_adsp_fw_find_full_search_gen_params),
 
-	KUNIT_CASE_PARAM(wm_adsp_fw_find_test_search_order,
-			 wm_adsp_fw_find_system_alsaname_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wm_adsp_fw_find_test_search_order,
+				wm_adsp_fw_find_system_alsaname_gen_params),
 
-	KUNIT_CASE_PARAM(wm_adsp_fw_find_test_search_order,
-			 wm_adsp_fw_find_system_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wm_adsp_fw_find_test_search_order,
+				wm_adsp_fw_find_system_gen_params),
 
-	KUNIT_CASE_PARAM(wm_adsp_fw_find_test_search_order,
-			 wm_adsp_fw_find_alsaname_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wm_adsp_fw_find_test_search_order,
+				wm_adsp_fw_find_alsaname_gen_params),
 
-	KUNIT_CASE_PARAM(wm_adsp_fw_find_test_search_order,
-			 wm_adsp_fw_find_noqual_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wm_adsp_fw_find_test_search_order,
+				wm_adsp_fw_find_noqual_gen_params),
 
-	KUNIT_CASE_PARAM(wm_adsp_fw_find_test_search_order,
-			 wm_adsp_fw_find_normalization_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(wm_adsp_fw_find_test_search_order,
+				wm_adsp_fw_find_normalization_gen_params),
 
 	KUNIT_CASE_PARAM(wm_adsp_fw_find_test_pick_file,
 			 wm_adsp_fw_find_pick_gen_params),

-- 
2.47.3

