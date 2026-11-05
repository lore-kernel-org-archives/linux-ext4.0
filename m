Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894530;
	b=N7j2DUGImidB/+2ovYfd7S0ehPOQg0TChWuTleE33U1GXHXOGySFBLw0GkARwHNsy9dd
	 /yRADZaVmzTGbOw7JC6BreQsNP65jmzatgQw/p2K2pOye46ocQP/6uajiER+sfyjb+zZf
	 4zLmvQTjtYFqb0XKxYp/5nGEhxjMBiUY44ZTRsNLi5BKrV/GwGS3gUb4467QDYnyoUuAD
	 A1W1chIafkonc+SW8Pv7TzH+xtV+9zEl8/TYX735w3mKP9pPefMACQwKMDBF++MOGXKIh
	 edo/kHJRzPUPiRrCCIzi7QD15FbEzjzqYl4gX3twhZJTv4lKskUyLKza0t0nmfP9lRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894530;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=BWIabCatnm0I4ZmqOGDEzF/gdu86BjrxsEXrZ9IZU90=;
	b=FT7i3HhNtDCZaHSb9B2Qqmo7LstJycI+nv1TZGwtTiY8NxgYsGZ6wRijDJIJHIxT7GfA
	 IkfulTZk5nXhuHSVac5UrdCTBb3HE8K8V5sec/s2prD0BLtLdorLQevuN0w47zYeZy1Vg
	 yFfJ+5vD0N4hIRyZYPbzrBWtfR2Mkb74S+lF5ZuQaPoL5RvHGike4Z3wUFFfc2HJ8wgEw
	 QxsPVEk0MPgl73+uiYBUY+HG3OUAHd0DxIiNtz74/hmp5T5LU+LVpZjEMumh+md0ydBwS
	 5Y6ELzpvzzyRynQyG+uJbJ0ytPezs6krjO0/JQdw5vkV5ni3E+JzSOaqQJaDI+bLI/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qa+Xkj7n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21A6606CF8B;
	Thu,  5 Nov 2026 16:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qa+Xkj7n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7F01F000C1;
	Thu,  5 Nov 2026 16:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894529;
	bh=BWIabCatnm0I4ZmqOGDEzF/gdu86BjrxsEXrZ9IZU90=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Qa+Xkj7nov4v9n9FdMB1BZdEApYeSmIPEXynp2XdGevDEvZwecGTFb7ldclWARk5f
	 Ly6vZ+V9CSI0W3X2+ne0N+FIKoSuCQw/ENczHqlyXvrUCaF7X8I+FZHLrDA3tusjer
	 YMb1yyHYd3NcklG27ur3J+mzxhyvo0IuQwEtLGVWul/Im2xA1bI5ZQU973zcez9WCV
	 FO29ABj6NmCmg95A0Vtsc1GOMk+tfLjcLnKcnMx7g9mdJpIuYXdnU7EKes2fCSQBoZ
	 QNYIcawCCTHtPvRfeAnqRygzqjDTd6OeI5QXavTXg0gpq81nDSJw8VBTa7fNlN8/D1
	 yMehxEre/UxHg==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 05 Nov 2026 16:00:30 +0000
Subject: [PATCH v2 3/9] ext4: Give the extents KUnit cases distinct names
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
Message-Id: <20261105-kunit-param-names-v2-3-765b3d5275d2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1883; i=broonie@kernel.org;
 h=from:subject:message-id; bh=k3UM1wQrhw9YL8SQ1FJnX9EABkWgqGMKgGOXA8o6i88=;
 b=owGbwMvMwCWm/754w+YLFp2Mp9WSGLLerEgtLmAoOizPWz1ZWIo5OsQu+8P8/c1pEoWBUr5r5
 39I+djbUcrCIMbFICumyBKXxf2yvuT1Gr6DC9tg5rAygQxh4OIUgIl8lGD4n+vPtf/DB1GWqxu/
 5IRq+YW4NJewOs+q/Lk2Tsvy5+ckYUaGm5c8yjvZpNmtut2jmt4pF6izfZXvrmnX684oErQPX84
 CAA==
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

The ext4_extents_test suite runs test_split_convert() against three
different parameter arrays by listing it three times with
KUNIT_CASE_PARAM_WITH_INIT(), which names each case after the function.
All three cases are therefore called test_split_convert, so they cannot
be told apart in the results.

Use KUNIT_CASE_PARAM_WITH_INIT_UNIQUE() for these entries so that each
case is also named for the param_init() function which registers its
parameter array, for example
test_split_convert-test_convert_initialized_param_init.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 fs/ext4/extents-test.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
index 2e997f228330..ebef078e292f 100644
--- a/fs/ext4/extents-test.c
+++ b/fs/ext4/extents-test.c
@@ -1045,12 +1045,12 @@ static int test_handle_unwritten_init(struct kunit *test)
  * https://lore.kernel.org/linux-kselftest/aULJpTvJDw9ctUDe@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com/
  */
 static struct kunit_case extents_test_cases[] = {
-	KUNIT_CASE_PARAM_WITH_INIT(test_split_convert, kunit_array_gen_params,
-				   test_split_convert_param_init, NULL),
-	KUNIT_CASE_PARAM_WITH_INIT(test_split_convert, kunit_array_gen_params,
-				   test_convert_initialized_param_init, NULL),
-	KUNIT_CASE_PARAM_WITH_INIT(test_split_convert, kunit_array_gen_params,
-				   test_handle_unwritten_init, NULL),
+	KUNIT_CASE_PARAM_WITH_INIT_UNIQUE(test_split_convert, kunit_array_gen_params,
+					  test_split_convert_param_init, NULL),
+	KUNIT_CASE_PARAM_WITH_INIT_UNIQUE(test_split_convert, kunit_array_gen_params,
+					  test_convert_initialized_param_init, NULL),
+	KUNIT_CASE_PARAM_WITH_INIT_UNIQUE(test_split_convert, kunit_array_gen_params,
+					  test_handle_unwritten_init, NULL),
 	{}
 };
 

-- 
2.47.3

