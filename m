Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105AE492180;
	Wed, 15 Jul 2026 17:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784137998; cv=none; b=gu5SeWabfxPPyVWU1IuJXRGmKlxivSmxaqtfLuYZ3hOdGgwYUDBrvoJYlpCMtqwEhXg47UUXlZi3fP2ZnU15imaQeDPSEF4rfYR33N1zAcDDJDbR8nGnmBIph+HBwdJrDgF4EcE6obn5rbmn1hY3th/WSDSnUtfb4nZzuyKQdu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784137998; c=relaxed/simple;
	bh=OqK2S+qI3S5VocD66fZpwS11Hr7/0AoKLO+iUeI7VAs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AUIM7TtlTLAg7bMVqJll4tBv2t973HzLQ2lLAVwyP2kHbMnmWRTwx1NflCKJAd/sPPP0jdg3jNxyQI3JrDgj3nDhm5yx+VvgKi5iGE82aHmX9IWJDyEPkAuJzLmSbWEc2/XYxKXdBP69XCFz6m/BFjdsx0TZ7zQxewRNwZJGyLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=LlkPfWX2; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="LlkPfWX2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Date:Subject:To:From:From:Reply-To;
	bh=hY10wnhgKongjcsHUdC9tLNWKkKMFAA5/RUacNNAMkI=; b=LlkPfWX2pAAwXx2ERtSwKFD7nR
	TaczIVtDa87ZxP+hQyy5aka+Yes0grJGudyFGv4r6lLpHfSbwA4/mQMIN4o6oksRU8OC5af7paZju
	9+QGq6yiz6X0bh1pWIYSUmHHLMj/38OzILU7YMM8viQyE3XcV04aqyHTjKU+GTaKOinoIzci9qsfS
	HsbAfeZP/DdEqL52y/KLs6FKE6JyBPhG2StOIavv5dfJi8rB/ufpiYunPY6vSVt1XRSusoaafpHpZ
	JpIA/nPlKMeH9lY+S/FbXb6bOPUIuna0e6DjyLw6wBvIXfV+Rtns4v+pXzgJ1+zd5+lRJ0yXgz3Xo
	VEVH54dw==;
Received: from [179.96.247.152] (helo=toolbx)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wk3n8-00Fa6P-6l; Wed, 15 Jul 2026 19:53:06 +0200
From: Helen Koike <koike@igalia.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com,
	koike@igalia.com
Subject: [PATCH] ext4: skip i_extra_isize expansion during inode eviction
Date: Wed, 15 Jul 2026 14:52:25 -0300
Message-ID: <20260715175253.2171303-1-koike@igalia.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

__ext4_mark_inode_dirty may be called from the eviction/free path (via
ext4_truncate → ext4_ext_truncate → mark_inode_dirty), which may call
ext4_try_to_expand_extra_isize() that could create a new EA inode,
wasting work that will be immediately discarded.

Skip the expansion when the inode is transitioning to freed.

Signed-off-by: Helen Koike <koike@igalia.com>
---

Hello,

I saw this while investigating the syzbot issue (see the stack trace of
unlink "-> #0"):
   https://syzkaller.appspot.com/bug?extid=d91a6e2efb07bd3354e9

While the reported issue is fixed by:
  7f473f971382 ("ext4: lockdep: handle i_data_sem subclassing for special inodes")
I believe the call to ext4_try_to_expand_extra_isize() in the eviction
path doesn't make sense in the first place.

I understand this is not a major optimization, so not a high priority,
but sending it anyway in case anyone finds it useful.
---
 fs/ext4/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ce99807c5f5b..cea3405cd841 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6603,7 +6603,8 @@ int __ext4_mark_inode_dirty(handle_t *handle, struct inode *inode,
 	if (err)
 		goto out;
 
-	if (EXT4_I(inode)->i_extra_isize < sbi->s_want_extra_isize)
+	if (EXT4_I(inode)->i_extra_isize < sbi->s_want_extra_isize &&
+	    !(inode_state_read_once(inode) & (I_FREEING | I_WILL_FREE)))
 		ext4_try_to_expand_extra_isize(inode, sbi->s_want_extra_isize,
 					       iloc, handle);
 
-- 
2.54.0

