Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.182
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795234455;
	b=jKB0B1xky8p02F/+xsqJ55NcoEJe3sYBr/vc7YiwDq4vzOB4u2zPfQBaRmIbBWOq2/yc
	 RUxYtrpcJpGrRJpidgZfHvfKJrBh1Uz0/TbFRQG5kt45lORkCQNxJFHgDeaJ8mlhQC/Je
	 S3Ssx0j77k1O7c5fwrrqx9PgNIuwrEUOUSAi1p41fzTLawsKRS35TAvU7ucn86+UigWRA
	 9C73DHVYorVMpikOWx31xpxgtVc9T2GjLTe4lNoNM+UYH2S4FYoVodmzPmNyuV0yY2E9T
	 SCA0wEiIALtAaiwN0xKS7CjV1IHpG82lBZMRePEPdCHQMoiQzC2vQ8T4vauA90PTV7A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795234455;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:From:In-Reply-To:References:MIME-Version:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=s1oUBUVsJdLlZK0BnMYfKVB2CVE8s/YWPNE5QQrqzaA=;
	b=tSPOf8a9g96GbBurVwI4KlCtb30jusMaTQIPOA1G1J2J+fTP9t1aKneEikKtd+/fjF6N
	 BpRuxQXNdpGVhbvoVCV0RiDBxsNKjEn4A1JUfeiIN+am2EyN2/W3UJ+/fRI36dhdCPBQi
	 RUSeQe4Teofc4OI/qQS1cH2ytndt8IviFmTZHTL1s8NH7IwLWyJpL3nynxXQ9bGVjv5QU
	 QC1F7NKAhH1afaD5DQPwC0tIBpbDkuwIA2EF9zT63S7ubpFh6bNjIe01JOpN6k9nJ4bkl
	 176oz0s4Adk6vsjbMhR+vuJU8vGe8e42ThdkcPj1/B1VTTigMKioABkeXeP/X6jC1wg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=perfloop.ai;
	spf=pass smtp.mailfrom=perfloop.ai;
	dkim=pass header.d=perfloop.ai header.i=@perfloop.ai header.a=rsa-sha256 header.s=google header.b="eD/tFb9W";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.182
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616FA606A6A9
	for <linux-ext4@vger.kernel.org>; Sat, 21 Nov 2026 04:14:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 616FA606A6A9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=perfloop.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=perfloop.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=perfloop.ai header.i=@perfloop.ai header.a=rsa-sha256 header.s=google header.b=eD/tFb9W
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-563a0462094so891011b6e.1
        for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2026 20:14:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795234446; cv=none;
        d=google.com; s=arc-20260327;
        b=rx35eJR/5TCuutyo30oJbCfLZpfDpg0x9H2l8vGBNNiXF+nx0YTH8fRynQmfShsJUN
         Z6OFePy9V4z3B5Ur/ixFKNRePpUh4gJgRNMx0rzt9hKI4RVLviPbZSIR0wKTSAAXWFzV
         Uo1HRoMfBZXsOH2n8HQe9JoOVfNBeaY7Mvmk0gzAcq78vShKIdGjJ6/rritduaJ+HSJ2
         caF15290HoO7GOuNPgx2puf2uK6H2KuDoMNJLlVo4mWsP8tLwOhtVqemn2lriNdX9wfm
         gDGkiv7S6hl7Q5tP83OvhNKWTZcjpf5u4q/WTlD75u5gEGt63vXSvJ8eRgV91oeoXHku
         KV+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:dkim-signature;
        bh=s1oUBUVsJdLlZK0BnMYfKVB2CVE8s/YWPNE5QQrqzaA=;
        fh=V3rOQ5NHDSxXMz4Hn7kjXgypKa0OAj/KVtfrgrgLmmM=;
        b=fajaO0SMaVAH4SOeqJYntnaGgXTtDzNJZLTrfmaLG1wCjmCVwZ7QxIRw9Kcc6OFx4Q
         Zr30+T7fZF7hwHMaPQuyjlRpFCaX8WELYpvNnVSp+2JH8ZQ5jZjk/OOEZVWZL2YGxzHR
         Z22BNzVcvmOnYpOye2dXmb0tLYjGDSTkyuxg++zeqKSp1T3LZX716XXdWXrx7Q4NuSG7
         VIGsqIrUCLD86qAapTZlrV0+jOdC8D2ek6SNGBNto+LP6+sBhAHpKpikY6hIOaejLCwq
         IFDqqaJPMeG9f/+wIs8AgXfnlwPtmX3hgCBid48Ck0SguB64Kfwk9tONMXxn739u6zvf
         JcBA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=perfloop.ai; s=google; t=1795234446; x=1795839246; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:references:in-reply-to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s1oUBUVsJdLlZK0BnMYfKVB2CVE8s/YWPNE5QQrqzaA=;
        b=eD/tFb9W0QTkZfqXX2nY5syzxoHKkMcvyjIGZ7Wk1DVYUwMwEfvGxY+UxaJ2PAVwxY
         uQ/yNcPc2mIkQA6v3NAk7JWhYcWgCV7X02rDRlNSgR1+E5S1Fym992p5q/+xwqH3bDUS
         2aW/FfCl3UW3jPngIzEVKSbwo5eRz+f2bPx56lLGX3nsqCCgBv3SpKk9Zi2NLLKeVVrI
         Tp6jDVbYVE9rx/Ovu/yF5YQ9gOb9ZPscWckCvNdwJlZTuSfB58YOWRs3Wxmfv5tuJgGQ
         nZzej4qYVdSJCcmyF41kXyDYTRcohlHjMIiB0AZQ98VGF9YidyUsb5LwXWmYNVB8SoeR
         jrXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795234446; x=1795839246;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:references:in-reply-to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s1oUBUVsJdLlZK0BnMYfKVB2CVE8s/YWPNE5QQrqzaA=;
        b=w8LJrCDBcssZcWPQCNesewHsMvL5JhSr4B2lZKSVs27JhxfERe506abuqJHNhLyARV
         X4u5ThlG5BopL3iW6KL6guxG87sMleYUXSPtpC+LTWHaC2QFL+hoZUbYQHijMnwXhXaX
         VLMlO/WRZie73PvcmzFmvysO0s3uZ/OkmCYgu6ZmbpTt6v7hmyt8S0ersPpr1w/HqlcX
         JT0KhH2lnRc55XBMiwcSTlkuHDyg2aVbtLcDREYMnpLEA962BQMURE+JxOatXXjFeiid
         HQT3HOxbZty76wEnLVJWxA+z+QnhhLdLJVdlS8d1dyMn+H8eIxTBRHEVTDD1Qj/0vGwx
         Z28Q==
