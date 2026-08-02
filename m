Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692513812F4
	for <linux-ext4@vger.kernel.org>; Sun,  2 Aug 2026 06:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785653989; cv=none; b=MmBmqVSjNNbod35vOd0tzwlSmSK23F/rwtm+cBSXm8xqAh7DaCX5Avlb1Xc6UDkG89bdZV9knEMr6gMqdytCnU87DFHQnncF51uxoUGsEsSZneRdesqh5yCPQXULC39uNsYI7kfbRqK+wsolFEFvXBo8u6587uxz3SsM/WAMEXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785653989; c=relaxed/simple;
	bh=nxQBXurTXH8h8nqKnYqBo0gNwDUJEs5Sjw7UsMyg2ig=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JbxSN2pgIYf88ptYKTkPcUWH1jN/ujbvldBD8isCWk7hOouZccX8nmV+9MvwT+GapL4wiHXcGTlGpU792zocJ7X5yO6hbFg7xBXBdPfdo/69BTrv6vDOYfu03vywfxwFy/LeU2XHddgRWLHhEyePj8GpETy3djXwkozc4EBoPrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jzy+VcWO; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jzy+VcWO"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c9b373d5af0so1846447a12.2
        for <linux-ext4@vger.kernel.org>; Sat, 01 Aug 2026 23:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785653987; x=1786258787; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kwuSTX4BUVRHkplVMx2ZhWG7cEDPoxgXZ0IM1LCsc/c=;
        b=jzy+VcWO01A+nZuWMbA8CpE2qTHRR7tcVw2UwOye9xkTWWmOmwk7zpxy38iDvveFNX
         Kt7YLaz1h4j11q+Pronqx+8ovWxi3yER4mRYWDDug2C5JoCAPjX6vRpzLWplTh/vEQl0
         ErejtQRotK/VjlLYsxtFcK9Zgd8V85oIfnJCwSPH7keOEj56ShVPLvoBnHNjiBzSslrO
         KcbgARbpHyYk0pHls0yqXuti2PGCyUipPPMX6DzVK5ZYp1iAv7h3K/+GZf8ZkmPWG84X
         4cM3NbedBT/xTHh6uugzp0271lAqFgAEf8ud7aMGO77AwpkmeYmq3Bg2inBJ/T5SMIWk
         mG/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785653987; x=1786258787;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kwuSTX4BUVRHkplVMx2ZhWG7cEDPoxgXZ0IM1LCsc/c=;
        b=KzJy9/AL8qUq6/YrrIiXbX/KsjAm/RkYbLTNAO7D1Tg+UnsIXzwIJ5pg8QZ8Xy5UlL
         lNT79XHgM9XhAvH62g8/jESFHA9qkZflveIcOj5Jd/44tpyC+Ph2JUKk5kPgS3UvrW5r
         JKd26Z2NjhryHHSkygigRr7g4cZLgRQyaY7QiUOW3WnSY0dqujpooXT6l8cub/qDZmvi
         SBef65p2fYwP25/MI96UgiHlfiQiQg9zYlexyAlEsH7osMqQ2LzttZTSAOEDrHmTMATv
         hddaUN7bLnzLh01Xq9yzeEesI1rljs+naRivcnXbUMiY6ImQOUX89K3CNJkkXeRmFa/a
         w6gg==
X-Gm-Message-State: AOJu0YxGWG0RelX4Azxs2/Dx1UPzycHpl7WWAiVYMmz/LBNzSzrHthIs
	/8EozrfNwKNnu5EGZVmOA9ZMLfId8FEBkKJ0ilE3ss1u+uhPNDHb7T2yAS8FQjFN
