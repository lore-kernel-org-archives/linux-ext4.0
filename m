Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B91A3DEFF3;
	Mon, 12 Oct 2026 23:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791846777; cv=none; b=Wvsjrl0+ngoAEakW598+9kqpyChY1fBke46C/I036dDLAS47sSBkiNOGomkaZWgpJj2B2/CzaFyL6R5+eYdopTNT/udZIFjX1oGxukOGARhWdyv0TYNWW/5IlfRmF6HJYzp4gp4gwDOpPtmvZ2uOXcc5MgYsPbTqw5VyIid5d90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791846777; c=relaxed/simple;
	bh=uhxhGDVMaFp6E+qPJ700IctrKcVsexPJabQ6DFHT7SU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ouHjr7ke6caPpPYt5GtNVWqsWVqwdpPxPvkmc0/GGx8u/fm6D2nBbvoWdL3Jp3EHv+sj0q8S39BlPgojRUXqgZTV+O3FskJkiNffrXDTc8UPHS9LqixOp0bGhIWfD3FCVw6sJ5+sxH+4BC6Y7E5Xh+yU/HMTseE+u+b/nUBVDvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yr7eqO+w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yr7eqO+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF221F008A1;
	Mon, 12 Oct 2026 23:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791846775;
	bh=SIV4o3JvK2vDg8XQBTg0IjA2SbVK1flBza2hrE+rpE0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Yr7eqO+wBIj58kK2snrtdteYEZJZRTxa6HvtbmYbTiO+He6FJyGEDmSgkI0vpZlMF
	 r75bYk4oOvjG3oIWTjdJVKxZkhDJ/LRGXus+vI2fCybZsZ0/y8MeZfnxXPS5Kgr1rS
	 o1LLnnHfmAsM/ReKQb0IWMFi/vTYpSVNhh5deVSymnQlE/dJ9VQvBBF0AFpD3+ru1B
	 SFzCYyz3LNew72JSeIydb6P28WAzrRdnPHlnQcbsIQcO1mKGjdGTbEoxWKmzc/7e2/
	 HPqg14O0juyFOk1MEUJc96Az62oDrH+8g6o/1n85+WmuH03WodiJJqHa1HDcp66dvo
	 MWvGGvXwWXxEw==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 13 Oct 2026 00:10:18 +0100
Subject: [PATCH 8/9] ASoC: cs35l56: Give the speaker ID pad config KUnit
 cases distinct names
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-kunit-param-names-v1-8-4b22ec5b85b9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2004; i=broonie@kernel.org;
 h=from:subject:message-id; bh=uhxhGDVMaFp6E+qPJ700IctrKcVsexPJabQ6DFHT7SU=;
 b=owGbwMvMwCWm/754w+YLFp2Mp9WSGLLOZlr7PPRTnjVZa/76dM0bLKfZO0o/73yySfPGivw9j
 5ON5I/M7yhlYRDjYpAVU2SJy+J+WV/yeg3fwYVtMHNYmUCGMHBxCsBEsqcw/NM7nf/qcGn6jKN1
 mnyh/fp3Lm+5sd/oY3jP5bCApoDyJSwM/0sSLCJrtXgc3U/d+82/un3t9516jRU7F3GEvOJljbV
 ZyggA
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

The cs35l56 shared test suites run
cs35l56_shared_test_onchip_speaker_id_pad_config() both with and
without pulls configured on the speaker ID pins by listing it twice
with KUNIT_CASE_PARAM(), which names the case after the function. Both
cases share a name, so they cannot be told apart in the results.

Use KUNIT_CASE_PARAM_UNIQUE() for these entries so that each case is
also named for the parameter generator it is run with, giving
cs35l56_shared_test_onchip_speaker_id_pad_config-cs35l56_shared_test_onchip_spkid_gen_params
and
cs35l56_shared_test_onchip_speaker_id_pad_config-cs35l56_shared_test_onchip_spkid_pull_gen_params.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 sound/soc/codecs/cs35l56-shared-test.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/cs35l56-shared-test.c b/sound/soc/codecs/cs35l56-shared-test.c
index 4f52c8a192e5..c2aa524efbf6 100644
--- a/sound/soc/codecs/cs35l56-shared-test.c
+++ b/sound/soc/codecs/cs35l56-shared-test.c
@@ -847,10 +847,10 @@ static struct kunit_case cs35l56_shared_test_cases[] = {
 			 cs35l56_shared_test_gpios_selftest_gen_params),
 	KUNIT_CASE_PARAM(cs35l56_shared_test_get_onchip_speaker_id,
 			 cs35l56_shared_test_onchip_spkid_gen_params),
-	KUNIT_CASE_PARAM(cs35l56_shared_test_onchip_speaker_id_pad_config,
-			 cs35l56_shared_test_onchip_spkid_gen_params),
-	KUNIT_CASE_PARAM(cs35l56_shared_test_onchip_speaker_id_pad_config,
-			 cs35l56_shared_test_onchip_spkid_pull_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs35l56_shared_test_onchip_speaker_id_pad_config,
+				cs35l56_shared_test_onchip_spkid_gen_params),
+	KUNIT_CASE_PARAM_UNIQUE(cs35l56_shared_test_onchip_speaker_id_pad_config,
+				cs35l56_shared_test_onchip_spkid_pull_gen_params),
 	KUNIT_CASE_PARAM(cs35l56_shared_test_stash_onchip_spkid_pins,
 			 cs35l56_shared_test_onchip_spkid_pull_gen_params),
 	KUNIT_CASE(cs35l56_shared_test_stash_onchip_spkid_pins_reject_invalid),

-- 
2.47.3

