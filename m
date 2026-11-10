Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794330578;
	b=PbyoqIOCDH1Ce7TCf1fQQ3RJxh6uHW6ELy3YIqduaiuqNIOKOqpG7q/ZTfjAZ2oFWr0P
	 TJlyg6I8+zaZ6slpztRg47qMWyx63az04FmgRysmIhGdTyQ7c253t2CpBkgCvDNfL7aHl
	 IQ+3r+GSjLzFodMIOywhYRZ7Tam00wFLX/5LQqDGLibeb6AMEscZDMgwRu0xFLBWvVUfE
	 BlUdiqOoj5Nap9K4YOCZ3dymDthySu+uWyQGqlqpblha3OPf67ZBgwseda0WYqDyQ0GvU
	 y0lcaHU9kPiUURS1Quvt0otXnIVpMRi74xkby6fU79ka9SRnWOfh7bLOyjlIyovg+vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794330578;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=I6ACTNi79TArT7Q3AYZeilVRSz9T9xrU8SPHrEtn37E=;
	b=jbxlKPShonxf0pz1l8EFgUniei/YcoHmLLtmxOyqXM5uJM1aZWNaPbyARp5alki8ItET
	 +xnQ/Z7V5A8GVRaY2QdCqPnx9PVyc2C/JvR0e2WbhLbh9s5VlA4/0BiyYVd+ye8gm2J00
	 9FfqQHcJQ5do7hgPCYAF3zDju/TpvAEEsmzM+oUdOVqy8dH8n7ptuP6znfC8lHbwjyvBu
	 lcsHnC+VVzC57ZX5JF2kQYIwpwjXPg7vGPjLiEQ8DBhehhLDkH2298JqlpjSLRB4UIdqi
	 IyMZU6xUS40VY/rNP3XtuHHmt3wYCR4E16orh/H1Vk6zpJ1U1GGJRJPeQytgtJw7g6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OQNUpBv1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDAC606A33C;
	Tue, 10 Nov 2026 17:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OQNUpBv1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EED31F008A1;
	Tue, 10 Nov 2026 17:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794330578;
	bh=I6ACTNi79TArT7Q3AYZeilVRSz9T9xrU8SPHrEtn37E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OQNUpBv109hpdWnKRUEEMespmCKox99sTwgEWVXh9NPIpRzHOVvmSLPsxI9g7qfWH
	 BvutnA1DGevp1oKuAfYUR/5VHbhFtdRnoePKW0eamX49PId7aLpjAOx0NdFoMXW1lQ
	 hT1zDrbPXZl9BlcFX/35oq0qHh0yYzXp2Vw5EEH2+mc9KImLuYWbuZTbkPrBbdBKbd
	 EuhHT/az9hWsgV0qxmGU3BITH+f+B7UCOTWWJuGeWMIlsQ3kX98utOUwo01ryA6D6o
	 EakU2/TZ+u1bCBBqm3pmTVZF6r4iI05K4BXROtRQgQwJPq0n6MCtvknfav7Xnh+5GF
	 vqef7GP2nL2gg==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Subject: [RFC PATCH 4/4] check: add --loop-while-successful option
Date: Wed, 11 Nov 2026 01:09:20 +0800
Message-ID: <20261110170920.3302511-5-zlang@kernel.org>
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

Add one more member of the --loop family: --loop-while-successful runs
each test up to <n> times but stops rerunning it at the first failure.
This is faster than --loop for bisecting flaky tests, since the loop
ends as soon as the failure is reproduced.  The failing run is recorded
in @bad, so a reproduced failure is still reported as a failed test.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 check | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/check b/check
index 96e4f2fd..6b7bd23e 100755
--- a/check
+++ b/check
@@ -26,7 +26,8 @@ do_report=false
 DUMP_OUTPUT=false
 iterations=1
 istop=false
-# Selected by -L / --loop and its siblings: "", "always" or "on-fail"
+# Selected by -L / --loop and its siblings: "", "always", "on-fail" or
+# "while-successful"
 loop_mode=""
 # Total number of runs for the current loop mode
 loop_total=0
@@ -74,6 +75,9 @@ General options:
                               aggregate pass/fail metrics
     --loop <n>              run each test <n> times, measuring aggregate
                               pass/fail metrics (test fails if any run fails)
+    --loop-while-successful <n>
+                              run each test up to <n> times, stopping at the
+                              first failure
     -n                      show me, do not run tests
     -r                      randomize test order
     -s section              run only specified section from config file
@@ -402,7 +406,7 @@ _set_loop_mode()
 
 	[[ $count =~ ^[0-9]+$ ]] || usage
 	if [ -n "$loop_mode" ] && [ "$loop_mode" != "$mode" ]; then
-		echo "check: conflicting loop modes: -L, --loop-on-fail and --loop are mutually exclusive" >&2
+		echo "check: conflicting loop modes: -L, --loop, --loop-on-fail and --loop-while-successful are mutually exclusive" >&2
 		usage
 	fi
 	loop_mode="$mode"
@@ -418,7 +422,9 @@ _set_loop_mode()
 parse_check_args()
 {
 	local short_opts="g:x:X:e:E:s:S:lnri:I:TdbR:L:h"
-	local long_opts="fs:,exact-order,large-fs,extra-space:,udiff,help,iterate:,iterate-while-successful:,loop:,loop-on-fail:"
+	local long_opts="fs:,exact-order,large-fs,extra-space:,udiff,help,"
+	long_opts+="iterate:,iterate-while-successful:,"
+	long_opts+="loop:,loop-on-fail:,loop-while-successful:"
 
 	compat_old_option "$@"
 
@@ -534,6 +540,10 @@ parse_check_args()
 			_set_loop_mode always "$2"
 			shift
 			;;
+		--loop-while-successful)
+			_set_loop_mode while-successful "$2"
+			shift
+			;;
 		-h|--help)
 			usage
 			;;
@@ -805,11 +815,13 @@ _add_bad() {
 
 # Print the aggregate results of the current loop once all loop_total runs
 # have been recorded, then reset the loop state so that the next test can
-# start.
+# start.  A non-empty @force argument ends the loop before loop_total runs,
+# which is used to stop a while-successful loop at the first failure.
 _try_loop_aggregate() {
 	local test_seq="$1"
+	local force="$2"
 
-	if ((${#loop_status[*]} >= loop_total)); then
+	if [ -n "$force" ] || ((${#loop_status[*]} >= loop_total)); then
 		printf "%s aggregate results across %d runs: " \
 			"$test_seq" "${#loop_status[*]}"
 		awk "BEGIN {
@@ -845,7 +857,12 @@ _stash_test_status() {
 			# any failed run fails the test
 			_add_bad "$test_seq"
 		fi
-		_try_loop_aggregate "$test_seq"
+		# a while-successful loop stops at the first failed run
+		if [ "$test_status" = "fail" ] && [ "$loop_mode" = "while-successful" ]; then
+			_try_loop_aggregate "$test_seq" force
+		else
+			_try_loop_aggregate "$test_seq"
+		fi
 		# the rerun loop handles @bad/@notrun by itself
 		return
 	fi
@@ -865,7 +882,8 @@ _stash_test_status() {
 		notrun+=("$test_seq")
 		;;
 	pass)
-		if [ "$loop_mode" = "always" ] && ((loop_total > 1)); then
+		if { [ "$loop_mode" = "always" ] || [ "$loop_mode" = "while-successful" ]; } \
+		   && ((loop_total > 1)); then
 			# start a rerun loop
 			_stash_loop_files "$test_seq" ".rerun0"
 			loop_status+=("$test_status")
-- 
2.56.0

