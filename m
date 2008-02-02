From: Adrian Bunk <bunk@kernel.org>
Subject: ext4_mb_mark_diskspace_used() NULL dereference
Date: Sat, 2 Feb 2008 23:16:58 +0200
Message-ID: <20080202211658.GH9375@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-ext4@vger.kernel.org
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp5.pp.htv.fi ([213.243.153.39]:57874 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812AbYBBVQO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Feb 2008 16:16:14 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The Coverity checker spotted the following NULL dereference:

<--  snip  -->

...
static int ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
                                handle_t *handle)
{
...
        if (!bitmap_bh)
                goto out_err;
...
out_err:
        sb->s_dirt = 1;
        put_bh(bitmap_bh);
...

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
