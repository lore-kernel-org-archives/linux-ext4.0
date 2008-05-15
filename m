From: Andreas Dilger <adilger@sun.com>
Subject: Re: barriers off by default?
Date: Thu, 15 May 2008 09:21:35 -0700
Message-ID: <20080515162135.GB3098@webber.adilger.int>
References: <482868A5.1000102@redhat.com>
 <20080515144355.GB19325@atrey.karlin.mff.cuni.cz> <482C5E14.9030004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:44737 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757001AbYEOQVo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 May 2008 12:21:44 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m4FGLgFi011745
	for <linux-ext4@vger.kernel.org>; Thu, 15 May 2008 09:21:43 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K0X00G013UDYX00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 15 May 2008 09:21:42 -0700 (PDT)
In-reply-to: <482C5E14.9030004@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 15, 2008  11:00 -0500, Eric Sandeen wrote:
> ... the fsync change seems sane too...
> 
> @@ -85,7 +86,10 @@ int ext3_sync_file(struct file * file, s
>                         .sync_mode = WB_SYNC_ALL,
>                         .nr_to_write = 0, /* sys_fsync did this */
>                 };
> +               journal_t *journal = EXT3_SB(inode->i_sb)->s_journal;
>                 ret = sync_inode(inode, &wbc);
> +               if (journal && (journal->j_flags & JFS_BARRIER))
> +                       blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
>         }
>  out:
> 
> I assume we need that for some power-plug-pull scenarios ... in fact I
> had just been meaning to do something similar after reading an old
> thread on barriers.  reiserfs & xfs do this already in their sync paths.

Wouldn't it make more sense to add this into the generic do_fsync()
routine?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

