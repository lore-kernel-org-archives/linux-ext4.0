Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A3F53976C
	for <linux-ext4@vger.kernel.org>; Tue, 22 Sep 2026 11:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790075084; cv=none; b=o785v66t8NjXp59ICkBV/IS/QmXkODGIzEVLkJdjoDqPs/CxqEjud6Y2cixJqz3TZpXD+x6HhRYEpxsW8Zq+vCD/UJFD2w+ub3tM/FCMvjMzD/UqWYKsrVKQ4urto1JB49tV/yF3Tl2YOHV/iDqIhJvoXiz1jDaw1He8EPMq1dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790075084; c=relaxed/simple;
	bh=34rh8NKADmCdD1OOPZc+WntZPuzV3DdrAk/rNK1Nc2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftahmxmjt4cpCkLS79L7I6DPuqcxhM4Yzxil1J4c2C/Uc+vnCOKHiZahm8OG0LL5Ph6rlkj08m7Vaj6IE2hjp33VuCLTde7ieP1CmUi/HrG/ODWzj6B5mOobePjD74LO1yg8PfI/tmTCn+gah90YRzZhulfj20OXOZjGwK9q0Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wz/e5Hzp; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wz/e5Hzp"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d90ba1d807so48660685ad.3
        for <linux-ext4@vger.kernel.org>; Tue, 22 Sep 2026 04:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790075082; x=1790679882; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HCX2UWwVG2pP+EorjF2wqDz28u9XH+QcBM4D+mVf26A=;
        b=Wz/e5Hzp3k1u5OyZ3Sjv24eJ0VqcdvvVfk0bujqwodF/Ft+baAPpQa+LgFYK8cQfOM
         hbuhE0m/gi4cCxpp36lIHijz4vPq1RExh/VabYLEpXBKQgIelu3id9x34QFpQcRRmMXZ
         G/0HyXfD+W8jYoyy/jE4ij1Q9WGQV+POVA0bHWYcWIbnGWm2ixrjCVow/crbq1RrOYnY
         hqDaJhCapDXalhOS6kPOCQc3VWneUkXZqfDTTAO7WiOfoPqzHpIsKBr0j9QLYVW3Jb3Q
         aU9wIaGKVHnl9QctcjcIaZcXobgEHkz78PNgQ7uvHxO77K/JGzqTvsBjKKQIzfrC83mZ
         qrOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790075082; x=1790679882;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HCX2UWwVG2pP+EorjF2wqDz28u9XH+QcBM4D+mVf26A=;
        b=eeuFudKN+z8T++mR+tJ4rXjBoRN+Pa1F5ad75TlUSoMgXqZmrBashwfQ8kXWA/hOJQ
         GId4xeATpM85uYZ3x10DrUH09c8+PbnhOhTKX/HaPPyYg0Nqo4XcQKCfpoC98m1Afni+
         sElOsvIHg82hMZ8mdGHnOkqCY0SVjYAIpsQv5ScNe7XXlXHf8aD7+tQA4SlBPc4bF7DT
         Vc+En8fz6o/QKI4NS87uwCwsy7Wha4fTWOpbgWsdGluAqORoT8rWFx2NUlEyNkjGJY25
         +RjFKb4DXurWxX4wRU2AxLfjNdgtGn1q7nAhjLphzKZNOo2J23BPJF9Mzu8nlGNEeiaE
         a1gQ==
X-Gm-Message-State: AFuF++kSSftx/PXqAMLTbjJSdqovkPniGR9YRlPUADC7euzCCo8UT2T6
	3NG/xHQT0qAqROCDUVfFAbkNhIE4LMQfpb1HRRZtOSIRb3M89t5KBoC1q5qaaNpp
