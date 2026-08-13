Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69ABF280035
	for <linux-ext4@vger.kernel.org>; Thu, 13 Aug 2026 08:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786610053; cv=none; b=lk11cdke7WGTGYVt4cuuHbOxsQM2AbnlnREZxerKKyigo3qFi6r9A20yOopFYZ75hhuSuQiHdmM4HtoQbkzdiJOlpZVfkx8nXanlDpTFniDm/AEoJdrfKJ3eAEbEtz7Rk+Qr0nHMKdvC0Vax4ftSvBwC/aCH04Ll3Ftmc8uTflI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786610053; c=relaxed/simple;
	bh=9kbGz/7zoJzC//Vsih1zMjO9YenPuZMLly7DROmHW3A=;
	h=Message-ID:Date:From:To:Cc:Subject:MIME-Version:Content-Type:
	 Content-Disposition; b=gvauRcDuKHfjIqgk89cKiYxv+Q8hMqcQnm0h8aT4OzgLxHpqOtoLuSnNpMU8/meB6/TwkpWgVRx28sasb/N9JNDV6uGvtOFt78x9+oRtWMxaAdY4R/6gFGfrnRe1EYTlIGQdl5Ozl6E52M27Nh1l7eaDEQdmiTCl4wGVPt2Jboc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=tHCVba5u; arc=none smtp.client-ip=162.62.57.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="tHCVba5u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1786610040; bh=HPAgm9YPiNBMc5oES/gJ0XIs4tUMtA9jnagVhTSdF6c=;
	h=Date:From:To:Cc:Subject;
	b=tHCVba5ujzi9tDTuvkJcS9giM0THoWCcTfC66NUUgf9phZcQtGgq/cRFS4SqcGPAf
	 n+7r6JAQB0d9u5iMbGLG3LmPr5IZVCSK5Zz5fMcuqGxVQXoPPk3qbVPzKwaZ6saccW
	 n4jOX3163QNQxl9Gnz6Y/cHqP6Mtw5Sd/Ooj2MM4=
Received: from DESKTOP-AT5F202.localdomain ([183.242.244.64])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 8760BC0D; Thu, 13 Aug 2026 16:33:54 +0800
X-QQ-mid: xmsmtpt1786610034txuk11xau
Message-ID: <tencent_321031C6B9D5D092C8978B46D9F0BBA18607@qq.com>
X-QQ-XMAILINFO: N2zgDHximsrqyPLXHS0YRddfdSijmp3/iz+UndN+Tv8R02X7q97DsFqqH68NXG
	 AePgcA8OqwJh2Z3AvG1L4lNPwXDf+SNvRjXXZowlIE7XDWxuDHUzASyK0WY0+YC1l4i6ji2koHVq
	 pUzqbj3Zp1TNSJPujK8kW+EnaBKdRqrj2VnuXPMUNvgKY8SfUkJ8KtxkAHlqQpW7HaeMWYjMV2pF
	 b1HM1qddeHeVgCyFA5a6rHHR529mrOmDqflCdZ1gUTfW+L3KicUiU3KccshkunHGz3cy3uwUQORJ
	 SQOfvUd4Tg/oWFTswipQK5nr4rWvZrN/zVkvC7rnKhYO66rvbdRgmcz6ccPdEpm9NBpN8oD3b1LK
	 Q0SaFjfwaMa/HJhgGFL0+yZVkgHuOcDXepa4QFfcugXcCmfXwgBya4bVeNL6NC3wOnf96ox/Ob46
	 fpRUzTDCM67trHv5QSs//bABntpW4LW2edOUn1pVx6+tLViNR16W/7lu+U+klWBSugrZ7o2IJOh0
	 sFhr+BLfTJsh2/J3xw+03PytpuDQSjV5R05W6NFPz251WVO/LkyuZxRpYCq/rEUTsxA1elQURUN2
	 8cB1W2tyRDjq81Kg8Mma6WfrzNu4QSbwoGi0j103PB/jc6pIGo3tPDWi6yiBHzIkUl/Xrku1ZC8p
	 oucUlO24Mtc2cgcgHnFCYx06ldiWSYkJhNPD2KcDv/yoHCPDoaurfx91ILzSiGipGofDqP0sZcnf
	 /YBBSRa029NTJUVK2AzjR3zfR/+V13vqMlMLSzj0zI1I1PTurGNHYSVcQBsbXVxrUWJ3o8JXfOXX
	 67QrijJcNimSO5aiBx68t8OV9ClJOsuSoris8scQcvDJJoiRXe53M6d0y4z1yOYDYWITcoeZguo6
	 5dAPJi74ImXuNmmYG2guKY0QTDpvd9iJ+UC05h59kkG8HTH9dH6sSLnsysHfIYfhy0BxBb40y02Z
	 QBMmhG6re6LrwaN0ba7A/JKAoxScccX37+v24RxoUmENqKsdRPHNry7YFzIMzxKjsUkUlIMa1OaR
	 rXa88Z+TmUh6TgWc5Gk3LEb8yrXZn468AoPdAIIVR74W9AOIlQOabs2D3uHKe60JrcmFn+2gF0Bi
	 k0wSRtl4y5i7kANmrGMGAy3P+eFw==
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
Date: Thu, 13 Aug 2026 16:33:57 +0800
From: pipishuo <1289151713@qq.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
	yi.zhang@huawei.com
Cc: linux-ext4@vger.kernel.org
Subject: [PATCH] Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir
X-OQ-MSGID: <an2BdW4mHqQaYlVb@DESKTOP-AT5F202.localdomain>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

After a failure in the route ext4_restore_inline_data ->
ext4_create_inline_data -> ext4_mark_iloc_dirty, the inode will still
be considered as having inline data. However, in ext4_restore_inline_data,
the inline data is not actually written to the inode. When ext4_readdir
is subsequently called,ext4_has_inline_data will pass the check
and proceed to read the incorrect inline data.

Signed-off-by: pipishuo <1289151713@qq.com>
---
 fs/ext4/dir.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 17edd678fa87..6117a798541a 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -22,6 +22,7 @@
  *
  */
 
+#include <asm-generic/errno-base.h>
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
 #include <linux/filelock.h>
@@ -159,6 +160,9 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 	}
 
 	if (ext4_has_inline_data(inode)) {
+		if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
+			return -EINVAL;
+
 		int has_inline_data = 1;
 		err = ext4_read_inline_dir(file, ctx,
 					   &has_inline_data);
-- 
2.47.3

