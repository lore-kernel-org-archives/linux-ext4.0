Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29213C5DBA
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 13:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773321291; cv=none; b=QI+52KyxaoT9RV7mgZ/gktTlENtjvTaitFOolLHslDEAnzfiu70olyMSDiNZycns9efv4c3mlqyxykbB4xIDzQ36beatMcLq2yEmYgEiJOrMD1VQCPv2CjkWRQwFIQaZvEGri/ULnOKEXWvdEsZ0wuJXpl7qnJlTi5CxUlcTECc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773321291; c=relaxed/simple;
	bh=on4gGb7XOTYMoEW2dWJjy7OuLvXzDFw73SBhO95/EiE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gIcXA/TerOIsbguZQ/Bdv9psnkyxp9E1T4jzskLm3e+dpz+NZS4tHE8KJx7YJkoeCdKFes1Sd35rWadWQz2vFMtbd1CJ7vDB86EwSnKpCIgH8F1Fd4f73JyBg+ny/rcoUcAStcXQW85cYVtcYBevwjuY/eenBE++y048o+5xg+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fWp3K6Rg7zYQv7b
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 21:13:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 19A8040573
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 21:14:39 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgDX_Ug8vLJpGVeVAg--.45112S8;
	Thu, 12 Mar 2026 21:14:39 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: [PATCH v2 4/8] ext4: fix miss unlock 'sb->s_umount' in extents_kunit_init()
Date: Thu, 12 Mar 2026 21:12:49 +0800
Message-Id: <20260312131253.366296-5-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260312131253.366296-1-yebin@huaweicloud.com>
References: <20260312131253.366296-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDX_Ug8vLJpGVeVAg--.45112S8
X-Coremail-Antispam: 1UD129KBjvJXoW7tr17ur4DZw1xZr45Wr48JFb_yoW8Gw1Dpr
	4fAFy8Kr1ru3W7C3y8GF4Utry3Can5C3W7CryfWF43XFW7u348KF45KF1YkFW5Xa1UXFn8
	AF40ya4UCw43C3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvEb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
	Cq3wA2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
	rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
	AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E
	14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
	xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Y
	z7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
	evJa73UjIFyTuYvjxU2CJmUUUUU
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
---
 fs/ext4/extents-test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
index 9e055f399167..5a5016ea1ecc 100644
--- a/fs/ext4/extents-test.c
+++ b/fs/ext4/extents-test.c
@@ -307,6 +307,8 @@ static int extents_kunit_init(struct kunit *test)
 	kunit_activate_static_stub(test, ext4_ext_zeroout, ext4_ext_zeroout_stub);
 	kunit_activate_static_stub(test, ext4_issue_zeroout,
 				   ext4_issue_zeroout_stub);
+	up_write(&sb->s_umount);
+
 	return 0;
 }
 
-- 
2.34.1