X-Forwarded-Encrypted: i=1; AL+hErEIt7omELya7Yswdb5xBJCwuiQx7Xd29f1rQpbmWzPq1hVbgkbX3rd4ejxc9lrUJlsxJBuwEQG1G2Ub@vger.kernel.org
X-Gm-Message-State: APuU4Z9AVHGBqvC7mHTp1HjhSwf9K6VrFYHQMw5WSs8gOkBjUQ9FHDP3
	0f9AS/ch2dOGIfjW6SV94sD56JznbJbVAcBUnC/a6mt+GKlgC9+70zIVegXzsUOT/i0vQNo3CSW
	tJolMNNAuWDRyNNZg3NCbldG22Hc8eGodkHmQHHM6c1I=
X-Gm-Gg: AYBFou3ntQVXBDq9xPKr+qTn7ZELq6rblnXDo7nWExLiiRheNvEOwaLsDmZ7FJ1Lmk/
	MuQApqlSSTwoBDdSh1gNeUgR8NTJdJRNkORQFKldtpGGlfuzWYOMKIxR5R/vv781k1eQ2b5CGTF
	G8vZNxLwMQ0xg/Pxyk5eOiJbybyg/kv0u7Yp/T8vHu9LLslpQ1lzC4iLqZvA3HsNPM3ah/g+hjX
	3TY4RY+1ih3rn32YV6a0yllSxSxn48IVljHHx9iTUbuYTT6KbmAKmNDVbPHQmKzdXHroODDHD7F
	xo46d+B0OWwqNA9rtzQ2XyK/xvC2OpDS3O4WRjs1UsceutyB21/hXg3EEUCt5ZwdqC7tWpmrvoB
	XcBGewNFJ7c2i4JNKfcQS8hNEMKBuCZTvHZrVi7CHS4082xgBOjWFMf+QcMG67SGaNfFU0J/Wfm
	cFRD0kbzk0FXjuiqYpX850p29V5UQfmcC3QSTRjp3NQQ15+zAPRQi4qH4t8R/SZtGVqxcbSBuK1
	FRjn7DzaZuXM1ceLLJWLqdHJT15pWTV6OoVihE0zuB2pbzok1Wo8H0/6HFJcLAQoSXJxJcnEw7d
	d1dw55jTu2kP/L84UwJqBNjJHQ0qi/ZNeBL+nVIvhg==
X-Received: by 2002:a05:6808:1645:b0:503:8f9d:f11a with SMTP id
 5614622812f47-57a0a10c7a2mr5856561b6e.29.1795234446035; Fri, 20 Nov 2026
 20:14:06 -0800 (PST)
Received: from 202080787392 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 21 Nov 2026 04:14:05 +0000
Received: from 202080787392 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 20 Nov 2026 22:14:00 -0600
From: =?UTF-8?Q?Tom=C3=A1s_Senart?= <ts@perfloop.ai>
In-Reply-To: <CAEEBa3XJt0XU+5pXNQz_tjZyPEeEnY67i_QGupOnHLnXB=BVDw@mail.gmail.com>
References: <CAEEBa3XJt0XU+5pXNQz_tjZyPEeEnY67i_QGupOnHLnXB=BVDw@mail.gmail.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Sat, 21 Nov 2026 04:14:05 +0000
X-Gm-Features: Aa3M54opRXm5ReTm4e3sjvrgM48zr-FpYqoMbn_tWRbU6Gsjp5HSemBksayrHS0
Message-ID: <CAEEBa3Un8x208Ox=20TTmGgcmdMSTCC41fB7SWP7uuY1N3xLPw@mail.gmail.com>
Subject: [PATCH v2] jbd2: fix fast commit recovery failure when the FC area is full
To: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Cc: Harshad Shirwadkar <harshadshirwadkar@gmail.com>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

