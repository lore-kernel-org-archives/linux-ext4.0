Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894557;
	b=JCXipxoqOJAHinlUnOsVaE3ETe2IMHGhbvcHZ45ABb+GChRqzvHsJtFh36l+pzsMDTZk
	 jyJnzE6on4eZN9viink4hWY/nuI3tJ42jWdnSqRBwRqoJtixNFrq/nxV2ZL6+Hth4gcln
	 KY+ily8TcXYoA2nvgukeo0XOX1ep0yrmM3LzpE5tyO46aSH48qh7RzMv1yZyUXIVmKzyA
	 zF4YG9d0LZ7dL8bcEYpliOV8VXmwY5/gF42kqszAAJKt7QbT1/s1ZKqxstdgZQS1Z9NBP
	 /cl50q59kQ7lM++lUiHdeCFTvrYFOLrpsz8ArFwzg5EmO+zTs9YqZXxBFKyh03sn+7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894557;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=w1YzNFUQU7EDlyH6y9uKB5yEntROt8vJqzEMZbQhPR0=;
	b=oWcwOUArR4h3A/j9Ix+Jggzcf5+gd90yte3qwfZPODmfWD0V/HYJrYWeQBCpw6Jg7UwU
	 S1NNVXYAtSYYKUVA/3fcixf19P8dhYqFxkKj0pQRGj54CEuw1XiCIq1nL01f0IHpsMo13
	 NOehl273LT+S9tfvQnYQPR/41SoFuSCv7QEFchRuaUcDhxvxWonXawms9o7tPsHfF8znP
	 pjDk8rUP9Mowt7Ih6HZBwIROAyas4ZUIP/78QrWXjhU8A/JlkyURWl1S5g1cc/cXoq4Lp
	 ZSlwxv2xPq0d5TINHQnIsm26Q0FCZshv+4EWkAe+1o5NgeO/dxcMmjXnkFCUBc2N2hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gFeMUvv7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DFD6075F71;
	Thu,  5 Nov 2026 16:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gFeMUvv7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743B91F00919;
	Thu,  5 Nov 2026 16:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894556;
	bh=w1YzNFUQU7EDlyH6y9uKB5yEntROt8vJqzEMZbQhPR0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gFeMUvv7Res5ML5T1SmFuVgB+osG99e8PTH0ZnhMt5SjJ1yvkLz/3Gskp3A2f/MEK
	 5J08JcCUBvAyrmLDziPHTvBVzwudJABl5J5Kz5pyEIg4vDLzKJJ9o66X3xL1rKC2Hp
	 +EJ7oE3F5lc9EMhGDIjKC0hirB/W6y0iCHqSg5XC7wNSs2esbqY71zGmTet/c/hwyq
	 ro/zAJnvm0eSEoa6RUPzMfrbzsMcHSwAoSs/9NGkvAnq9oBeIQHSN3ixxEg+UrjW+5
	 +K4QbbHpCX9CUvfpWCl4w6AJS56Iee+XzKBp84uNOgBKunyaPEh0S6I9gwPBlcHiXh
	 Dn2WQhh46NrPQ==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 05 Nov 2026 16:00:35 +0000
Subject: [PATCH v2 8/9] ASoC: cs35l56: Give the speaker ID pad config KUnit
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
Message-Id: <20261105-kunit-param-names-v2-8-765b3d5275d2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2064; i=broonie@kernel.org;
 h=from:subject:message-id; bh=lNfXF3VJrZV9zM9UGOFM9E9hcm/rozD2WmNnenLxFrQ=;
 b=owGbwMvMwCWm/754w+YLFp2Mp9WSGLLerEjt89LYMYG5VOvRAsErLHtO+tQ6RXr/ljrAKDhft
 tlrq7BQRykLgxgXg6yYIktcFvfL+pLXa/gOLmyDmcPKBDKEgYtTACby0YThn+GdlmU+61bOWu26
 N/Xeu4fJMp1PDjr9P9X6X3x95ZKmc2IM//0P7Tt8Y9IU4/+qdVYbG889tdjGafXk33le3yuPVYq
 VTHgA
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

Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 sound/soc/codecs/cs35l56-shared-test.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/cs35l56-shared-test.c b/sound/soc/codecs/cs35l56-shared-test.c
index 34bb3d44b51f..ccf5adb7cf2a 100644
--- a/sound/soc/codecs/cs35l56-shared-test.c
+++ b/sound/soc/codecs/cs35l56-shared-test.c
@@ -899,10 +899,10 @@ static struct kunit_case cs35l56_shared_test_cases[] = {
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

