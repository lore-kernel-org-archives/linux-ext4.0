Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794316887;
	b=TrXuWcXb2k4a8WRmfExRmEdwsubT85wmOKbbXD8YJrXkf95t1qJ+7LFMhiWdzWvhrl/s
	 cZkXDF/CFzDURFCvxMFPJ7YAakRx6ai/PMLUzite8cWapuIsg/8VgE1YuQvuLh302Rh9Z
	 I2oGsGdtxlp+sxQJ2JsyYWMNTKujRX08uccYX3qhqz/Qp1ODFCYoGVOtWmRdk6tY8SYJ+
	 onEQCmkX26WXTdiMxbst3NABh82UyK+E4+iqjE/jBS0AAKI7dHponKr47QFMvX+z/XS02
	 /uZ/YWGAbNV6YQflkpFQqWdYHJayiR6k9wYQwJ9Mfj5yvNga2jIcnHhz/Qxyegg5VMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794316887;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=3tWiq7aHA+IGdy3MoPePq5JolrdZPCWKlrUl1uu+r1E=;
	b=pD395ydRUpDMyklHE2hc7Oj25TZngqJe5lHdOazjqel6MadNOX2eh3RHxnPkE1Vk5dJM
	 fOkte9QMfSAdjK19EU4Tls9qXh3EWl2Sg0k9d2eqEPaCRDpEXpbrZ927nuEKmvI8ANT9g
	 LXZ0+13PK9i/JR+h48vbViJs1v9snkAFi3rHwRPUz21wDOH9j88AOlS30LRRHB+tcb3sC
	 8hL9ahAbAxjEdfRqjfItQFFof/jD7F2prgv3TiUdfXaBqUBqF6uCVMQN74RxkPCFAQijQ
	 VS6BZwepcR63NLNFcph7pxqJwiqPQ4Yo7C2jrsK8bXQqSyoOnQQ29oe08yyuVTyAPyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="yokdV/NT";
	arc=none smtp.remote-ip=209.85.216.43
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1D9607B12F
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 13:21:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E1D9607B12F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yokdV/NT
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3b0e0e65adbso1006290a91.3
        for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 05:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794316887; x=1794921687; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3tWiq7aHA+IGdy3MoPePq5JolrdZPCWKlrUl1uu+r1E=;
        b=yokdV/NT+sxAcdfoZRwwYwindb7sUW6pJD/V0DWZnhBwloPOmxnLzXgD7wPPmWXmvh
         DidRq5OGwuFDtvdBtyZEyLy5bdNqZxkKMEjMuCdfyj9DylXTCjvalJcr93yLKYn6qmhF
         oJXItmr5I26wNNT2feuasYVd7w4QnY8Uq063Mwh9hHgn36dYAWPEO1NsX8DgNCnHXhMb
         gAvVsts8fK6jjiQac+GxZFOrm6Lq32Fdt4wwniOLHMkkkngHzVCilEJTpek0c23jGdDe
         bXaiHTSqSZAbiHpO7yNlZ225QggqnToREQQMsnmNnomLKr6B9qie0iXY0qTcSKJtCG8/
         bFUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794316887; x=1794921687;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3tWiq7aHA+IGdy3MoPePq5JolrdZPCWKlrUl1uu+r1E=;
        b=A+dNYd0/V9BqBVFQr+Z9q6tCC0zwTICDITmopvCoYeTIArRbD2aa+u/P5wRQcSxYiv
         XtO4Ul6yjwy/qP+z6Fk6qHr+UMB3tFaGei/Tct6EFCgKKoEpw9LZKMWt0ut9itjvxGgB
         hFpjQzL4u0n2xiVSeQJap5HGWma7A7uTHG93HW6uS6IOqfj9gMUApSzyOP/B5ks+19+D
         bzAA0XVQsyyjJeZE728vpzN8tpE0bq8x/echIQ16hTnf1lYNdE2cbH/JfFwhWr/pJwRx
         uCgJq5z7m0MPC7m4hZC3ihqh/hdHJMFyKr1vnNma6hhGwKG+AWgq2/gzAaQtTKGHdIfI
         OT+A==
X-Gm-Message-State: APuU4Z+UgmwnOZ26uvVLAzI+8PSLRbPa0lbh3JCAt1UZOzMY+5+efL/x
	Aofy7XL+Ff9GKFAf1rIRbDgIj2PiI2s/awn9fE4kZCAC/KrTil4Gl8gp
X-Gm-Gg: AYBFou2oUJJKrlf5cT6ASBXU+VfXb1wcJ5c6GDL6xqT7WDADOsLWK7HXH8/xeWO1rhX
	CVkSeojs7Lf/K5pi5qnZeJ5HaXYaom1rvB7Q/CYLSUpczrW0j+ih+s0kkuEViQbpBm/SFwrq035
	KLu8u7HL1LWgi5dreBAjY7rh7IVxWSryQxKzezeY9VFUPrkTW+0VW8eLssRogtQ1yf/pdkGghuF
	ofzTBJGBMebPlG58SsnFqQf8szhJPVLesvw0KyCZT+9rjRXjvGxs24yX/pusjBcrCotiQPjOww+
	dHaYNSO8ayyOegCSEvOAeQO5oueuenTfau23wZ7HZOhgn0yVRVg3hyzG+7LawQRJ6zYCHjoi6m8
	3JPydA4kmCAr1/WsnepFZySd2sEK98C5S+ns9EV6ze+EZuwXQDOYNFvltQN50lK97fVTphnNQzO
	Az2bV5awQ+vIOpjX8i8CFYLpNu7S3gXdKqTELp/Q1EjREeHIYyrw4CzuI+IUiBnagy3iu2WVcE3
	Qk/xz4rsZgDx+vEK4KRutwpZzN0KbUvH6ipjcSKiUOvVuLeuTScRO3pLgo4T3yN3e5Pe9MlqL6L
	zQ24O19jBMvG4Jx4xQqsDJQTRsfEEwP1DJF9pNtz/JUQWLjnXsO9