X-Gm-Gg: AYBFou2+sVgxqiL0Q+1hNBy0TBsaBiL1ELNjKFaA6tImtnpbXG26ARfAhCpH+PAFZBy
	gnJPMRvrbF5F8nIaVAknn197noDqhKQ/d3OjNt/nz0Niohvp6H8eG/F6n4J49DkaCCBhqiFqf/x
	fWeEiRA3+ibAWFL6Vds6vMCuVfObKmdPOMVkTq4TqXbVCQimRz1c1BHDB6dBTy02wIYvE/FXylq
	3XjjEwvC4UdyAt69DdJeRw6Hb5WkehMgWN4a9XlR3yFIm9YeBRF0uJFVvdnK6zP8XojqGlNoIYf
	/ro8CqUkaFwyO01DlJ1Twdjhm6F5pWiZVM9JzYgbWfM6TBcn9PeQN18Lll2UdyOIqSwWqiL0K9J
	VKxTIK6/IcZCuxHr+GYA+WQIHG/CY6eJ0iNRtfRbf8OKCLjTDmSrNm9jttPy7Sn44BV1HxV4XVj
	gcxD+bKC52Lac065xbBzrjcymTc0hM0mfF8PC6X3xdInhuMQAMmnfMdm6cRzUAhQXN4kCxxi8ju
	c4w+fCfAXA1KjMiwvlRqHMx9D40FywLUJx31dzb5UsAmxLgczWhJF/MahVe4TwJdNuriZVY+Kqb
	iSYBWySjyq+g0uPCMHduKwqjHW5C1dg266V/YhjdnTfuTS5J47acphZv6DHYS8s=
X-Received: by 2002:a17:902:c94b:b0:2dd:ad73:c939 with SMTP id d9443c01a7336-2df609d71cfmr10332005ad.26.1790075082048;
        Tue, 22 Sep 2026 04:04:42 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.252.203.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df5d019a83sm7999465ad.26.2026.09.22.04.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 04:04:41 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Subject: [PATCH e2fsprogs 2/2] tests: add f_cache_mtx_deadlock for the flush_cached_blocks() retry lock
Date: Tue, 22 Sep 2026 19:04:35 +0800
Message-ID: <20260922110435.1528332-3-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922110435.1528332-1-matthias.goergens@gmail.com>
References: <20260922110435.1528332-1-matthias.goergens@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Regression test for the previous patch.  The image has group
descriptors that force bitmap and inode table relocation, so e2fsck -fn
fails its writes on the read-only test file and reaches the write-error
retry loop in flush_cached_blocks() with a handler registered.

Two departures from the usual f_* shape, both because the bug is a hang
rather than a wrong answer.

The e2fsck run is wrapped in timeout(1).  A deadlocked e2fsck ignores
SIGTERM, so without a bound this test does not fail against an affected
build, it stops the suite indefinitely.  The probe-then-use form is
taken from tests/r_corrupt_fs/script, with -k so the SIGTERM escalates
to SIGKILL.

The transcript is not compared.  It is about a thousand lines of
repeated "Error writing block N" that say nothing about this bug and
would need updating whenever those messages change.  The test records
the exit status and that -n left the image unmodified, which is what it
is actually asserting.  On an affected build the diff is

  -Exit status is 12
  +Exit status is 137

Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
---
 tests/f_cache_mtx_deadlock/expect   |   2 ++
 tests/f_cache_mtx_deadlock/image.gz | Bin 0 -> 695 bytes
 tests/f_cache_mtx_deadlock/name     |   1 +
 tests/f_cache_mtx_deadlock/script   |  44 ++++++++++++++++++++++++++++
 4 files changed, 47 insertions(+)
 create mode 100644 tests/f_cache_mtx_deadlock/expect
 create mode 100644 tests/f_cache_mtx_deadlock/image.gz
 create mode 100644 tests/f_cache_mtx_deadlock/name
 create mode 100644 tests/f_cache_mtx_deadlock/script

