Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B4E340283;
	Thu, 17 Sep 2026 03:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789615662; cv=none; b=MXEubx3CLWHML9mE9mApvwQxwHPzoRSzIcaHLwFZqoUQgbdHnxWtVe4p1FE2KrJTsWtIpSjTesJe2ZxruENKjvsuSqqNPNDpf+Y9/YGCfr8qVU8SnvVd8B/B57cJJKoOE2922Bsf5Mtam+AaZH8OsmGnBry866gWlsZ1VBr3QdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789615662; c=relaxed/simple;
	bh=UuBRXEqax1SJUMasTPnd6T/Qvzbh0ZWMWtu6X9426Zc=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=b8AgdqLYddaTohlanHIAepOf3Y0AZ+TeSOEtbgY8prAyp11Ir6kmg7GCtdQM/P3TKQbZtHaVGa0ve4sBznJuOF+orPwU/A35OvfmEvMNzbu/NldNnHIE3FHLrTK4/RPphBrZpaOaO8/iXMwoNmwRNSgvpYCXL8C7lXPcKyAjpTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=UBh+8dcW; arc=none smtp.client-ip=162.62.57.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="UBh+8dcW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1789615642; bh=ve52XV7wR2TEEGr2PSB+gYgxAZGU+WMmBu988YnETI0=;
	h=From:To:Cc:Subject:Date;
	b=UBh+8dcWERKAR8RPgtup0+SuKkl3muMr5dGUB64IipsdZznFSKdLmKxGrrI0UOHET
	 eV9EnvqEFmUlsIH0nogy1MWG56B41tTKXv9LSYOswyKs3VoNGztP/KJ1/jqfNPrQYJ
	 QTRwSXuFIpWKNS/8MzNer6t7Fsz0bZNNfc9NBfn4=
Received: from fs.localdomain ([221.176.157.243])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 6CC9F455; Thu, 17 Sep 2026 11:27:12 +0800
X-QQ-mid: xmsmtpt1789615632t2p37w5fw
Message-ID: <tencent_1289C5B99FB98002A71088AC49394474B20A@qq.com>
X-QQ-XMAILINFO: MhK4DKsBP06iolasGyoHZz9R6ViOe6/IrzslGynVJj4PtYBjiFsH3yIw3qv5cY
	 +E9RNcG7zTClRLxzOsMswViuWAhES/DCojxVRIYcyBZKzvUiHiqz9WMLt80UjMlDnZrzd3oRulQn
	 6/Ei6NSXy1lzWpph4mn/EpDJT8kXLiaCbLOSVHDqJBFUAxFIGTMYGLDKTwyDJeYFnEBU4RBfn2JJ
	 T2Pw5GLSuQssgoA/5NTtxtI2pEGCmC4q0O1zwZLflf0W40UQXbiqfQvkws44e+wvXq+tre+LtXCj
	 HOehRuSuk9PEhIaGftOnkmywA26O5n8BJm7Wq8DGlN9Ns8Ud1u+q8FBMK1v5A4z4kgHDEh5kZoTv
	 IAomd+cyFLMzjDEtc9ZVc8MHXTUeiZvZRh03pgqJf5JL1nQJLvvBmqwJdeslGjQXzW7B6azEw9Rz
	 Kw2raCSyALqXGzx9A43C6YQmESgmhXPRz3J5H65KMfAnoEesMH2dc7htDnb7/sH9ruMQynx95R7v
	 N7tmorSAX4yHc1b5nCY6ak3UM3+bbB2tuwxI6PQvhgguI2zvzkzjqCgkfC/TJPgkUkq6OywnYw+S
	 s3+qvYy/XhzbLPJTVJqXZNHlBom4BDJOy9J9C7qlUlvSS1NYT8YAp1dQig8GH3Qwys9rBxPwSSPQ
	 nPSHZNon8E/2DVk7egTgqR7vUp8NUESxYatv8J0e/I6Z2a9C+xWUftyGEmyHGTB9IJ69Tfk2bZ0D
	 MbGaaPhi059LvU81sW2uwKtE8XnQQUGfVf/rtN7xHHUDi34a0SuQ0ajYXxdo3lvLpeG2R0V2HH/M
	 zXVJOjax7gT1JhlCc64wB4nHLPooxwSQs7/ZatycYduGV5MyH5uviDzP5g8/N2pt+SW4dD5/PKED
	 LgjWgBzeW9ra5f7CNCY/RczdHUrvRs+zox0lwU+p4QsjJ29XWM04sKQS3wUF6AWYREPhhUZqMK+P
	 8IVPAkEKY/zxNuOL7VFUoCuOJN4pCccahjsdo62UmmISB+JfwI+3UoarGyxl4b4vM4toUrHlU=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
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
Date: Thu, 17 Sep 2026 11:27:12 +0800
X-OQ-MSGID: <20260917032712.3696917-1-781735889@qq.com>
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

