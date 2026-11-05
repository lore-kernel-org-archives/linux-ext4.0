Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894551;
	b=SFrSh7cpj9398xEUsfAmza9EKKzZPmQW70bcEaVeynjG0ziBdCaE+XiaM05B+z1LosF5
	 m/C/wZsPJQQu27U1vaPlj1QM/q0vGsdBLCqzxs5jXLP4GLIJ5M4trRumeYVt07NNdWr3W
	 9lZMXc8aIn9Mc5l/GQ0lmOePH/gqKq/wZp4OJW2FPHdHa8s/J8virmDCPunQttp4qj2zQ
	 UNAOHC+149+K87WvBj6FQUPx3HHETOg7AlJ1lDD2COFRaGM7WCWAzXVfIYCkkScYm5c0S
	 EwFv+kkCUq/TaBO5ji5OKuOIxVcnu8EknmP8XeMIY5e7/ULPrKt45haf40O4O+FoXsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894551;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=7/OnOztjg2EK84QqsXYZGwDX4EmI9eyFIKPp0TKp/c4=;
	b=YtHUw/Ira2mOxOQd4ycO0I06uudaXSaEjgrAbnoaTK08pDmrtbbpdnTmYuwwQ/ADtasc
	 yI+VHUkvNGb3iGivwnFE69QkYpfx4v9NB4eSaGjpRHhWDDBqlW84kYZCQfJLhOiwjcFsE
	 GNWqrMglQ1hMm0IRYg+5J8RvA0vqgkPuGzwQki0NzZun5AWv3ELOswpCxvcS+MFlgu1m4
	 5Z9O152q0ep7e4dKT0Rb92yU6CR2j3u5rGPT/pWM3WUJ6RpMYwnH9JxFqBOrpmb0SSYg/
	 vKgLPoaflDELN5DPnHE3I2preL2cjUgbzRfI5433X2G+ipQi9nANE9RMUEkbzdZ8v4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fr3kO8ax;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E407606D806;
	Thu,  5 Nov 2026 16:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fr3kO8ax
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9DE1F000C1;
	Thu,  5 Nov 2026 16:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894551;
	bh=7/OnOztjg2EK84QqsXYZGwDX4EmI9eyFIKPp0TKp/c4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Fr3kO8axdVRIkzUl6k4tjw0CcwsZJMd52xYZ9JfJlHjkA6aRZn6unefqfkzHdpzXE
	 R2BarzQtP5YQvdzDnxAk3nJ6lpmNYRFZQiUn+IST/kFVXKqmA/pqJLdhAlDE1T2IPn
	 cOEjqUWdDN5EtTskrX/sY5jkzLPjPiVJyQTVnx5RI8aeyMrHSUGjuV7bpuKBAbT8XR
	 4io2574m7KIsUKQIte2DFSbl24svNjjLc9zWKbaQR3Bh4SPQr8HzQWJOlaUETWJRsn
	 RctXWNVTqSrYSFdrruQoZtnASldpr51h5ehZM+opnw7dAvXpiV9hN1BjpyY2EOdXtv
	 hB4m/mWDIIdaw==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 05 Nov 2026 16:00:34 +0000
Subject: [PATCH v2 7/9] firmware: cs_dsp: Give the bin file KUnit cases
 distinct names
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
Message-Id: <20261105-kunit-param-names-v2-7-765b3d5275d2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=16931; i=broonie@kernel.org;
 h=from:subject:message-id; bh=t8fkopsOg3sufbABwCPfiVkWdlwK5/RfwsIRwnV4EIM=;
 b=owGbwMvMwCWm/754w+YLFp2Mp9WSGLLerEi9IcGnPn+zq6lsX0uG5vpFeXPf2nOkbQ+enKP5S
 /z7j3yFjlIWBjEuBlkxRZa4LO6X9SWv1/AdXNgGM4eVCWQIAxenAEzEJ5fhn9KK9+qP4uqkviQU
 PH9SEPLgb3xeDtfmgrnzj8pkvopNsWf4n8j1v41lFmfdw8Wm0rNzamdPmnltsuzDupeq9s+MRFZ
 ZcwMA
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

Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
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

