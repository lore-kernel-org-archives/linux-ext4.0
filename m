Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1B537106E
	for <linux-ext4@vger.kernel.org>; Thu, 13 Aug 2026 04:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786594317; cv=none; b=rc8xIXYWzg6KvcjbP98DFBke8HR+fl/GIqlrhSHmMm0/02SHjBVwUugvAcoQoO1d8Vg4Qe+NYicAwLBx0JxcHHurIPSPMcvL35SKAaAcDYyebG2o+yJKLX7qdKH1q3+t4NHDh+e4b04XC0ldkPfMwB/z9KfBhvOrRhMs+5StYLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786594317; c=relaxed/simple;
	bh=Gnzg7LxLmW/AaeD3Pv1ryB6Tex49wbpWBcRevOIJ/7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iSX7gx+95iOnyBx5Fz9luIlIZCjHt87wmowYEfMYrVUVZhYrnsnxrPH4Ulu3d+HYkWhFCjHxR1TN5fSTlTBewIL6xKlHvJkfasXsyvcazKjFvP11lFIx1LoucF6Dt7btF1fZAT9G67BUYl9tt/bQVRuXx4YmW3D4/wSzMFFxUdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sVMbCfDl; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sVMbCfDl"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3900e39d935so368323a91.0
        for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2026 21:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786594314; x=1787199114; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gnzg7LxLmW/AaeD3Pv1ryB6Tex49wbpWBcRevOIJ/7s=;
        b=sVMbCfDlTfIv4/xVpIItYsFiNHw9hjA8pH5oWjb2SVG7QOhoY//S7FxxUdNlsngf7h
         rB/7Voc650rDZACEqxOozA+FecWj63KbnyIcxgFqYsWICZlpAVDfq5sQdsBpuBrhQb2S
         4pXvE47jxM+z/hnBhkw37LpTFNEdiydf8D8ud07xzbBL34AEkvJ7i3VTgWUulws9gvwy
         lRkmfWfo2gZefxcDRoL6yR76/pVjgmTjPw4/3LC/tSPtf3YMTDnZP/wihMDtsrYL9tSc
         8Lje0WR8kXCSeZjk/+YK9r9Iv+ENPWKz7SKiJ/w2nK8nB//Q1fjvM5JemGrysvF9gsAB
         4Mvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786594314; x=1787199114;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gnzg7LxLmW/AaeD3Pv1ryB6Tex49wbpWBcRevOIJ/7s=;
        b=c5pEeadENnbT42/mP9UWAW5xBaMwRkVegzciJb1IrxcTHDqH2w4URyWJsLd9tcmlL2
         Ytg6WdRGzaoXfYsBp+ZZcb9dJjVe9BB8JNWotuuUUu9EeFvhG8rj+7diueeoqOIgQFqk
         ut0U4FtsQ5MoJ2VJikiYhOVLFfze9IkYaVEaIW9lfM21Bds7cQFXDL//P99GUbpwBwqm
         Fn8tNEuMmkvnJu5J+mMDDJCbZD+WHcwNzL14lTP3tfBMT2Jug0LZ1uFQNUeQGcKXA74b
         1pFLkniwttxyTLZfEvFiM+Ir+Y7NRYdvNlM+QIeAnYU2b6yugQCDt4PvIrygkvRVnsbl
         LcfA==
X-Forwarded-Encrypted: i=1; AHgh+RqvXe32Sgi32EGiXpdIj7AOmepK1N2IAnv06aiVJ83DX6WYolb/hxFK2ZgMQnaHrJV4XnrHb01VhvBQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yxs9ezrlQWX6glTCbAlWw4lCMoUVAAyoTc5YgVGVTT+bAo9j6AV
	H48FAFwFDxVH6k/OUiu+oUleGlKqj/wIv6ZUR5L8zEWEUQ5lytpgf8uV
