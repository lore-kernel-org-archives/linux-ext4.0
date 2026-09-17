Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E75340283;
	Thu, 17 Sep 2026 03:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789615724; cv=none; b=YvHZw7hoDrR7dn/4JVEGqBx46HWS+mSSbWEKfkACEOd21oAesgsqv1fBxoge6EoCMn6desSlTtvi5NgU2APsxE2H1JlQHHSSwz2GZXxxT38S6iQu4vgn8lL3ydxMZY36vl67SaXWwBro7948cuCgwJ1D570+paVICIL9EW+YupI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789615724; c=relaxed/simple;
	bh=UuBRXEqax1SJUMasTPnd6T/Qvzbh0ZWMWtu6X9426Zc=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=hKevEM3umtWndHCk9P/MhzQlhLBmv0Yq075DsRx3Zc55TEK1mBDdudAJ+pVHz4KD2dD+dT4Q6VIpNfXGIIY16a9lTEDBCPe2D8tKBIwDCHIpEnDB66pvQZsCBhKCmqwbmwK44E0BCWe4IwI92deFPVKy35lCWECAMQSwEQob2t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=vwn9TZFT; arc=none smtp.client-ip=162.62.57.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="vwn9TZFT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1789615716; bh=ve52XV7wR2TEEGr2PSB+gYgxAZGU+WMmBu988YnETI0=;
	h=From:To:Cc:Subject:Date;
	b=vwn9TZFT2i92DLEz5i6KQUBntSXHDZKMm4Z8RK2ypHa/g5MM6gnqVoCLbiMdzCFYi
	 uoqqdzZrYY5o6t8qPV11KuIdJCBaolG5JIQi65xF1O+sUrtGV9gx/4bcsX0Ab1IGLM
	 Enw/792G2QKuTqJ/9zs9T1B1kcmld9LW98zUsJKg=
Received: from fs.localdomain ([221.176.157.243])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 7220D6DD; Thu, 17 Sep 2026 11:28:34 +0800
X-QQ-mid: xmsmtpt1789615714t2icpqqcf
Message-ID: <tencent_46A95D4281B70962D6EC1D523A85C448DC09@qq.com>
X-QQ-XMAILINFO: NuGpsYW8pZ+AxfyA7FNUfM02fhkbkwi3Ack6C/yOJFEjKwabF5BopFFtClfr8K
	 S09rrF4gZxRWyEdREwdf52KYPHSQh0JiGwOydMJPTIVVgQwYtBPlAbcQuY6k7asdUrXIlEEzlVeP
	 evvLyk9zdjjejiBZKI4mm8UL12LzC0PyZsY6keYYTqOphOt0OqhBpsmjsbfNMYtW+h6I475y/iEy
	 sWqHP9CRbl3S8bBZp/eMjZyTHGOwBQ44gDLSqFwrsyW1yRzT7cxrxGoDU8kJapYRNsWvQ8QTOKbw
	 zirk7cgJMsvK5CgMiQYzpu9anN0EM/0RM1DN3lq7/PwcqAbeDWrqBS4PhKjBxHHBTafM5cNsqkkP
	 Af/tcs/V5qUOme6uOqKV/hnOi+Mwu3CeQH/xhLcLCsTQ6i9oDvyq77XOZw4FaHQakhykmcy0cojg
	 Opkgoe+Zl0VM1CB6I/FAXP157hVRdnINE24v9bXh/BqeUmTaDd0U+5DCl/yJ9dda8kCTVomkHu6S
	 JapUPRfJaCAORv6zHZgj57flubKllb2Vey/q6/i76QoG9bSs/Iqov2vUYt936bwEVtE++LaFGsvw
	 RP0stZfrm0MD8oKHw1th1ggFCUPb+oCTjve8RLqIHCBUkRIK3o8uQ0IfzE+tgm7v73moah/Un/dH
	 lSuz0HDWZboL2vrBxBVs0WipxyUr7jNS67JXWy4i62++iVzMhxACQu/emwZB9WRdkQp50m/sCziU
	 Qs7CsA98qhaZdVfxn98Kt5uFVaQPEiday7sUh8Fe5zCuagFq1FIGYZMe2R0izsalGd5wZS2+uQIP
	 StsZhyaoIlvuXbi/8mBRrUsk1R+AVnwOiK1rTolC1s0y2g85rjrGI5RhIwInBauSHp/Qg8174AGS
	 /nha7zYa4nCIKnoGqGalahy1PVoUG5tM+BbTl/Mbq1urcmsjDefE7tNynkCBMqRd1L5XFxOG72xB
	 b6ws5ndME8eiGw/n73Vb3ibx4BXJg9i2Hn4QT7YHjTnhSLh202V+BGX/WzZcLyW/WW3X0WGstOfu
	 AXmsoQFA/LViSxKNzOLn1ZeP56uAk/gKIiHf1tLTbKhhtUkrajJ2rkTVhubm5TjYxw3BipnA==
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
From: 781735889@qq.com
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	harshadshirwadkar@gmail.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] ext4: propagate errors from fast commit create replay
Date: Thu, 17 Sep 2026 11:28:33 +0800
X-OQ-MSGID: <20260917032833.3698053-1-781735889@qq.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: lty <781735889@qq.com>

During fast-commit replay, ext4_fc_replay_create() can fail while
looking up the parent directory, initializing a new directory, or
dirtying the replayed inode.  The parent lookup error jumps to the
cleanup path while ret is still zero.  Errors from ext4_init_new_dir()
are explicitly converted to zero, and the return value from
ext4_mark_inode_dirty() is ignored.

Consequently, replay can report success and mount the filesystem even
though the directory creation was not completely replayed.  A failed
parent lookup, for example, leaves an unconnected directory inode.

Propagate these errors so journal recovery aborts rather than completing
with inconsistent metadata.

Tested with QEMU fast-commit directory replay and injected failures in
the parent lookup, directory initialization, and inode dirtying paths.
Before the change, recovery completed and e2fsck reported an unconnected
directory inode or inconsistent inode metadata.  With the change, JBD2
reports recovery failure and the mount fails in all three cases.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Cc: stable@vger.kernel.org
Signed-off-by: lty <781735889@qq.com>
---
 fs/ext4/fast_commit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index b3c22636251d..e656abd938fb 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1656,12 +1656,12 @@ static int ext4_fc_replay_create(struct super_block *sb,
 		dir = ext4_iget(sb, darg.parent_ino, EXT4_IGET_NORMAL);
 		if (IS_ERR(dir)) {
 			ext4_debug("Dir %d not found.", darg.ino);
+			ret = PTR_ERR(dir);
 			goto out;
 		}
 		ret = ext4_init_new_dir(NULL, dir, inode);
 		iput(dir);
 		if (ret) {
-			ret = 0;
 			goto out;
 		}
 	}
@@ -1669,7 +1669,7 @@ static int ext4_fc_replay_create(struct super_block *sb,
 	if (ret)
 		goto out;
 	set_nlink(inode, 1);
-	ext4_mark_inode_dirty(NULL, inode);
+	ret = ext4_mark_inode_dirty(NULL, inode);
 out:
 	iput(inode);
 	return ret;
-- 
2.34.1

