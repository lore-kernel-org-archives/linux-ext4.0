From: "Rohit Sharma" <imreckless@gmail.com>
Subject: find_group_orlov()
Date: Tue, 23 Dec 2008 01:21:07 +0530
Message-ID: <2d08ef090812221151v35995102vc3c14d052fcebb90@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Kernelnewbies <kernelnewbies@nl.linux.org>,
	ext4 <linux-ext4@vger.kernel.org>,
	maecompprojects@googlegroups.com,
	technical_mae_alumini@googlegroups.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:11364 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbYLVTvH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Dec 2008 14:51:07 -0500
Received: by wf-out-1314.google.com with SMTP id 27so2296511wfd.4
        for <linux-ext4@vger.kernel.org>; Mon, 22 Dec 2008 11:51:07 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a code snippet from find_group_orlov() in ialloc.c of ext2 fs

I am not able to figure out the percpu counters, why it is used.


if (ndirs == 0)
		ndirs = 1;	/* percpu_counters are approximate... */

	blocks_per_dir = (le32_to_cpu(es->s_blocks_count)-free_blocks) / ndirs;

	max_dirs = ndirs / ngroups + inodes_per_group / 16;
               // Why 16??
	min_inodes = avefreei - inodes_per_group / 4;
                   // Why 4 ??
	min_blocks = avefreeb - EXT2_BLOCKS_PER_GROUP(sb) / 4;
    // Why 4 ??

	max_debt = EXT2_BLOCKS_PER_GROUP(sb) / max(blocks_per_dir, BLOCK_COST);
	if (max_debt * INODE_COST > inodes_per_group)
		max_debt = inodes_per_group / INODE_COST;
	if (max_debt > 255)
		max_debt = 255;
	if (max_debt == 0)
		max_debt = 1;

What is the use of debts in allocation. ??

Is it done to make efficient use of free disk space ??
