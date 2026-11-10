Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794330575;
	b=rg6WWA7ly3OKiaw6bxr9OromV3gSjf9EKS6WVmDda1tpz3/D3ZpkcQLwY8rTZCPX/OPL
	 lh01RCjRHtFXkn/OFTw1EIoIYvHePMufuA4dcXLXkR9uMDnOqBeoFJLtuD82t2v3LHSTt
	 NIsYBCgHiR7hcS1maZRy0Pqpz6BvVP89xnwbA3UtqT1kBqz2H1d6iDJuKCFJc7QD1h/hR
	 dVjP7na8Y8ho/5fnvqd+OtjR5+mle8/FDu3tqMXG4OT18jeK6+XTLeQT47rfFAzzGARp0
	 BQKEXuzc2TONAhRnanuf8zX9uUqHTnrP73LGjHnkReXKsepcftKlrK6uVrtPlssSO/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794330575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=dYT92MEVoa7zcRSzxOfuGi/Fcs3gUiiFvmEEMFUjl68=;
	b=iJp2p3Ic6/+1ZI5B+bIViVIRbhH29VddQmKeNApkPtB5Fc+lFLUxVpZxv1ojItspLUKR
	 hrdurYVOoOtcfrIMwX9CY8fXt2/1I9jRIPZFaXUg+ad7oLWJkIE5AyI0uuPxgqijSfvyk
	 rltQuEhireaHTaSawoAL9Xcfeo4jVl0JXvoqhKrKXXUs4ocodF/0AW6vZKMqmgzV6Vszw
	 Q9ea3sPSpfaJ3F3fZodbj2JPrpIwLrP5j89J/BzdUq96u/dGhrTZAaxOT+8nDEDK3vWZ5
	 bCgv1sM0LA924vfX9bXjeXjJicOSGLf+cAsCOziHLDTl9CKJgNU2DizO8GDxS/nudpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H5Dc2qny;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69545606A321;
	Tue, 10 Nov 2026 17:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H5Dc2qny
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148561F008A1;
	Tue, 10 Nov 2026 17:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794330575;
	bh=dYT92MEVoa7zcRSzxOfuGi/Fcs3gUiiFvmEEMFUjl68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H5Dc2qnyzKHsUZ35lCvKY4niSPNpbsYXN2oM4y+4A36o/a6nf8MFrSwLpzBMa4wel
	 1MFlShXrvmIC0Y06INN+cQX7Bj3uSdrZtj55fT3Dpr+BxZOlfLMjr8YfOyonXa33Ib
	 Q37vrgaA66VibggW9zmlxK1m6sPe/VSS1xGn110gxBCRW+EAOjpzB5NWRnFWsVVEOi
	 2IL7doorh/855drezWKSHkVqtRCVf0cag9WlYlxCugMFPi6uxdp59Iy3Pt7HxmvjBu
	 78+4H+iXTG7G18LbE6jNs2p2UXaUHQyfzFVtcWGO6ReFKPUUbcD+zULq8fs7D1ySSn
	 c4hbtGiL3lscA==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Subject: [RFC PATCH 2/4] check: add --loop option to run each test multiple times
Date: Wed, 11 Nov 2026 01:09:18 +0800
Message-ID: <20261110170920.3302511-3-zlang@kernel.org>
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

From: Theodore Ts'o <tytso@mit.edu>

Teach the check script a new option --loop, which re-runs each test
multiple times.  This works very similarly to -L, which retries a test
after it first fails, except that the test is rerun unconditionally.

This differs from the "-i <n>" option, which iterates each set of
tests <n> times instead of each test.  The -i option is problematic in
two ways.  First, it doesn't save the test artifacts from each test
run.  This is unfortunate because when the developer is trying to debug
a flaky test failure, running "check -i 100" will run a test 100
times, but if only the 42nd test fails, the NNN.out.bad file for that
failing test run is not preserved.  The second difference between
--loop and -i is that the result.xml file is rewritten after each test
set, so we do not have the cumulative statistics of the 100 test runs
in the junit XML file.

Refactor the rerun-on-failure state machine so that it can support
multiple loop modes: the loop count is normalized to the total number
of runs at option parsing time, and the aggregate-results logic is
shared between the initial run and the reruns.  This also fixes an
off-by-one where --loop=1 would run the test twice.  A test run with
--loop fails if any of its runs fails, matching the behaviour of -i.
--loop and -L select different loop modes and cannot be combined.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 check | 122 +++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 95 insertions(+), 27 deletions(-)

diff --git a/check b/check
index 538f22cf..b30532cf 100755
--- a/check
+++ b/check
@@ -26,7 +26,10 @@ do_report=false
 DUMP_OUTPUT=false
 iterations=1
 istop=false
-loop_on_fail=0
+# Selected by -L / --loop and its siblings: "", "always" or "on-fail"
+loop_mode=""
+# Total number of runs for the current loop mode
+loop_total=0
 exclude_tests=()
 
 # This is a global variable used to pass test failure text to reporting gunk
@@ -69,6 +72,8 @@ General options:
     -l                      line mode diff
     -L <n>                  loop tests <n> times following a failure, measuring
                               aggregate pass/fail metrics
+    --loop <n>              run each test <n> times, measuring aggregate
+                              pass/fail metrics (test fails if any run fails)
     -n                      show me, do not run tests
     -r                      randomize test order
     -s section              run only specified section from config file
@@ -386,10 +391,34 @@ process_remain_tests()
 	done
 }
 
