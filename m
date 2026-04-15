Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA919349B1C
	for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2026 10:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776250667; cv=none; b=I/71hk8+0MsHCoMyZmU31urqeTj0vHfFhzwfVJir0PoWyW7XF6mVi6/JzbnRFhg2BdFKKIa/O8bUMCLstLb3wrwBhVf0DeR6griEyba7w61PY7sjVreIogZ6bKJOLXxZF7dqD2f8oA45vCJYHYTmGKSnOmR25xtBPGxic7mCU/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776250667; c=relaxed/simple;
	bh=UK3lJkvrquQhe0fP4WyLMG/tg2c2pg/CvPSG7/ycm2g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ik6X9DD25HzfMJ2dogNVSzeIhXnbB49dwy3nhD9nAhgV+Uayxh4WAHCTh1S0wID6uLiNOPQw0eNB9VGrIhePwUHGxu8UsueAdfD6JEi41RFx+pfxDEWhpC3zav1FVu+zjwasBt45wwQZgeuwKE/Tj5okxLXnipYK5QVjiQMsAhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fwdPb5VTVzYQthB
	for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2026 18:56:51 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id A6EBA40574
	for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2026 18:57:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP3 (Coremail) with SMTP id _Ch0CgAHtL0fb99pbf70AQ--.45727S4;
	Wed, 15 Apr 2026 18:57:36 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH v2 0/4] show orphan file inode detail info
Date: Wed, 15 Apr 2026 18:55:01 +0800
Message-Id: <20260415105505.342358-1-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgAHtL0fb99pbf70AQ--.45727S4
X-Coremail-Antispam: 1UD129KBjvJXoW7uF4UuFWxCF17Aw4rGr17ZFb_yoW8KFy3pa
	9xCw45t3WDJasIkrs3A3WxXFyrKFn3Gw45Gr1agryUt398WrZYgr1xK3yY9a4kCrWfAFn0
	qr4jqryj9FyDZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUglb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVF
	xhVjvjDU0xZFpf9x07UE-erUUUUU=
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

Diffs v2 vs v1:
(1) Fix sashiko review issues:
https://sashiko.dev/#/patchset/20260403082507.1882703-1-yebin%40huaweicloud.com
(2) Change "orphan_list" file mode from 0444 to 0400;
(3) The display format of the "orphan_list" file is modified according
    to Andreas' suggestions.
Fault injection tests have been conducted to address the issues raised
in the sashik review. There is no UAF issue in the ext4_seq_orphan_release()
function. The reason for this has already been explained in the code comments.
In addition to the fault injection tests, we also performed a stress test by
observing the /proc/fs/ext4/XX/orphan_list and the concurrent processes of
adding and removing orphan nodes, and no issues were found so far.


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

Ye Bin (4):
  ext4: register 'orphan_list' procfs
  ext4: skip cursor node in ext4_orphan_del()
  ext4: show inode orphan list detail information
  ext4: show orphan file inode detail info

 fs/ext4/ext4.h   |   1 +
 fs/ext4/orphan.c | 326 ++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/sysfs.c  |   2 +
 3 files changed, 328 insertions(+), 1 deletion(-)

-- 
2.34.1