X-Gm-Gg: AR+sD11Js5VeCIRL3uDVQ2WF4Ld7CfTioz572tP7bOTI9UEeqF96KbYZa4KlyMyj9IP
	p+2kwemeKvPBmqtFuVaiNWoMIMgWlcbkC1HjBGFH49tpPta3kjs8VyCxAtdjAdybBr3V7e1TgQ8
	x5ewu3e7fqBfDdZ6kApKr4HRGXyLZBsriRYYZ8EVnXMFgoDYRLvgeVxf5DUtufPNtcNLT3/dc+l
	PQtU1aC5Yb48tXYRIY0j5hZBO//LNyiMSvluYKdDp4v+u6jU46d1fRLMY0mNSzlTOYAoJ8HelNS
	68pOlX3r9zp2L+gaPjke1TIHgKJULoFoJO6wg/g+2dobb62+/hZ1UpGorI24f187nNDxaqZlNwM
	ldRtTkLlL9n9dw2ReP/Z4D8URRfwlUqkzmDQgjpKhAVQrHw3dL5Cx8SVgODX/ygyrUDXrJFUiy7
	r1wN/G9snd5UQ8cXeUmpGsQVOyGwrr5ejNLzBUinIYHg6ZDWZ31/kpQcLRhE8MUNrzQAKCTHZ8f
	geM14yzGP/P4A31WV27NrWUUy9kNr9wOkmpeOmz94W2BWdjPjsuGtOdvSzLlTY6qkyccCd7ZfrW
	zv6VKyPpQdMOBu5uLD5hSyRLvA8F5+BbrQ8iUl5KGnDxWDVKFHhz
X-Received: by 2002:a17:90b:3846:b0:38f:5801:dc0e with SMTP id 98e67ed59e1d1-3931e2a32bbmr3024404a91.15.1786594313939;
        Wed, 12 Aug 2026 21:11:53 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.252.203.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3931f478658sm1127538a91.17.2026.08.12.21.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 21:11:53 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: syzbot+b3fba2e269970207b61d@syzkaller.appspotmail.com
Cc: brauner@kernel.org,
	cem@kernel.org,
	gregkh@linuxfoundation.org,
	jack@suse.cz,
	jfs-discussion@lists.sourceforge.net,
	kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	shaggy@kernel.org,
	syzkaller-bugs@googlegroups.com,
	tj@kernel.org,
	viro@zeniv.linux.org.uk
Subject: Re: [syzbot] [kernfs?] [ext4?] INFO: task hung in sb_start_write (2)
Date: Thu, 13 Aug 2026 12:11:48 +0800
Message-ID: <20260813041148.2302176-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <6a75a39e.01d0871a.3a0d52.0042.GAE@google.com>
References: <6a75a39e.01d0871a.3a0d52.0042.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The C reproducer neither demonstrates a kernel bug nor matches the
crashes already collected in this bucket:
https://syzkaller.appspot.com/bug?extid=b3fba2e269970207b61d

It lowers hung_task_timeout_secs to 15, issues ioctl(FIFREEZE) on the
root filesystem, then forks a child that opens an O_TMPFILE there.
The child blocks in sb_start_write, as any write must while the
filesystem is frozen. The reproducer sleeps for 60 seconds before
thawing, so the hung-task report fires only because it shortened the
timeout below its own sleep. The default 120s timeout would not
trigger. Any CAP_SYS_ADMIN process can produce this report on any
kernel: this is fsfreeze working as designed. Whether a task waiting
for thaw should be exempt from hung-task reporting is a separate,
older question.

The pre-existing crashes differ. In the 2025-08-01, 2025-08-23 and
2026-08-02 instances, the blocked task waits on the sb_writers of a
filesystem the fuzzer mounted from an image: lockdep classes
sb_writers#31, sb_writers#13 and sb_writers#20 respectively. In the
same reports, the root filesystem's writers class appears separately
with a low number (sb_writers#5 held by udevd and others). The
reproducer instead reports sb_writers#4, the root filesystem that it
froze itself.

The captured console logs for the three organic crashes contain no
FIFREEZE call. One contains a single stray FITHAW, so a freeze before
the captured log window cannot be excluded, but that must be
established before treating this reproducer as the explanation. If a
fuzzer-issued FIFREEZE on a mounted image caused the hangs, the fix
is for syzkaller to sanitise FIFREEZE, and the bug is still not in the
kernel. Otherwise, something wedged those superblocks' writer gates
with no fsfreeze in sight, which is a real bug that closing this
report on the strength of the reproducer would bury. The mix of image
filesystems mounted by those runs also explains why the subsystem
guesses span kernfs, ext4, jfs, xfs and bcachefs.

I therefore suggest treating this reproducer as matching the
signature, not the cause. A previous generic-signature hung-task
bucket, "task hung in do_rmdir"
(https://syzkaller.appspot.com/bug?extid=e68dbebd9617a9250e8d),
contained a real ext4 livelock. It was fixed by commit 54b6bd40898d
("ext4: stop retrying saturated xattr cache entries") in the ext4
tree:
https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/commit/?id=54b6bd40898d

Such buckets can hide real bugs behind an uninformative victim stack;
the per-instance reports contain the distinguishing evidence.