+# Record the loop mode selected by -L / --loop / --loop-on-fail /
+# --loop-while-successful and normalize its count into the total number of
+# runs (including the first one).  The loop modes are mutually exclusive,
+# while repeating the same mode just overrides its count.
+_set_loop_mode()
+{
+	local mode="$1"
+	local count="$2"
+
+	[[ $count =~ ^[0-9]+$ ]] || usage
+	if [ -n "$loop_mode" ] && [ "$loop_mode" != "$mode" ]; then
+		echo "check: conflicting loop modes: -L and --loop are mutually exclusive" >&2
+		usage
+	fi
+	loop_mode="$mode"
+	if [ "$mode" = "on-fail" ]; then
+		# <n> reruns after the first failure, <n>+1 runs in total
+		loop_total=$((count + 1))
+	else
+		# <n> runs in total
+		loop_total=$count
+	fi
+}
+
 parse_check_args()
 {
 	local short_opts="g:x:X:e:E:s:S:lnri:I:TdbR:L:h"
-	local long_opts="fs:,exact-order,large-fs,extra-space:,udiff,help,iterate:,iterate-while-successful:"
+	local long_opts="fs:,exact-order,large-fs,extra-space:,udiff,help,iterate:,iterate-while-successful:,loop:"
 
 	compat_old_option "$@"
 
@@ -498,8 +527,11 @@ parse_check_args()
 			shift
 			;;
 		-L)
-			[[ $2 =~ ^[0-9]+$ ]] || usage
-			loop_on_fail=$2
+			_set_loop_mode on-fail "$2"
+			shift
+			;;
+		--loop)
+			_set_loop_mode always "$2"
 			shift
 			;;
 		-h|--help)
@@ -747,7 +779,7 @@ _expunge_test()
 }
 
 # retain files which would be overwritten in subsequent reruns of the same test
-_stash_fail_loop_files() {
+_stash_loop_files() {
 	local seq_prefix="${REPORT_DIR}/${1}"
 	local cp_suffix="$2"
 
@@ -759,6 +791,41 @@ _stash_fail_loop_files() {
 	done
 }
 
+# Record a failed test in @bad, avoiding duplicates for tests that already
+# failed in an earlier run of their loop.
+_add_bad() {
+	local test_seq="$1"
+	local b
+
+	for b in "${bad[@]}"; do
+		[ "$b" = "$test_seq" ] && return
+	done
+	bad+=("$test_seq")
+}
+
+# Print the aggregate results of the current loop once all loop_total runs
+# have been recorded, then reset the loop state so that the next test can
+# start.
+_try_loop_aggregate() {
+	local test_seq="$1"
+
+	if ((${#loop_status[*]} >= loop_total)); then
+		printf "%s aggregate results across %d runs: " \
+			"$test_seq" "${#loop_status[*]}"
+		awk "BEGIN {
+			n=split(\"${loop_status[*]}\", arr);"'
+			for (i = 1; i <= n; i++)
+				stats[arr[i]]++;
+			for (x in stats)
+				printf("%s=%d (%.1f%%)",
+				       (i-- > n ? x : ", " x),
+				       stats[x], 100 * stats[x] / n);
+			}'
+		echo
+		loop_status=()
+	fi
+}
+
 # Retain in @bad / @notrun the result of the just-run @test_seq. @try array
 # entries are added prior to execution.
 _stash_test_status() {
@@ -771,40 +838,41 @@ _stash_test_status() {
 	fi
 
 	if ((${#loop_status[*]} > 0)); then
-		# continuing or completing rerun-on-failure loop
-		_stash_fail_loop_files "$test_seq" ".rerun${#loop_status[*]}"
+		# continuing or completing a rerun loop
+		_stash_loop_files "$test_seq" ".rerun${#loop_status[*]}"
 		loop_status+=("$test_status")
-		if ((${#loop_status[*]} > loop_on_fail)); then
-			printf "%s aggregate results across %d runs: " \
-				"$test_seq" "${#loop_status[*]}"
-			awk "BEGIN {
-				n=split(\"${loop_status[*]}\", arr);"'
-				for (i = 1; i <= n; i++)
-					stats[arr[i]]++;
-				for (x in stats)
-					printf("%s=%d (%.1f%%)",
-					       (i-- > n ? x : ", " x),
-					       stats[x], 100 * stats[x] / n);
-				}'
-			echo
-			loop_status=()
+		if [ "$test_status" = "fail" ]; then
+			# any failed run fails the test
+			_add_bad "$test_seq"
 		fi
-		return	# only stash @bad result for initial failure in loop
+		_try_loop_aggregate "$test_seq"
+		# the rerun loop handles @bad/@notrun by itself
+		return
 	fi
 
 	case "$test_status" in
 	fail)
-		if ((loop_on_fail > 0)); then
-			# initial failure, start rerun-on-failure loop
-			_stash_fail_loop_files "$test_seq" ".rerun0"
+		bad+=("$test_seq")
+		if { [ "$loop_mode" = "always" ] || [ "$loop_mode" = "on-fail" ]; } \
+		   && ((loop_total > 1)); then
+			# initial failure, start a rerun loop
+			_stash_loop_files "$test_seq" ".rerun0"
 			loop_status+=("$test_status")
+			_try_loop_aggregate "$test_seq"
 		fi
-		bad+=("$test_seq")
 		;;
 	list|notrun)
 		notrun+=("$test_seq")
 		;;
-	pass|expunge)
+	pass)
+		if [ "$loop_mode" = "always" ] && ((loop_total > 1)); then
+			# start a rerun loop
+			_stash_loop_files "$test_seq" ".rerun0"
+			loop_status+=("$test_status")
+			_try_loop_aggregate "$test_seq"
+		fi
+		;;
+	expunge)
 		;;
 	*)
 		echo "Unexpected test $test_seq status: $test_status"
-- 
2.56.0

