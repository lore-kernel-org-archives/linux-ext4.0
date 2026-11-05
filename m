Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894519;
	b=R4XBkUh9FJyu9fDVBd49d5M0wAXmyPePRyCsu3xE/8bRLhyCFf0VPkfSBjXjgQJKJI9z
	 J9EZPtcb74k3cVJR2uax7tQ1lOXIi5Yo7mY0UOVPiuCoRFXFqjUye9Wab7ytB1gGl1sBP
	 7QbmLnDemHnQwN6kPFFnKolX6VdT9R0epKaKWD6Rf9KkPmbnsojCs9SIPJVcv+TuKt2K/
	 dZjaO/GpTGsG3S0gADhYiThvyH+EQ7QzNRqOczoc+y3943BRbCZEvAM8A8ARhE3mjsbJg
	 i2JVqHy3HdnwPqKzMxL8WUtWXO5k8DuxSxFDP6kHnFXZetDE/2hd1FA+dhvT79e1iiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894519;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=fjDdszMVs81WfmQnHrLL+P9wJPJjtqNw6pklNU9jV6Y=;
	b=gAaXoxH3PgnsWon1ZlB1EELVmEQdgF+Grpsd2zUBjRMKYV9B/S0zeiDEllsL4owbfBs9
	 EV4yxxN7SH3MfcYIkoTSIvZNL4SrWF5fshwbl1VumtMUVWwauEfvrA4ueNEBd3QZ6mtWU
	 kPVJww/dmvOOCPFmBAqbV6om5N6i9ZmjftJiwafQ7k+C+cAN9lM4Wjgm/cLRbIabSWToA
	 2xuB4sLJeKrjBhV20XzBYM8s9ENmAxzP/0ZAoR/SyB+mk/hu99sdUV8o39pPkFoVhJi02
	 NRrUcBEo4uIg10TBJR38daTH1QeaOCsR/t8GwphRNRrlQe0uRbQW4LQUPKHyIuHw7Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jArn30cg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCE8606CF8B;
	Thu,  5 Nov 2026 16:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jArn30cg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77191F00919;
	Thu,  5 Nov 2026 16:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894518;
	bh=fjDdszMVs81WfmQnHrLL+P9wJPJjtqNw6pklNU9jV6Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jArn30cgFbYuW1oS3XLv8iVk8SbtmYtPxCDlAk/8fnDYiIQGg1ZTMubF42rHt9UEq
	 B/a6pdIJc2ptE7OaDMb9x6CZHq7VX5ABL/0wJ0ry+wEtChmCWkkxq0LvHlRNnBuHRc
	 QVaX5t9ggNe6imVRCH09ebRjNwxj7Gg/kk6NwunJXH/J4Fpk9V7dA8ZlPMOm0f7Rxo
	 PMAvkJA6rvT0jznVDpqt91NR5NQ5DK2CdepPREYc+FZ3TM30r+OUt5iG7hje4wd4pq
	 poJrsu/d18U5C8fYs97887u6mc9tt2vi6pJJRkZrUeCE2fhAPYlOUORThUWY8eLXL5
	 J6Ypff8H6GQ/w==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 05 Nov 2026 16:00:28 +0000
Subject: [PATCH v2 1/9] firmware: cs_dsp: Run the wmfw payload error tests
 with invalid block types
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
Message-Id: <20261105-kunit-param-names-v2-1-765b3d5275d2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4903; i=broonie@kernel.org;
 h=from:subject:message-id; bh=1aFpe4ztBHh/M8Z74WkS1UJya7pbV7Rw8UKRm0TQvb8=;
 b=owGbwMvMwCWm/754w+YLFp2Mp9WSGLLerEi1m7FXdqmWr/haFW7Xb6tEzMunV2Xo2e17oiTk0
 /Ulovx2RykLgxgXg6yYIktcFvfL+pLXa/gOLmyDmcPKBDKEgYtTACbCZ8bIcLDJ2VpXnfGBOmON
 3M6f0197vs54I5iw/rS51dH1ciFL1zMy7NNy/DTHfdHnqL2fO59rdy26nGJ5gcP1xKW3d6QerNH
 oZwIA
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
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
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

