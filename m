From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH updated] ext4: Fix file fragmentation during large file
	write.
Date: Wed, 15 Oct 2008 20:44:07 -0600
Message-ID: <20081016024407.GI2009@webber.adilger.int>
References: <1223661776-20098-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1224103260.6938.45.camel@think.oraclecorp.com>
 <1224114692.6938.48.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	akpm@linux-foundation.org, hch@infradead.org, steve@chygwyn.com,
	npiggin@suse.de, mpatocka@redhat.com, linux-mm@kvack.org,
	inux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:65143 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbYJPCod (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Oct 2008 22:44:33 -0400
In-reply-to: <1224114692.6938.48.camel@think.oraclecorp.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Oct 15, 2008  19:51 -0400, Chris Mason wrote:
> Just FYI, I ran this with compilebench -i 20 --makej and my log is full
> of these:
> 
> ext4_da_writepages: jbd2_start: 1024 pages, ino 520417; err -30
> Pid: 4072, comm: pdflush Not tainted 2.6.27 #2

-30 is -EROFS...  Was the filesystem remounted read-only because of
an error?

> Call Trace:
>  [<ffffffffa0048493>] ext4_da_writepages+0x171/0x2d3 [ext4]
>  [<ffffffff802336be>] ? pick_next_task_fair+0x80/0x91
>  [<ffffffff80228fa8>] ? source_load+0x2a/0x58
>  [<ffffffff8038e499>] ? __next_cpu+0x19/0x26
>  [<ffffffff8026748f>] do_writepages+0x28/0x37
>  [<ffffffff802a6b39>] __writeback_single_inode+0x14f/0x26d
>  [<ffffffff802a6fb7>] generic_sync_sb_inodes+0x1c1/0x2a2
>  [<ffffffff802a70a1>] sync_sb_inodes+0x9/0xb
>  [<ffffffff802a73dc>] writeback_inodes+0x64/0xad
>  [<ffffffff802675db>] wb_kupdate+0x9a/0x10c
>  [<ffffffff80267fd1>] ? pdflush+0x0/0x1e9
>  [<ffffffff80267fd1>] ? pdflush+0x0/0x1e9
>  [<ffffffff8026810e>] pdflush+0x13d/0x1e9
>  [<ffffffff80267541>] ? wb_kupdate+0x0/0x10c
>  [<ffffffff80248222>] kthread+0x49/0x77
>  [<ffffffff8020c5e9>] child_rip+0xa/0x11
>  [<ffffffff802481d9>] ? kthread+0x0/0x77
>  [<ffffffff8020c5df>] ? child_rip+0x0/0x11
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

