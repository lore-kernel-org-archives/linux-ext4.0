Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561423655D4
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 09:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782208774; cv=none; b=dELlxf0P3CvzFIqFd4b2DNGLnZiJuXMvmbSw5UtVAQdLuCxjiSwPxO88D9ym4McMXqmMtekG559Yjs8ZD14GKBjAQHLcFOj3quqDK0opipGYblANrsfPKu51rRB7un+tX1Z+KFfqNxTYLKx+044PmfBUbjWpZZrykJfXfxRIGYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782208774; c=relaxed/simple;
	bh=ad9aIFbJdgL/UzzfV6fm4Lv+5IKLPp9bn0onxiSVWPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DaJhLTfCnd8Yl2X9Z0qRTW5hI98GsgcQZFDpddoPNFc8qr0AampM4tsvpvuASDpY63YmQAs78XV4UKOJ5TUGEwiQ73aPl11WjX+Awwv6a2WdbRrP5q3pGH1Fqm1RlmjpJgom+OxVQuVgtsukpd1raCvY3K/9HcNKuLMZIGxeIpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I3dVP6HW; arc=none smtp.client-ip=74.125.82.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I3dVP6HW"
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-30c03b09e02so9882124eec.1
        for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 02:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782208771; x=1782813571; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m8A+H93fHwrfEYMrct/wizOSxd5tVbtevsUUu6gMQPc=;
        b=I3dVP6HWHjEN6wjFaY+9EY8oycrerjJBsCyNJz6G+mEExHBfWNP7Pmg42SHjszz2ok
         WFHf4GFHzGSHz0gFVRARHMiu6g4t8X2PnZQ5XhfWH2zWyKvrix+Q0h40mocABHM5IBM7
         Rs2NExT8QThmYDHyZta3sI2Yzwh95lMW5UUOqplTVj40LQBOWHoGkS035g8sBX7qQ8rq
         /T8Hj3/EzZF+ea00uY7zSbGvvpRRcED3180dcKZwMH+aAHXlMGFxkz9F2UskUPBGYNF0
         aCtHRQEym1hmbJ6GCckuyjmWz0v8hb93Lw+1pOwFKXyvtsm2CkSxCMKLkJvGTnunLqt3
         l7rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782208771; x=1782813571;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m8A+H93fHwrfEYMrct/wizOSxd5tVbtevsUUu6gMQPc=;
        b=X9DJp6SKb9l19UR0CEWAaiUSOuAxMhOqiyTW0RJ4tRDshGDSTZCvOdeL1NjORXXPKm
         Ym+j9kEYGUVA3WcISHn+mOzzKjY+rcxjirH2yNLWYR27Nd+4v+rylISsufB7BPiwy7W4
         ZdZbpgDwFrL3Mml6fyFYb34EdANUXCZ8UtpkBLM1/nPjxHwXXafk/7qDtXk59KuY+qe6
         20E60JAW5j/GTrRWb0AbW/NB0xoa/Zj70il1FQdYKBV6K8Mi8rH/L5p1WPMnpq+2WXG5
         X86zqDzLMpM+VdIIAFjHEsZ+COMU/1GlO2bGIsonJDs2wI/JGSGEg26T3i8hLmvJVZAb
         Vpww==
X-Forwarded-Encrypted: i=1; AHgh+RqRVCWPoCUKHzC4pTvtJAx8ESztfyRYWd4P8M6a5TeuclEI9BOx7HLDb7I5xJOvgJiE+XcrNIfwhGyi@vger.kernel.org
X-Gm-Message-State: AOJu0YwefwzSnH/sjJhM5ZBfF62rIhscQi6wbczLFKVl9Xg1Y98s9TI9
	vjOK/p5ma3Fb6kDKdR4ynam15vcouI4GyHeRcu6OKvsZLF12KzV8Awlk
X-Gm-Gg: AfdE7clR9OjZgGVSaU/6Ywd86mguO/X2pYM60MBOZBngYkzNWDW41IuDmDG30jdw9GK
	unV6z5APgqLIhREYMc7/zcjF6SayvHiICC6bG7Lnxgr1Qdx6qMlS2+NiMfVyzhV5GclkjB9bDI9
	ZbZK3xa+NsD4CfougaHcmRiuc1Ewv69TCyFyQxo/IPcWDJOq98H9+rnYoAD3K1mCZRj9193RAIr
	wHd24o1iyoextwPa2djXXXbT11sWdJrrQESh8d/wcGRMB3apzn4WMfM+6i0VH7SsRzgmytL9G5K
	s+ubdAfMJgNOkYdPwmY0omJuhl3/SbuwsSKkhN4k7c3y8PvVqlbNPBuFjsnABy1U+CujcyVNcyd
	W+/jMLQUSTOKNjMGpqb4rDDHT369AFGybmfJMJosK4ElMLozsmzfmQ0Vd4GKVGFZshP8jaPiDBT
	TJIi7WBqz3AwcAcPG5rCbc8Aw+coHUJ6IzfdTJpm8lKBqQj664+xdfuvhiZInVvvs5mjxE38e1b
	h8zkGxUKoTg2YE1CeyOjR9rdn7SHu3GB45j228Oj6kOpUKRJU2sxCr0mV45u8fbMCE6xrHIThoJ
	TnIHgEZFgGe1GTqdlBC5DmybnYN3F0nm0slv