X-Received: by 2002:a17:90b:574c:b0:3a8:32f2:f4a5 with SMTP id 98e67ed59e1d1-3b166ce2b98mr2944296a91.53.1794316886911;
        Tue, 10 Nov 2026 05:21:26 -0800 (PST)
Received: from localhost.localdomain ([152.136.45.109])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b168eacb73sm1945635a91.1.2026.11.10.05.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 05:21:26 -0800 (PST)
From: diasyzhangqing@gmail.com
To: tytso@mit.edu,
	adilger.kernel@dilger.ca
Cc: linux-ext4@vger.kernel.org,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	syzbot+d4ecb9a1e5b3dcf8baec@syzkaller.appspotmail.com,
	linux-kernel@vger.kernel.org,
	Qing Zhang <diasyzhang@tencent.com>
Subject: [PATCH] ext4: make concurrent DEFAULT shutdown waits killable
Date: Tue, 10 Nov 2026 21:21:18 +0800
Message-ID: <20261110132118.11265-1-diasyzhangqing@gmail.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <6af1e75f.3e87765f.91969.0010.GAE@google.com>
References: <6af1e75f.3e87765f.91969.0010.GAE@google.com>
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

From: Qing Zhang <diasyzhang@tencent.com>

Concurrent DEFAULT shutdown callers can all pass the shutdown flag
check before the first caller finishes bdev_freeze().  They then wait
uninterruptibly on bd_fsfreeze_mutex and may perform redundant
freeze/thaw operations, triggering hung-task reports if the initial
freeze takes long enough.

Serialize DEFAULT shutdown attempts with a per-superblock mutex
acquired killably.  Re-check the shutdown flag after acquiring it to
skip the freeze after a successful attempt, or retry if the previous
attempt failed.

Leave LOGFLUSH and NOLOGFLUSH unchanged.  The ->shutdown callback uses
NOLOGFLUSH with s_umount held, so it must not acquire a mutex held
across a freeze.  This does not shorten the initial freeze or prevent
hung-task reports for the active freezer and other freeze-blocked
tasks.

Fixes: 783d94854499 ("ext4: add EXT4_IOC_GOINGDOWN ioctl")
Reported-by: syzbot+d4ecb9a1e5b3dcf8baec@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d4ecb9a1e5b3dcf8baec
Signed-off-by: Qing Zhang <diasyzhang@tencent.com>
---

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
 fs/ext4/ext4.h  |  1 +
 fs/ext4/ioctl.c | 14 +++++++++++++-
 fs/ext4/super.c |  1 +
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f38fec3167fb..c4e44e3d58cc 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1647,6 +1647,7 @@ struct ext4_sb_info {
 	/* Journaling */
 	struct journal_s *s_journal;
 	unsigned long s_ext4_flags;		/* Ext4 superblock flags */
+	struct mutex s_shutdown_lock;	/* Serializes DEFAULT shutdown requests */
 	struct mutex s_orphan_lock;	/* Protects on disk list changes */
 	struct list_head s_orphan;	/* List of orphaned inodes in on disk
 					   list */
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index e8e579498c99..3019b16320a0 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -818,16 +818,28 @@ int ext4_force_shutdown(struct super_block *sb, u32 flags)
 	if (ext4_forced_shutdown(sb))
 		return 0;
 
+	if (flags == EXT4_GOING_FLAGS_DEFAULT) {
+		if (mutex_lock_killable(&sbi->s_shutdown_lock))
+			return -EINTR;
+		if (ext4_forced_shutdown(sb)) {
+			mutex_unlock(&sbi->s_shutdown_lock);
+			return 0;
+		}
+	}
+
 	ext4_msg(sb, KERN_ALERT, "shut down requested (%d)", flags);
 	trace_ext4_shutdown(sb, flags);
 
 	switch (flags) {
 	case EXT4_GOING_FLAGS_DEFAULT:
 		ret = bdev_freeze(sb->s_bdev);
-		if (ret)
+		if (ret) {
+			mutex_unlock(&sbi->s_shutdown_lock);
 			return ret;
+		}
 		set_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
 		bdev_thaw(sb->s_bdev);
+		mutex_unlock(&sbi->s_shutdown_lock);
 		break;
 	case EXT4_GOING_FLAGS_LOGFLUSH:
 		/*
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9cae52471dee..a1d4fc5c0a68 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5547,6 +5547,7 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 
 	INIT_LIST_HEAD(&sbi->s_orphan); /* unlinked but open files */
 	mutex_init(&sbi->s_orphan_lock);
+	mutex_init(&sbi->s_shutdown_lock);
 
 	spin_lock_init(&sbi->s_bdev_wb_lock);
 
-- 
2.43.7

