Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A845D3C3BFD
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2026 12:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773925001; cv=none; b=Br1J3nI+8T49AZPaH3DIJyHyulO6446MIhRjWfG369EbU4aPS9ln/oE022ZcJHfLr6ceruTRBLGLJ7LObrhylURDVIhIaoNfCBrJNiBpd+WRuIqAaD3dVpRlh01BXtbcgz9uRQ7+0qlhtdbUIdV287XJV6W+DqOzA2W+9QpLz8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773925001; c=relaxed/simple;
	bh=WY3bjKmRH8qFcnlkWTbgZY0ZY3c7vpOAI5F0Ow5Jn2U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kSxuUhe4tapPsGYWBUNk22DRHa98j4+5wn5BVC+aNsmDmfbGr7NdwRpvPCYGNSjbGrSGo7jdlOlFyDyT27gVeBi1w+SMfFiFhGrY6hLClVYIE0wySbgenKkYJYASVqeEl4zHDFbiR7C67WGsHSzmrJcZ35UFHsFkOKP8V8IAjT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fc5KX6SH9zKHMV7
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2026 20:56:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3B88A40574
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2026 20:56:30 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgCHYUx68rtpgy7uBQ--.23117S5;
	Thu, 19 Mar 2026 20:56:30 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH v4 1/5] ext4: fix miss unlock 'sb->s_umount' in extents_kunit_init()
Date: Thu, 19 Mar 2026 20:54:30 +0800
Message-Id: <20260319125434.333117-2-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260319125434.333117-1-yebin@huaweicloud.com>
References: <20260319125434.333117-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHYUx68rtpgy7uBQ--.23117S5
X-Coremail-Antispam: 1UD129KBjvJXoW7tr17ur4DZw1xZr45Wr48JFb_yoW8Xw1Dpw
	43AFyUKr1rZ3W7CFW8tF4UtryYka1fCa47CryfWF43XFW7u348Kr1fKF1YkFW5Xa1UXFn8
	ZF40va4jkw43C3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvlb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_Jrv_JF4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
	0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
	17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
	C0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
	6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvj
	DU0xZFpf9x07UAEfrUUUUU=
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

There's warning as follows when do ext4 kunit test:
WARNING: kunit_try_catch/15923 still has locks held!
7.0.0-rc3-next-20260309-00028-g73f965a1bbb1-dirty #281 Tainted: G            E    N
1 lock held by kunit_try_catch/15923:
 #0: ffff888139f860e0 (&type->s_umount_key#70/1){+.+.}-{4:4}, at: alloc_super.constprop.0+0x172/0xa90
Call Trace:
 <TASK>
 dump_stack_lvl+0x180/0x1b0
 debug_check_no_locks_held+0xc8/0xd0
 do_exit+0x1502/0x2b20
 kthread+0x3a9/0x540
 ret_from_fork+0xa76/0xdf0
 ret_from_fork_asm+0x1a/0x30

As sget() will return 'sb' which holds 's->s_umount' lock. However,
"extents-test" miss unlock this lock.
So unlock 's->s_umount' in the end of extents_kunit_init().

Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/extents-test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
index 5496b2c8e2cd..82c59291e045 100644
--- a/fs/ext4/extents-test.c
+++ b/fs/ext4/extents-test.c
@@ -309,6 +309,8 @@ static int extents_kunit_init(struct kunit *test)
 	kunit_activate_static_stub(test, ext4_ext_zeroout, ext4_ext_zeroout_stub);
 	kunit_activate_static_stub(test, ext4_issue_zeroout,
 				   ext4_issue_zeroout_stub);
+	up_write(&sb->s_umount);
+
 	return 0;
 }
 
-- 
2.34.1

