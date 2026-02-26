Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F262C3D649B
	for <linux-ext4@vger.kernel.org>; Thu, 26 Feb 2026 14:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772116392; cv=none; b=iDrsysQF8st6FiKgMwvGr+AQ4QlPBzNUuDD/Wvis3wCCiE3IJpEdP9f5PGvPog/f6oNVHOdHhXhxtjd/jPd1Vng47lvAdmwApJddnfnDTny9U9vFjfV96OGEGbojU3l54WUM96CCh+d2eNlG4ZdVBAELcHSxxNxlGzojLIWEHpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772116392; c=relaxed/simple;
	bh=AFa4gQHlzMo9gb/8lkyfEZ2nW6wsvEKiuglk6riJ6WA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7iTvkY3wuSbgyKQ3yGgXoRrFoUskJi5ZFUMF48jsBfh/tvB2RuTNXN44nuINibXo1IqzR1Ax0FvBggIuiVbqanm6Dmzys13DsSDw4gutuBjAlSqzYQnbj9kI8ggBC5V5KqNVtb2sNjBjvRwm4g4VolRi6h2SW42TdEcFtz0I0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jiHScR/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jiHScR/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3D5C116C6
	for <linux-ext4@vger.kernel.org>; Thu, 26 Feb 2026 14:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772116391;
	bh=AFa4gQHlzMo9gb/8lkyfEZ2nW6wsvEKiuglk6riJ6WA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=jiHScR/ubcBUQzfrwN4wDQJ7ORGEp+qhpeR9fFPAC7KSgYEX9cDeg1CHNkiAzENRH
	 jcd7cdt25SEpKLBh/pslGC+St7dIG/oxbRbVDH97GieOnntelW1EePllH6ChpFg+Ed
	 1ogOW+s/dNDS/wd5r3L6k5Q38iFX/wDsyxdwMuhEO6Tp37AFeHiODgrICWTvjz5qxi
	 WlVRULE2zd2vyN11coUjr8mJO9ijEeEpoqRpBBe+bcGS74NdvsP81PyBU9wtRGggTX
	 BiG0sjYNxwnEiiu+l/cLgI6lc1l1MRtaSBOuq2jpx4e1qZS2An3q6dcNNk6u8+7trl
	 2zc2LEsiTqpCw==
From: Anand Jain <asj@kernel.org>
To: linux-ext4@vger.kernel.org
Subject: [RFC PATCH 3/3] ext4: derive f_fsid from block device to avoid collisions
Date: Thu, 26 Feb 2026 22:28:07 +0800
Message-ID: <e269a49eed2de23eb9f9bd7f506f0fe47696a023.1772095546.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1772095546.git.asj@kernel.org>
References: <cover.1772095546.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

statfs() currently reports f_fsid derived from the on-disk UUID.
Cloned block devices share the same UUID, so distinct ext4 instances
can return identical f_fsid values. This leads to collisions in
fanotify.

Encode sb->s_dev into f_fsid instead of using the superblock UUID.
This provides a per-device identifier and avoids conflicts when
filesystem is cloned, matching the behavior with xfs.

Marking as RFC: it is unclear whether any usecase requires the f_fsid of
a cloned filesystem to be consistent with that of the source filesystem.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 43f680c750ae..ec3c5882dff3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6941,7 +6941,7 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_files = le32_to_cpu(es->s_inodes_count);
 	buf->f_ffree = percpu_counter_sum_positive(&sbi->s_freeinodes_counter);
 	buf->f_namelen = EXT4_NAME_LEN;
-	buf->f_fsid = uuid_to_fsid(es->s_uuid);
+	buf->f_fsid = u64_to_fsid(huge_encode_dev(sb->s_dev));
 
 #ifdef CONFIG_QUOTA
 	if (ext4_test_inode_flag(dentry->d_inode, EXT4_INODE_PROJINHERIT) &&
-- 
2.43.0