jbd2_journal_load() sets j_fc_last to s_maxlen, which is the first block
past the end of the journal, and jbd2_fc_get_buf() never hands out a
block at or beyond j_fc_last.  The recovery loop in fc_do_one_pass()
nevertheless runs while next_fc_block <=3D j_fc_last.  If ordinary fsync
use has filled every usable fast commit block before the next full
commit, recovery reads one block past the journal and jread() fails
with -EFSCORRUPTED ("JBD2: corrupted journal superblock").  The
filesystem then fails to mount after a crash until e2fsck is run.

Stop the loop at j_fc_last.

That alone is not enough.  ext4_fc_replay() calls
ext4_fc_set_bitmaps_and_counters() only when it is called again after
fc_replay_num_tags has reached zero.  A TAIL tag always ends its block,
so the call that handles the last tag returns JBD2_FC_REPLAY_CONTINUE
and the finishing call used to come from the next block.  When the last
fast commit block is the last block of the journal there is no next
call, ext4_fc_replay_inode() has already cleared the inode's blocks in
the bitmap and e2fsck reports a block bitmap difference.  Do the
finishing step in the same call that consumes the last tag, and drop
the in-loop copy, which would otherwise run it twice.

Reproduced in User-Mode Linux with 1 KiB blocks (mke2fs -J size=3D8,
63 usable fast commit blocks) and 4 KiB blocks (default journal, 15
usable blocks): with the fast commit area exactly full the unpatched
kernel fails the mount, and with one block fewer it recovers.  With this
patch mount succeeds, the file has all fast committed data, and
e2fsck -fn exits 0 with no differences after recovery, for the full,
one-block-short and three-fast-commit cases at both block sizes.

This bug was found with Perfloop, an automated code analysis tool. The
fix, this message and the reproducer were written with AI assistance and
reviewed by me.

Fixes: 5b849b5f96b4 ("jbd2: fast commit recovery path")
Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Cc: stable@vger.kernel.org
Signed-off-by: Tom=C3=A1s Senart <ts@perfloop.ai>
---
v2:
- Please do not apply v1. v1 only changed the loop bound. As the
  Sashiko review pointed out, a full fast commit area then mounts but
  skips ext4_fc_set_bitmaps_and_counters(), and e2fsck -fn reports
  "Block bitmap differences: +2113" (4 KiB) and "+32769" (1 KiB) after
  recovery. ext4_fc_replay() now finishes the replay in the call that
  consumes the last tag.
- The reproducer now runs e2fsck -fn after recovery.

Tested on torvalds master 65e4fd942f72a9dba0e4e257290c4fa1aa756854,
under User-Mode Linux only, with one journal size per block size, and
only with INODE fast commit tags (no create, link or range tags).

 fs/ext4/fast_commit.c | 9 +++++----
 fs/jbd2/recovery.c    | 2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 0cac890cf370..5d9b95817ac6 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -2608,11 +2608,8 @@ static int ext4_fc_replay(journal_t *journal,
struct buffer_head *bh,
 		ext4_fc_get_tl(&tl, cur);
 		val =3D cur + EXT4_FC_TAG_BASE_LEN;

-		if (state->fc_replay_num_tags =3D=3D 0) {
-			ret =3D JBD2_FC_REPLAY_STOP;
-			ext4_fc_set_bitmaps_and_counters(sb);
+		if (state->fc_replay_num_tags =3D=3D 0)
 			break;
-		}

 		ext4_debug("Replay phase, tag:%s\n", tag2str(tl.fc_tag));
 		state->fc_replay_num_tags--;
@@ -2656,6 +2653,10 @@ static int ext4_fc_replay(journal_t *journal,
struct buffer_head *bh,
 			break;
 		ret =3D JBD2_FC_REPLAY_CONTINUE;
 	}
+	if (ret >=3D 0 && state->fc_replay_num_tags =3D=3D 0) {
+		ext4_fc_set_bitmaps_and_counters(sb);
+		ret =3D JBD2_FC_REPLAY_STOP;
+	}
 	return ret;
 }

diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index cac8c2cd4a92..a59de33a2a4a 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -242,7 +242,7 @@ static int fc_do_one_pass(journal_t *journal,
 	if (!journal->j_fc_replay_callback)
 		return 0;

-	while (next_fc_block <=3D journal->j_fc_last) {
+	while (next_fc_block < journal->j_fc_last) {
 		jbd2_debug(3, "Fast commit replay: next block %ld\n",
 			  next_fc_block);
 		err =3D jread(&bh, journal, next_fc_block);
--=20
2.55.0
