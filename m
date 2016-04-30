From: Damien Guibouret <damien.guibouret@partition-saving.com>
Subject: Remarks regarding sparse_super2 feature
Date: Sat, 30 Apr 2016 17:23:58 +0200
Message-ID: <5724CE0E.6030407@partition-saving.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:13666 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbcD3PXI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 30 Apr 2016 11:23:08 -0400
Received: from [192.168.103.118] (unknown [82.230.26.21])
	by smtp4-g21.free.fr (Postfix) with ESMTP id 083ED19F59E
	for <linux-ext4@vger.kernel.org>; Sat, 30 Apr 2016 15:29:43 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I was looking to sparse_super2 feature and there is some points I do not 
understand in the way it is handled on fs initialisation and resize.

In ext2fs_initialize (initialize.c), the backup superblocks field is initialised 
at line 437, but they were used previously when checking for overhead (at line 
407) when the second value is still ~0. Could not this lead to wrong overhead 
computation in some cases?
This is certainly very unlikely because of the 50 margin taken on this overhead. 
As this is some chicken/egg problem, solution is not obvious. A way is perhaps 
to have ext2fs_bg_has_super accepting ~0 as a group always having a backup 
superblock (unless extending the number of groups to 64 bits, if such a number 
of groups is reached, it will obviously be the latest so be the candidate for 
the backup bg).

In case there is some other solution, there is same kind of problem in 
adjust_fs_info of resize2fs.c (line 724 check for backup super block and line 
839 updates the value).

Concerning adjust_fs_info I do not understand the logic of some tests concerning 
update of these values:
at line 844:
			if (old_fs->group_desc_count == 1)
				fs->super->s_backup_bgs[0] = 1;
			if (old_fs->group_desc_count == 1 &&
			    fs->super->s_backup_bgs[0])
				fs->super->s_backup_bgs[0] = last_bg;
			else if (fs->super->s_backup_bgs[1])
				fs->super->s_backup_bgs[1] = last_bg;
couldn't the 2 first "if" be collapsed: if first one is true, it leads to second 
one be true and if first one is false, second is also false. Or perhaps it means 
it is the wrong value that is checked or initialised in second if?

For the other case (shrinking the fs) at line 856:
			if (last_bg > 1 &&
			    old_fs->super->s_backup_bgs[1] == old_last_bg)
				fs->super->s_backup_bgs[1] = last_bg;
what ensures the location where the new super block backup will be set is a free 
block?

Regards,

Damien
