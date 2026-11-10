Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794330574;
	b=EPqjHxRTo9sp4Eye9egcPpVpXgrIjhOq9/94ZC03vNr2pURnRaXVIIjvvsntH0c4saOl
	 ML78J6ZnEojJVYtsaNaalSwsPy+nXEqV9uvHiv3x6lcW/Ac7REzBqkxVPgyc1vZwPBrEw
	 iFu7YJf4o551dr7tturR+xC9iwigv78XEemw233+2iVWQVF69STkfvS3GPjrFYocJfZLy
	 AJQ2CxuwZEuTh/YWI1t9rlv8ZVHPXen70bQIw1PkVJxg7k5FmvoIUX+Cg4srIH09lURAc
	 GhpF0bLyjF+xxTQSGm81ZNud/wSPzd6n7RRErZl93zjFBUUKoqVxvIl4h9fkvEPedPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794330574;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=iztu3UTjVDiG3ZQe0zYGC6X7rQ6gTI+4J0TCR7Mw7Zc=;
	b=oVJw3ZxAhygMuAYwNXDOfRzDK6DrBHugU67+TdsvvG6I3KGV59Ycj1J2jq53vxep9CFs
	 hFShaDLPfSFIxaVgJYQlsKo99DZA7p9ltCbb02gG/ENeRBiCn8/54A3FyRitlpaCVeLhy
	 H0osUpGT8VcAUk6k5pG0du1EesSklUD1bA2eC6LWDYN0X+XS1sGKEqKMR5SMIC3ckD6ZU
	 tPerKdSFQUEdqGwFaN0BmDB4BI6Lhln5aUlRO7eFtcGy/tLIa0f+82ToL4eEWDmTfJ/D5
	 bHSewPYKWWDJYIIugKQG51pTmQxyYGWnWJCrjg1qQzZyXqzTJ/YGW5KfMeEa8VYVMDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bB+GeAHT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4390606A32D;
	Tue, 10 Nov 2026 17:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bB+GeAHT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8392E1F0089F;
	Tue, 10 Nov 2026 17:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794330573;
	bh=iztu3UTjVDiG3ZQe0zYGC6X7rQ6gTI+4J0TCR7Mw7Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bB+GeAHTTESdnnThV9OGq9pg3XzgKJLf/cllBUelwd+XZq2KaX6qHSFTcvpafKDgf
	 VWcb/07Ec8+tXZVSj2E/2npIoDqHGwRfW+os7ZoMjXG6uoavzgZ5J0ItsTWEgWLJay
	 pEMf89xo2iVqAzsn2DYygNUv55HGtFsbj5hh/ye7iU8PA3ycqQBYQzX50EwPzqWU0V
	 6S2yOjXZineaURYF659iNvYZn/A8E0ePhdis770T0kTtzM22mi6XNhezG8NiQo4/lw
	 vFZRcD0oKhtMrRfjGXuD1/VLjCaITtTrtFebsc68jKYo5yFQ5ARseUjfbREtISp+hZ
	 BByrkmoxyI2cA==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Subject: [RFC PATCH 1/4] check: add long aliases --iterate and --iterate-while-successful
Date: Wed, 11 Nov 2026 01:09:17 +0800
Message-ID: <20261110170920.3302511-2-zlang@kernel.org>
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

The -i and -I options iterate the whole test list, but their
single-letter names don't describe what they do.  Add the long aliases
--iterate and --iterate-while-successful so that they can be named
consistently with the --loop family of per-test looping options that
will be added next.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 check | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/check b/check
index afe855bc..538f22cf 100755
--- a/check
+++ b/check
@@ -62,8 +62,9 @@ General options:
     -b                      brief test summary
     -d                      dump test output to stdout
     -h, --help              show this help message
-    -i <n>                  iterate the test list <n> times
-    -I <n>                  iterate the test list <n> times, but stops
+    -i, --iterate <n>       iterate the test list <n> times
+    -I, --iterate-while-successful <n>
+                              iterate the test list <n> times, but stops
                               iterating further in case of any test failure
     -l                      line mode diff
     -L <n>                  loop tests <n> times following a failure, measuring
@@ -388,7 +389,7 @@ process_remain_tests()
 parse_check_args()
 {
 	local short_opts="g:x:X:e:E:s:S:lnri:I:TdbR:L:h"
-	local long_opts="fs:,exact-order,large-fs,extra-space:,udiff,help"
+	local long_opts="fs:,exact-order,large-fs,extra-space:,udiff,help,iterate:,iterate-while-successful:"
 
 	compat_old_option "$@"
 
@@ -466,11 +467,11 @@ parse_check_args()
 			fi
 			exact_order=true
 			;;
-		-i)
+		-i|--iterate)
 			iterations=$2
 			shift
 			;;
-		-I)
+		-I|--iterate-while-successful)
 			iterations=$2
 			istop=true
 			shift
-- 
2.56.0

