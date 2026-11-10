Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794330577;
	b=Gn8PAa8i9PAq7vjRjGwQNvZNalwnn+OblIWyuT1J6fjk3mybdGIdtZXcbWCQp4xMuLPi
	 AUzf7ohUMRgxpOf/hBUymFjWe0A0P7Zl77pO8wgbGM8giZqJxfdjN77eH5HDruG1bF/yZ
	 rFk0GdcLgnSbNwZ8j6jVoTEBKhCO6QRCgmOC12E9wZ/HZr34duuxNwIcpweFtTKUcqOHP
	 7dOnLt/41Tm6TvYRzP6NVMsuZH1lR5NPisZ4hmgTfSL1HbcuFY2i/AXyPR/9++Tr8M5Ez
	 zrA+HzfvlyX1iWdcd8X9L5L0Y9g/e/JOyi88dv6B5ubn/zWZh/6Vzrt0WW2yllMSLfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794330577;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=FX0ntURYg8eIhjfegCbeWEmVt+6ZxkQLI0onww+9W+Y=;
	b=L8q5G6GeWSM4Tbul+Ewlmyrimc0/eBRKMAj9rDNgYWAlyJ2h7VUL3p4a9P++JNYQcAP1
	 TcZMhRLButZUG2AP3jhEzJ2WNey0o63DTnTEjthmLDZn+MwxAa1+TJMV+cOlpED3XSXB2
	 cXwAjftxLu3GyAbYcBKSupu1cddFs1O+Ro7yzC9xS3yZ3rBx8WM6iVRnr/I7+YFAkfYem
	 ZK4o0tsDcFh7oEmzcnTWqGzXmCVpwwAU9jI9u8lnVl+T00TxDQpukmpbfrk3nJ8AEqmD9
	 BQinUe8Gn5vw696TxD7VNEuZEcu5PBX3GZHus09yBz9Z4jaLw0bzQPnZl6ue9zb+o9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NL8PnpcN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086B7606A325;
	Tue, 10 Nov 2026 17:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NL8PnpcN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C041F0089F;
	Tue, 10 Nov 2026 17:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794330576;
	bh=FX0ntURYg8eIhjfegCbeWEmVt+6ZxkQLI0onww+9W+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NL8PnpcNu5L1oW7LmEuKbE917f8+XynN4V7m0dOS8iJIejl33qDmpONilUgIZobK8
	 UaQneZAIGJWAlwe4DL0y17gMUtjshJ3nvA8tVGMiUBX9v/SBAJNJzN5/wQ0Po1XrXg
	 ETMwEiiFUQn9372FH30wsejUrL5Y7v9mC/amQ4LV1nU8PtnXATrvubGrW6Z9+L+GTe
	 L90FTJswXGhM/KjNwQ6QijpXLMrH6FS6D3aOG8oH5RAAGtjYiFyBRk7KBITK0p9lGR
	 GO/GJRkOBZyXAlKKJeV6bFPT4TgjQo33cE/Cw548fuJYv0ZwBvUTRLCpKosel2yYG8
	 0uCx/kcNcumKw==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Subject: [RFC PATCH 3/4] check: add --loop-on-fail long name for -L
Date: Wed, 11 Nov 2026 01:09:19 +0800
Message-ID: <20261110170920.3302511-4-zlang@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261110170920.3302511-1-zlang@kernel.org>
References: <20261110170920.3302511-1-zlang@kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The -L option reruns a test <n> times after its first failure.  Give
it the long name --loop-on-fail so that all the per-test looping
options can be described consistently as a --loop family.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 check | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/check b/check
index b30532cf..96e4f2fd 100755
--- a/check
+++ b/check
@@ -70,7 +70,7 @@ General options:
                               iterate the test list <n> times, but stops
                               iterating further in case of any test failure
     -l                      line mode diff
-    -L <n>                  loop tests <n> times following a failure, measuring
+    -L, --loop-on-fail <n>  loop tests <n> times following a failure, measuring
                               aggregate pass/fail metrics
     --loop <n>              run each test <n> times, measuring aggregate
                               pass/fail metrics (test fails if any run fails)
@@ -402,7 +402,7 @@ _set_loop_mode()
 
 	[[ $count =~ ^[0-9]+$ ]] || usage
 	if [ -n "$loop_mode" ] && [ "$loop_mode" != "$mode" ]; then
-		echo "check: conflicting loop modes: -L and --loop are mutually exclusive" >&2
+		echo "check: conflicting loop modes: -L, --loop-on-fail and --loop are mutually exclusive" >&2
 		usage
 	fi
 	loop_mode="$mode"
@@ -418,7 +418,7 @@ _set_loop_mode()
 parse_check_args()
 {
 	local short_opts="g:x:X:e:E:s:S:lnri:I:TdbR:L:h"
-	local long_opts="fs:,exact-order,large-fs,extra-space:,udiff,help,iterate:,iterate-while-successful:,loop:"
+	local long_opts="fs:,exact-order,large-fs,extra-space:,udiff,help,iterate:,iterate-while-successful:,loop:,loop-on-fail:"
 
 	compat_old_option "$@"
 
@@ -526,7 +526,7 @@ parse_check_args()
 			export SCRATCH_DEV_EMPTY_SPACE="$2"
 			shift
 			;;
-		-L)
+		-L|--loop-on-fail)
 			_set_loop_mode on-fail "$2"
 			shift
 			;;
-- 
2.56.0

