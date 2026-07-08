Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39222DAFBD;
	Wed,  8 Jul 2026 08:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783498353; cv=none; b=BazYXBCY01qM6PTZnvFV+d3Znc5DCdLLk28ffxK5o4m8rcgY6aY/5iNpApFuNcufdzlPQk26PTTd/eB7M252Aw/zYZPJ4zwml2Af9RxKMdIolHUxxlmDnlEgfl+xfA6G/axtb3c+5R7/ONH7HuYc/T0eMIggv+Kb0KNrAVH2Or4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783498353; c=relaxed/simple;
	bh=ymhXvroLX3CH4eR2SGkSdoQGnSfT5q1/U6mh3CKl768=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=nbHTTMwKfeErTqmUDa/YkjrPQkgm8Z67+5H/wyk/o62TgtyWvff8EYGqS4IQwCgGNRmLQeM2HdbSwsNdb5+m/mw1p6hL3tnAsg6iS/wJuhHRpkSRlJdZotNQ6/vy73rFzTpJyX8yf9UGQOLxUrVHe3PC7mYYDsEpmeFaihpH/+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=FLZbJMrT; arc=none smtp.client-ip=43.163.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="FLZbJMrT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1783498340; bh=SnX/BxqxHOFgdRa7DP80F2nItStdQQssUzZaSW66+Yg=;
	h=From:To:Cc:Subject:Date;
	b=FLZbJMrT6siq6hYkGYFz+wElonRlV1a6OgCWuWQ7CPS3th82ys2pBSVv4OSD+XNc7
	 7IlvvfG5OPNOyI98UtJBgQQBdpv9WXuc2hzN7QwZzbl1GkDVr1taxGDjSURuFlLkcs
	 vF8Au8hvJQKJkar4EGR4DIPzdyHa7ExhWJG7fVuY=
Received: from ubuntu.. ([218.196.207.7])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 3079D4A5; Wed, 08 Jul 2026 16:12:07 +0800
X-QQ-mid: xmsmtpt1783498327ta8cpmedd
Message-ID: <tencent_E3622146846A84C75C31C7D32AC4D5AD0605@qq.com>
X-QQ-XMAILINFO: MllZffuBkEb55+1pNaYaxXA4sA6k+xzHEMn2Zw9BM7Wy+uZla4RJct4it5QFmY
	 dFmHDdE3hGRCF/KI5OXHOTMZIjn6Haz33tVvMw5/ryNzZvvejZbLq2Du6c3tGT3gwerQc6tEhHsE
	 uqoekNzBQSdxmpf0qtgTd/7GvPI8kPS0HJxLyazbEqap5jyaLtww1cF1ooT0gpY8grF/318ZQO/J
	 F0yaVfwrp4E6I73y+Q+JnI+iuINaNADBsj0eCBJNqJvP+94UCXWvGjLpniGoGD3kLAxS3BSgZFsk
	 R3E8qNRjRnNXtVFZCrXhAtBRc67YunIvlUfyeHYr8v8Y79XRw6g8mv5PhiEVIUGsBNwvKlYmzwnz
	 C4I9Ly0jdq4By/DQgT4f9IgzqMnTebOC+QRQCQdEm9LHbuwWBWpCL1rHHQ4Dj/ux692cFH/fTNaV
	 3a5TGVGMzxtxy5c6JZJY6Z1ZzONHCjXwDM9iInXOqDCoKZNlkEIvzQFYR7VdTNTrVHJBQg9KeYTA
	 4TzM1jdFD7sw2OFkCL9z08i0TLUBekwVeXaxmdGiuh8TeBiK+5/ak0kJWQnPJKqYogBse8iaIBa5
	 AD9mOKol+MaeJoZfziPaqABommoj1NWjOLqi9RBJ7Eg4dYLBEHbO6enSVZkw4KOdNCnfY/P490nN
	 Fz8KnYe8HY02DMUjJ7l4qi727ebDC3i28qN3vDxpDqG0lMTslHqdNax4G5DpCxGRrEDK5PHxvhFM
	 AeLqNimNkAYYAnCiFYamp6izbI5MYejKH2mSWPF6aMYC/VEIzEtuAAC3RdubB60/40lqUz6+KlRt
	 FKe2bPpGwZBcYmt8xe5+bZwbidkZjgSyfdgeUEq28YWniQZWAcYQmpYYoOKJ2wMxD8+0HgptpE6d
	 4v60ElxGIqTQQeyj9fbuxRzZii6YOr56ye/qdP3otMKdIjEmFHNK4qhSrrmyJLjU+qJgQoMk8NUE
	 xMGEpZrgZ9wMW1fNXDKenCdv3nrg1UgwAQprr4QXYJhO86N/waiFzykld7zobkC0DqUjuRp+j40R
	 Yn8tMlBuLvaDvQjr6Dbwi41NEzbGYYFcL5U794EEPGndWmj3dB
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
From: Guanghui Yang <3497809730@qq.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Guanghui Yang <3497809730@qq.com>
Subject: [PATCH] ext4: propagate errors from fast commit range replay
Date: Wed,  8 Jul 2026 08:12:04 +0000
X-OQ-MSGID: <20260708081204.924947-1-3497809730@qq.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext4_fc_replay() stops replaying fast commit tags only when a tag
handler returns a negative error. However, ext4_fc_replay_add_range()
and ext4_fc_replay_del_range() currently return 0 from their common
exit paths even after internal failures.