X-Received: by 2002:a05:7301:5f09:b0:304:e72a:d4d9 with SMTP id 5a478bee46e88-30c58b66e50mr2001603eec.19.1782208771435;
        Tue, 23 Jun 2026 02:59:31 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-a.c.d33bddc1d573818c7-tp.internal (69.129.240.35.bc.googleusercontent.com. [35.240.129.69])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c1bd8d6edsm15415857eec.14.2026.06.23.02.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 02:59:30 -0700 (PDT)
From: Aditya Srivastava <aditya.ansh182@gmail.com>
To: tytso@mit.edu
Cc: jack@suse.cz,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>,
	Colin Ian King <colin.i.king@gmail.com>
Subject: [PATCH v2] ext4: fix ABBA deadlock in ext4_xattr_inode_cache_find()
Date: Tue, 23 Jun 2026 09:59:11 +0000
Message-ID: <20260623095911.2372-1-aditya.ansh182@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>

Syzbot/stress-ng reported an ABBA deadlock in ext4 when exercising
concurrent xattr workloads (using the ea_inode mount/format option).

The deadlock occurs between the running transaction and the eviction
thread:
- Task 1 (stress-ng): Holds a reference to a shared mbcache_entry (ce)
  and calls ext4_xattr_inode_cache_find() -> ext4_iget() to retrieve
  the corresponding EA inode. Since the EA inode is currently being
  evicted, ext4_iget() blocks in __wait_on_freeing_inode() waiting for
  eviction to complete.
- Task 2 (eviction thread): Currently evicting the same EA inode in
  ext4_evict_ea_inode(). It calls mb_cache_entry_wait_unused(oe) which
  blocks waiting for Task 1 to release the reference to the mbcache_entry.

To break this deadlock, perform a non-blocking lookup of the EA inode
using VFS's find_inode_nowait() API. If the EA inode is currently being
evicted (marked with I_FREEING or I_WILL_FREE), simply skip it (treat
as a cache miss) rather than waiting for eviction to complete. If the
returned inode is found to be I_NEW, wait for its initialization to
clear using wait_on_new_inode().

This deadlock was made much easier to hit after commit 0a46ef234756
("ext4: do not create EA inode under buffer lock") which removed
synchronization on the buffer lock.

Reported-by: Colin Ian King <colin.i.king@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219283
Fixes: 0a46ef234756 ("ext4: do not create EA inode under buffer lock")
Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
---
Changes in v2:
  - Read inode state locklessly using inode_state_read_once() to resolve
    a lockdep assertion on cache hit.
  - Manually restore essential inode/ea_inode validations on the retrieved
    inode (is_bad_inode, EXT4_EA_INODE_FL, file_acl, and xattr checks) to
    match VFS safety guarantees and prevent using corrupted/failed inodes.

 fs/ext4/xattr.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 982a1f831e22..ef13e7a76153 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1523,6 +1523,20 @@ static struct inode *ext4_xattr_inode_create(handle_t *handle,
 	return ea_inode;
 }
 
+static int ext4_xattr_inode_match(struct inode *inode, u64 ino, void *data)
+{
+	if (inode->i_ino != ino)
+		return 0;
+	spin_lock(&inode->i_lock);
+	if (inode_state_read(inode) & (I_FREEING | I_WILL_FREE)) {
+		spin_unlock(&inode->i_lock);
+		return 0;
+	}
+	__iget(inode);
+	spin_unlock(&inode->i_lock);
+	return 1;
+}
+
 static struct inode *
 ext4_xattr_inode_cache_find(struct inode *inode, const void *value,
 			    size_t value_len, u32 hash)
@@ -1549,10 +1563,19 @@ ext4_xattr_inode_cache_find(struct inode *inode, const void *value,
 	}
 
 	while (ce) {
-		ea_inode = ext4_iget(inode->i_sb, ce->e_value,
-				     EXT4_IGET_EA_INODE);
-		if (IS_ERR(ea_inode))
+		ea_inode = find_inode_nowait(inode->i_sb, ce->e_value,
+					     ext4_xattr_inode_match, NULL);
+		if (!ea_inode)
 			goto next_entry;
+		if (inode_state_read_once(ea_inode) & I_NEW)
+			wait_on_new_inode(ea_inode);
+		if (is_bad_inode(ea_inode) ||
+		    !(EXT4_I(ea_inode)->i_flags & EXT4_EA_INODE_FL) ||
+		    ext4_test_inode_state(ea_inode, EXT4_STATE_XATTR) ||
+		    EXT4_I(ea_inode)->i_file_acl) {
+			iput(ea_inode);
+			goto next_entry;
+		}
 		ext4_xattr_inode_set_class(ea_inode);
 		if (i_size_read(ea_inode) == value_len &&
 		    !ext4_xattr_inode_read(ea_inode, ea_data, value_len) &&
-- 
2.47.3