diff --git a/tests/f_cache_mtx_deadlock/expect b/tests/f_cache_mtx_deadlock/expect
new file mode 100644
index 0000000..6dd5466
--- /dev/null
+++ b/tests/f_cache_mtx_deadlock/expect
@@ -0,0 +1,2 @@
+Exit status is 12
+crc did not change.
diff --git a/tests/f_cache_mtx_deadlock/image.gz b/tests/f_cache_mtx_deadlock/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..956a1774ec0c88a1f5ed54b968acce77c77e61b9
GIT binary patch
literal 695
zcmb2|=HPf6wK0o{xhS=uC|@r#H=W___0#zwsWQhOmM>GD&LqYnIw8w(!t6^*CuF@A
z#ykn~ir87sta`WPVBd*DI|^RLAFyZW%obzWrgLY9@f%J?;X{)m?mMYVwg_;V@Yc*<
z{`2gUCv(nyne+1b*_lBN5#6t4bW)?kHIu8oEAIq*EiSIV|K&{eHp{B-w_1bL)X)FD
zTTylA#O1f?xAt#Os7em6&APTyKlWc$QU2>6=hb)D?=F3C?#SYg^6Ae~*y4AVKYsey
z-e!-<m)Gy>@8$m~eEjY3%KhaJzwA5rd4^~0*X4qr)_?W(j(fkzxs>m^<htU$-#^|-
ztNhn&6LP)zaB17?J1^!&N!DEWu<ymIVqS$%@Bad?ng2SkvlL_KFb)4NkUj68;<cK;
z&TI1iI<H~<)gHn9m4BnyOZlYQ74;og7yti$BWQX<c+{Huj;${L1zs!vb$(~=^4EDy
z>aX?)`PcGEwTtRIzOMYIc&+HK^BU1#?Gf5v`8V2Kwm%ZJw7%o&>iUkaJO3$O6aUp7
zQTwYsV)a-4jn`htC)KX3@7NmlUm$z#KgDa|zuF^Sf92n3_Ch`>_lo_ITTALYwnqLJ
zc%A*%c}@No{*BvS$R~Y$EuX{-QgGG&$S;u2+5Z%;mHl;I^ZpC}#<CakNpC?qm)3V|
zjs7o?-TzPVTHIgfH6S~Gf92oE_d-62_mzB->=pYXQkU$H%&N(j(o@@${r7vse}&N9
z%@cQD*W04L@;|%t*M(m<eSWWXw(oJ<Y~#=W{{Q_owd`->&Ci#o{xZ0bwRguq(^K~O
zKW?S}KRzq-Z}ZLK;#dFDAEbV_Kf7tq;~mOdpDr%#yJ{Kt{I`|*t2t|mSDkxlrCfUM
zieznX_0pT~>OW;^7QgzOQG5T}mh1cd{tAnq@9#hR=kNU$U-=mr7#J$7|FPD4_*#e<
HFfsrD8IOQ`

literal 0
HcmV?d00001

diff --git a/tests/f_cache_mtx_deadlock/name b/tests/f_cache_mtx_deadlock/name
new file mode 100644
index 0000000..6911823
--- /dev/null
+++ b/tests/f_cache_mtx_deadlock/name
@@ -0,0 +1 @@
+e2fsck self-deadlocks flushing the write-error cache (regression test for libext2fs CACHE_MTX retry double-lock)
diff --git a/tests/f_cache_mtx_deadlock/script b/tests/f_cache_mtx_deadlock/script
new file mode 100644
index 0000000..8de8533
--- /dev/null
+++ b/tests/f_cache_mtx_deadlock/script
@@ -0,0 +1,44 @@
+FSCK_OPT=-fn
+OUT=$test_name.log
+EXP=$test_dir/expect
+
+# This test is about termination, not output: an unfixed e2fsck
+# self-deadlocks here and ignores SIGTERM, so bound the run or a failure
+# stops the whole suite indefinitely.  The probe-then-use form is from
+# tests/r_corrupt_fs/script; -k escalates to SIGKILL.
+if timeout -v 1s true > /dev/null 2>&1 ; then
+	TIMEOUT="timeout -v -k 5s 30s"
+else
+	TIMEOUT=
+fi
+
+gzip -d < $test_dir/image.gz > $TMPFILE
+old="$($CRCSUM < $TMPFILE)"
+
+# The transcript is a thousand lines of repeated write errors and is not
+# what is under test; only record that e2fsck came back, with the status
+# it should have, and that -n left the image alone.
+$TIMEOUT $FSCK $FSCK_OPT -N test_filesys $TMPFILE > /dev/null 2>&1
+status=$?
+echo "Exit status is $status" > $OUT
+
+new="$($CRCSUM < $TMPFILE)"
+if [ "${old}" != "${new}" ]; then
+	echo "ERROR: crc mismatch!  ${old} ${new}" >> $OUT
+else
+	echo "crc did not change." >> $OUT
+fi
+rm -f $TMPFILE
+
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+fi
+
+unset FSCK_OPT OUT EXP old new status TIMEOUT
-- 
2.55.0

