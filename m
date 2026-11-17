Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.243.164.118
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794906143;
	b=a19c9wlSWET8CwINdEAwKBeXQTx6FYVH6ccGw7ZSkSOYX94bXr5RPXh7RL5cWriqC8iU
	 vwgnSx3REzhe9yBCoVBKW+m5qTBgU+6eD21ENqLgh+G+u43V41zCRqMM/NSI8yMkyu1Uv
	 ZJ8w7/fdiO4DpC4kHVA2lDkcxvnM/wNMMo1RoXfGW7qUOwl/xf7lQkneJhOZMxFaopgQ5
	 2XYU124rcyifspzWpAWwWoq+un0TYkCNwfkujpdCQK4gC0QwATfU+FCAwsxS4NzcskPRj
	 W5XNgLtlQnEjt4Rh056S6CWCBGBJUqVNFBFAQAb1nMPjkdw6jTS8qpvSE4Gud6e8nNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794906143;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=Bgdc6jSPLfW83BX6wn4Fl1AM2Lm4mBIpDe6dcz1hYJY=;
	b=mWn3ybaCEohXvK3ap+wtJ6mAE0fElVSNLpckPE/o5k3jU2MqGLMpLb8dtc8jPSQgavKF
	 F7FKuVcdW/Kipt8XvvpQoJL6wLWXU5BB9hl5sB2zG8e3+f5qL3UJspxV0JQKnM2LeI5wj
	 FRDSu2SE4Mfg2JIxdcV8Nfp9J9gMzmcfa6Z1OQ5oA9yL+u3+34gm15EHnOK1Q0V9k7ImU
	 JfP+1ajeTT0a6ZrAqEALw5yMa6ET2cguATQHUGv4d+couvvbYWVqMJKNScZctJan0jrv0
	 6FC0etLJ6G87wUnG3zUJusyeNPuUiigVEyBkbXRr++WrSxzc8DH3XmTtkI3tb3vs4Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=stu.xidian.edu.cn;
	spf=pass smtp.mailfrom=stu.xidian.edu.cn;
	arc=none smtp.remote-ip=162.243.164.118
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16A3F606A338;
	Tue, 17 Nov 2026 09:02:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16A3F606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.xidian.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.xidian.edu.cn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=stu.xidian.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
	Message-Id:MIME-Version:Content-Transfer-Encoding; bh=Bgdc6jSPLf
	W83BX6wn4Fl1AM2Lm4mBIpDe6dcz1hYJY=; b=6J1Nb5YSE+N4foY6wQwPEj2jv0
	uS9AallwPOABOSIRlV+VzyNtsEw/1WSi9x1xpvXZRTBzfCKcuDE9PU5r8Yn64C8D
	rsr/vVajZsHqS55pCSEKpRwnHgLW2wKmIEPpjOaotlWQxPVJxQL1jwfQ9Z7ypxQk
	SpLUJfhwUMas+3/YY=
Received: from LAPTOP-FRMFRHCN.localdomain (unknown [240e:456:1000:aaf5:8952:40b1:8a4c:314f])
	by hzbj-edu-front-2.icoremail.net (Coremail) with UTF8SMTPA id BLQMCkDWHQP9F_xqf8PEAQ--.17852S2;
	Tue, 17 Nov 2026 17:01:52 +0800 (CST)
From: Haoli Zhang <26031212468@stu.xidian.edu.cn>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+3fbf2337de43f5581aec@syzkaller.appspotmail.com,
	Haoli Zhang <26031212468@stu.xidian.edu.cn>,
	Jinning Zhang <25031212117@stu.xidian.edu.cn>,
	Bin Yu <byu@xidian.edu.cn>
Subject: [PATCH] ext4: validate in-inode xattrs before listing
Date: Tue, 17 Nov 2026 17:01:47 +0800
Message-Id: <20261117090147.3950327-1-26031212468@stu.xidian.edu.cn>
X-Mailer: git-send-email 2.34.1
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
X-CM-TRANSID:BLQMCkDWHQP9F_xqf8PEAQ--.17852S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tr47WF1UKF4DKF4DtF1UWrg_yoW8WF4rp3
	WYkr1jvrWUtryUKws5t3W7Wwn0g3ZrWa1UZFyakw1xZFn7Xa1IyFyrtr4UCF1UZrWDAr1Y
	qFWDtr1DuF45u3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBa14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
	1j6F4UJwAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40E
	FcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr
	0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8v
	x2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20x
	vY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I
	3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIx
	AIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAI
	cVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2js
	IEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQvtAUUUUU=
X-CM-SenderInfo: yswqjiasrskluy6v33wo0lvxldqovvfxof0/1tbiAgUAEWr7HsjXCAAAsO

ext4_iget() validates in-inode xattrs when it reads an inode. However,
ext4_xattr_ibody_list() fetches the inode-table data again with
ext4_get_inode_loc() and passes the entries to ext4_xattr_list_entries()
without validating this read. If the re-read data contains a malformed
xattr entry, the listing loop can advance beyond the valid in-inode xattr
area and read invalid memory.

Validate the in-inode xattrs from this read with xattr_check_inode()
before listing them. If validation fails, skip the listing and return the
error after releasing the inode-table buffer.

Reported-by: syzbot+3fbf2337de43f5581aec@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=3fbf2337de43f5581aec
Co-developed-by: Jinning Zhang <25031212117@stu.xidian.edu.cn>
Signed-off-by: Jinning Zhang <25031212117@stu.xidian.edu.cn>
Co-developed-by: Bin Yu <byu@xidian.edu.cn>
Signed-off-by: Bin Yu <byu@xidian.edu.cn>
Signed-off-by: Haoli Zhang <26031212468@stu.xidian.edu.cn>
---
 fs/ext4/xattr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -790,9 +790,11 @@
 		return error;
 	raw_inode = ext4_raw_inode(&iloc);
 	header = IHDR(inode, raw_inode);
-	error = ext4_xattr_list_entries(dentry, IFIRST(header),
-					buffer, buffer_size);
+	error = xattr_check_inode(inode, header, ITAIL(inode, raw_inode));
+	if (!error)
+		error = ext4_xattr_list_entries(dentry, IFIRST(header),
+						buffer, buffer_size);
 
 	brelse(iloc.bh);
 	return error;
 }

