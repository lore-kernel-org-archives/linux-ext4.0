Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794330572;
	b=rpQf1h6K6LEkZMiv+YVezI0a3YpGLuwiVyimKIOtbe0Lx7ilAECaOtNxbKWK457fyxYl
	 tiRmqA2/pxJ7huGZNQc004ukBwX41gMLJv22xy4oJQNqRySRWEnyEZz5/gof33Q6LLm96
	 sS8bUw3YYoTWkHhqcliL2rOabyITZ9zBXgplOqbyqGpZZtEP6CW3zcYzdIg7ZRnSyhnK7
	 zo8ByvHYP35t2xvPqobJXOlOuhj3v6YfSX+v6h1qHwcVzLu6yCVGnASA9CMjKInKgtnV0
	 F59rawqTJuQzDedyJQaROedt4N9E2GCooxwJCIuuoR6DAGSk1yzRJK+sSekKTQjdsVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794330572;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=27zA0eunO5kr2ltAP+GWYEimQmCVTnvdM7p9hNCqBys=;
	b=4MqDvC/PMM746yTNa3o7bqqiayMwFS/AbAkiAnDVL8VAwm6QKerppGh4fLXSXcqgVC50
	 jYvOo/zCKZe3GCwM2lSsp9uw2uHJCXmq61XQ8Uj+x1SZvYGNgSchK3dfjwM13g6he96mW
	 LoPpPdZiOfcrKVVmQ02NJ/zjqxTAFSYhkozT+AXCWGmmob4MFzCSpb0Pq7731/EAhUjdp
	 ekL8dZPFEJ9xrmHmDne/1sQ1HmnwgYMTwWwxzoiKTfr3huLDV6vkmZh8OnqRKZxL/pJqD
	 rwjfGJ4yCHpirWqDamwU0J/3KXMKn1jumvC2Ltu8xULa6bL3Cjm/kuJpBgbHEEffw1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DedyqaZW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D1A606A31C;
	Tue, 10 Nov 2026 17:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DedyqaZW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0160D1F0089F;
	Tue, 10 Nov 2026 17:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794330572;
	bh=27zA0eunO5kr2ltAP+GWYEimQmCVTnvdM7p9hNCqBys=;
	h=From:To:Cc:Subject:Date;
	b=DedyqaZW2/ti/u5Q0pU4jg0W7coCAPFxoTk6RTvoQ5/o+oTj7grNOGyo+y84sZUDG
	 iYy73yhb3hVrbpZUKAlEUG//ub/AaO5AW7orh9+uN6JW+uvHeW0S8nTcZcfIaOJg6e
	 mRYRjwOt1q3Y/ibvAbx69rcGDU+GCbnOoUdx3AkHxzp21B+2D7m/Z16MUs3UXQ6JSg
	 v5HpTPBRVdSkcXjCZmrGFFc9t3zwKzLa1torAxLQw8x1hkRymecTBBpIPcjgsYGcH8
	 nahNcl6uxC7YbpLeuL+bTVwy7CrzNtZptrdOUWQ1/MDfmaIU7tZpPMRsf9L1eBdgbQ
	 FMCZYd7o9Ow9w==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Subject: [RFC PATCH 0/4] check: add --loop* family options for repeating tests
Date: Wed, 11 Nov 2026 01:09:16 +0800
Message-ID: <20261110170920.3302511-1-zlang@kernel.org>
X-Mailer: git-send-email 2.56.0
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

This series originates from Ted Ts'o's RFC:

  [PATCH RFC] check: add new option "--loop <n>" which runs each test multiple times
  https://lore.kernel.org/fstests/20260415213248.1795275-1-tytso@mit.edu/

At the time, we didn't reach a consensus, and because the argument parsing in
./check was quite messy, I decided to refactor it before introducing more
options. That refactoring is now complete:

  https://lore.kernel.org/fstests/20260826102857.3224318-1-zlang@kernel.org/

so I think it's time to revisit this RFC and the follow-up changes.

 --loop re-runs each test unconditionally, fixing two problems of "-i
 <n>": per-run artifacts (e.g. NNN.out.bad) were not preserved, and
result.xml was rewritten for every test set, losing cumulative junit
statistics.  That RFC predates the check argument-parsing rewrite to
getopt, so patch 2 was rewritten on top of it, generalizing the -L
rerun state machine to support multiple loop modes.

Per-test looping options (mutually exclusive; repeating the same mode
overrides its count):

  --loop <n>              run each test <n> times.  Artifacts of every
                          run are stashed with .rerunN suffixes, the
                          junit report gets one testcase per run, an
                          aggregate pass/fail line is printed, and the
                          test fails if any of its runs fails.
  -L, --loop-on-fail <n>  rerun a test <n> times after its first
                          failure (<n>+1 runs in total).  Existing -L
                          behaviour, now with a long name.
  --loop-while-successful <n>
                          run each test up to <n> times, stopping at
                          the first failure; handy for bisecting
                          flaky tests.

Whole-list iteration gets long names as well:

  -i, --iterate <n>       iterate the entire test list <n> times
  -I, --iterate-while-successful <n>
                          same, but stop after the first round that
                          contains a failure

The short options -i, -I and -L keep their existing behaviour and
remain available. Maybe we can remove them one day, or keep them.

One open question about the junit report: with --loop each run adds a
testcase to result.xml, but the testsuite tests/failures attributes
still count unique tests, consistent with the "Ran: ... / Failed ..."
summary.  Before this series the two were always equal, so report
consumers that assume tests matches the number of testcase elements
would see them diverge for the first time.  We kept the current
semantics for now; comments on whether the attributes should count
per-run testcases instead (a follow-up common/report change) are
welcome.

Thanks,
Zorro

Theodore Ts'o (1):
  check: add --loop option to run each test multiple times

Zorro Lang (3):
  check: add long aliases --iterate and --iterate-while-successful
  check: add --loop-on-fail long name for -L
  check: add --loop-while-successful option

 check | 153 +++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 120 insertions(+), 33 deletions(-)

-- 
2.56.0