This hides errors from ext4_fc_record_modified_inode(),
ext4_map_blocks(), ext4_find_extent(), ext4_ext_insert_extent(),
ext4_ext_replay_update_ex(), and ext4_ext_remove_space(). As a result,
a failed ADD_RANGE or DEL_RANGE replay can be treated as successful and
the replay code may continue with subsequent fast commit tags.

This is particularly problematic for DEL_RANGE because it may already
have marked blocks as free before ext4_ext_remove_space() fails. If the
error is swallowed, replay may continue from a partially applied range
operation.

Return the saved error from the common exit paths and make the
ERR_PTR() cases in ADD_RANGE store PTR_ERR() before jumping to out.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Cc: stable@vger.kernel.org
Signed-off-by: Guanghui Yang <3497809730@qq.com>
---
 fs/ext4/fast_commit.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 8e2259799614..fbb486d917b0 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -2196,8 +2196,11 @@ static int ext4_fc_replay_add_range(struct super_block *sb, u8 *val)
 		if (ret == 0) {
 			/* Range is not mapped */
 			path = ext4_find_extent(inode, cur, path, 0);
-			if (IS_ERR(path))
+			if (IS_ERR(path)) {
+				ret = PTR_ERR(path);
+				path = NULL;
 				goto out;
+			}
 			memset(&newex, 0, sizeof(newex));
 			newex.ee_block = cpu_to_le32(cur);
 			ext4_ext_store_pblock(
@@ -2209,8 +2212,11 @@ static int ext4_fc_replay_add_range(struct super_block *sb, u8 *val)
 			path = ext4_ext_insert_extent(NULL, inode,
 						      path, &newex, 0);
 			up_write((&EXT4_I(inode)->i_data_sem));
-			if (IS_ERR(path))
+			if (IS_ERR(path)) {
+				ret = PTR_ERR(path);
+				path = NULL;
 				goto out;
+			}
 			goto next;
 		}
 
@@ -2257,10 +2263,11 @@ static int ext4_fc_replay_add_range(struct super_block *sb, u8 *val)
 	}
 	ext4_ext_replay_shrink_inode(inode, i_size_read(inode) >>
 					sb->s_blocksize_bits);
+	ret = 0;
 out:
 	ext4_free_ext_path(path);
 	iput(inode);
-	return 0;
+	return ret;
 }
 
 /* Replay DEL_RANGE tag */
@@ -2320,9 +2327,10 @@ ext4_fc_replay_del_range(struct super_block *sb, u8 *val)
 	ext4_ext_replay_shrink_inode(inode,
 		i_size_read(inode) >> sb->s_blocksize_bits);
 	ext4_mark_inode_dirty(NULL, inode);
+	ret = 0;
 out:
 	iput(inode);
-	return 0;
+	return ret;
 }
 
 static void ext4_fc_set_bitmaps_and_counters(struct super_block *sb)

base-commit: 0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53
-- 
2.34.1