X-Gm-Gg: AR+sD11arVU4dX951W8LVbsSW7d+F7MlcpsD3kXtf5bu1awr6HIqIVAeIRoLAixakhp
	yW2FVNWBnnwjK2aXdSHPju8EAKf80UNEZjwUCkO5kto8pZjg5TrJJrgxnqFfQ4nVeCBB6oslweO
	TsJny67L22zM496EplRgKZerdDB6acnOxVXTV1O/o0RNcPvHjpRwLqSg/3VeohZH+b5arjshBqS
	x3RpxNtd64oe5KoKFU2aZRr0Oz4M+kxZZmK+gKRGX92UfUZHOwYCYZc9Ggz/zSSc5hlMIQSRo0M
	sdEfGlYWjuMl9NLBx2VQCMAFU9lPNk9eTJujJEKF5onvufYixe3h+77nA5664+Qpn7gId3cELwd
	2F59t4Cy6u703/S7Kh4fLhnl5vR9IMP0kHGwAgceLF+35n3wvsnkFE/S2aP9Ads773eNJr0m/ci
	eAWtb/8rm9DDXU+lYCFl/Jr5sixWG2I6N2kTmXJPfWIsr4YuhXwvHZEMjZBbQy6POrmxOpQud4j
	DoMfSSXtwYTcM0gAFEHJdh4zfdRAoMQNbFNDKDKe/nYrGLQgnxlSjVyIXnsiDPyn0MdZYqSdEfE
	XEk0jmCny4jI/aQH2mfXfIb5YYBJncZLeZAqfapF2rr6j4cGxOt/
X-Received: by 2002:a05:6a21:910c:b0:3bf:5539:f93 with SMTP id adf61e73a8af0-3c92a89cbd0mr6154510637.38.1785653986498;
        Sat, 01 Aug 2026 23:59:46 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.252.203.158])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd9c96asm25453361eec.7.2026.08.01.23.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 23:59:46 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	Matthias Goergens <matthias.goergens@gmail.com>,
	syzbot+e68dbebd9617a9250e8d@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH] ext4: stop retrying saturated xattr cache entries
Date: Sun,  2 Aug 2026 14:59:41 +0800
Message-ID: <20260802065941.1726052-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext4_xattr_block_set() retries when a cache entry selected for reuse
has a saturated reference count after taking the buffer lock. The retry
returns to the mbcache lookup without making that entry ineligible, so
it can select the same unusable entry indefinitely. A task spinning
there can hold the parent directory's i_rwsem and leave concurrent
rmdir callers blocked.

Normally a reusable entry has a reference count below
EXT4_XATTR_REFCOUNT_MAX because the count and MBE_REUSABLE_B are
updated under the same buffer lock. A corrupted filesystem can violate
that invariant. The syzbot reproducer reports allocator and xattr
corruption before triggering this retry loop.

Check the untrusted on-disk count before incrementing it, avoiding
overflow, and clear MBE_REUSABLE_B when it is already saturated. The
next lookup then skips the entry that was just proven unusable. This
mirrors the normal transition at EXT4_XATTR_REFCOUNT_MAX; the release
path marks the entry reusable again on the exact 1024-to-1023
transition.

Using the same QEMU harness and guest parameters, current unpatched
Linux hung in 6 of 8 420-second trials with the do_rmdir signature;
representative NMI backtraces caught the owner spinning in
ext4_xattr_block_set(). The patched kernel completed 28 of 28 trials
without a hung-task report; the final twelve trials exercised the
reviewed overflow-safe form of the change. syzbot's patch testing also
completed without reproducing the hang.

Reported-and-tested-by: syzbot+e68dbebd9617a9250e8d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e68dbebd9617a9250e8d
Fixes: 65f8b80053a1 ("ext4: fix race when reusing xattr blocks")
Cc: stable@vger.kernel.org
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
---
 fs/ext4/xattr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 982a1f831e228..3c1bb547b2f54 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2075,12 +2075,13 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 				 * stable so we can check the additional
 				 * reference fits.
 				 */
-				ref = le32_to_cpu(BHDR(new_bh)->h_refcount) + 1;
-				if (ref > EXT4_XATTR_REFCOUNT_MAX) {
+				ref = le32_to_cpu(BHDR(new_bh)->h_refcount);
+				if (ref >= EXT4_XATTR_REFCOUNT_MAX) {
 					/*
 					 * Undo everything and check mbcache
 					 * again.
 					 */
+					clear_bit(MBE_REUSABLE_B, &ce->e_flags);
 					unlock_buffer(new_bh);
 					dquot_free_block(inode,
 							 EXT4_C2B(EXT4_SB(sb),
@@ -2091,6 +2092,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 					new_bh = NULL;
 					goto inserted;
 				}
+				ref++;
 				BHDR(new_bh)->h_refcount = cpu_to_le32(ref);
 				if (ref == EXT4_XATTR_REFCOUNT_MAX)
 					clear_bit(MBE_REUSABLE_B, &ce->e_flags);
-- 
2.55.0

