Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA78023E32B
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 08:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775204852; cv=none; b=iZxu25Y8WIAki5QeXQQe6zl6T/wCfTQD23iY3+rftzkb3oBijfREdiiTX1k5mdDXwX88Hsa5c+IT15LS+Pxxx/WdK9KVMerjf60LkIFlf18AzJm58kCPN1KuqclDodKKdRqFpOiinCe2GKv3r9zjEwAvAXZBYRb4jn/B0o8zqPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775204852; c=relaxed/simple;
	bh=U1aI31mmbhlpwmXE0Bjtak6Q23jf7gTz+zcyMU4GPAE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WdXgNVRHijMxBR6Zm3UfVOtXGsQdShWwLa57fzT0WZfJ0l/DFk/estntHWqSBpYcbB0dpZaZSVRWbdQmVfEBMQ9UiEFUN4i7DK/cwOXmw8aV465lCT871Y+0Jrs0FF+RenoFKbCvgk3V50DuGZuXUMOVlT7ErmjgfRM3D7+5jf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fnBdd5BSrzKHMMT
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 16:26:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 418C440595
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 16:27:22 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgDHn0roec9pD5T6DA--.40142S4;
	Fri, 03 Apr 2026 16:27:22 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH 0/3] show orphan file inode detail info
Date: Fri,  3 Apr 2026 16:25:04 +0800
Message-Id: <20260403082507.1882703-1-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHn0roec9pD5T6DA--.40142S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw1xAFy7KF4xGFW5Xw15twb_yoW8Xw4xpa
	98A3yYqa4UJr9rCrZ3A34xJa4Sqrn3Cw45Gr129ryUJwn8WrWv9r17tw4a9a4kCrWxArs0
	vr1Utryj9ryDZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUgGb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCj
	c4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
	CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1x
	MIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnI
	WIevJa73UjIFyTuYvjxUzsqWUUUUU
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

In actual production environments, the issue of inconsistency between
df and du is frequently encountered. In many cases, the cause of the
problem can be identified through the use of lsof. However, when
overlayfs is combined with project quota configuration, the issue becomes
more complex and troublesome to diagnose. First, to determine the project
ID, one needs to obtain orphaned nodes using `fsck.ext4 -fn /dev/xx`, and
then retrieve file information through `debugfs`. However, the file names
cannot always be obtained, and it is often unclear which files they are.
To identify which files these are, one would need to use crash for online
debugging or use kprobe to gather information incrementally. However, some
customers in production environments do not agree to upload any tools, and
online debugging might impact the business. There are also scenarios where
files are opened in kernel mode, which do not generate file descriptors(fds),
making it impossible to identify which files were deleted but still have
references through lsof. This patchset adds a procfs interface to query
information about orphaned nodes, which can assist in the analysis and
localization of such issues.

Ye Bin (3):
  ext4: register 'orphan_list' procfs
  ext4: show inode orphan list detail information
  ext4: show orphan file inode detail info

 fs/ext4/ext4.h   |   1 +
 fs/ext4/orphan.c | 227 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/sysfs.c  |   2 +
 3 files changed, 230 insertions(+)

-- 
2.34.1

