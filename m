From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext2: add wait flag support to sync_fs
Date: Thu, 19 Nov 2009 16:34:19 +0100
Message-ID: <20091119153419.GB2943@atrey.karlin.mff.cuni.cz>
References: <20091117174617.285298261@vyatta.com> <20091117174647.402219318@vyatta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, hch@infradead.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51100 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363AbZKSPeO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Nov 2009 10:34:14 -0500
Content-Disposition: inline
In-Reply-To: <20091117174647.402219318@vyatta.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Make ext2 safer against accidental data loss during removal
> by adding support for waiting for super block update on sync.
> Don't know why this wasn't done originally, all the other file
> systems have it.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> 
> --- a/fs/ext2/super.c	2009-11-17 09:14:12.177002522 -0800
> +++ b/fs/ext2/super.c	2009-11-17 09:14:32.698005421 -0800
> @@ -1147,6 +1147,8 @@ static int ext2_sync_fs(struct super_blo
>  		ext2_sync_super(sb, es);
>  	} else {
>  		ext2_commit_super(sb, es);
> +		if (wait)
> +			sync_dirty_buffer(EXT2_SB(sb)->s_sbh);
>  	}
>  	sb->s_dirt = 0;
>  	unlock_kernel();
  Looking at the code it just looks strange. Part of it is because
of Christoph's conversion of ext2_write_super to ext2_sync_fs
(40f31dd47e7c3d15af1f9845eda0fa0c4c33f32f) but the VALID_FS handling
oddness seems to be even older. IMHO we should just clear the VALID_FS
flag on mount and in write_super() and sync_fs() just update block and
inode counters. wait == 1 case should then really wait for superblock
buffer, wait == 0 should not wait.
  BTW: Christoph, why did you choose to call ext2_sync_fs with wait == 1
from ext2_write_super()? I'd think (and looking into callsites seem to
confirm that) that ->write_super() was meant to be asynchronous...
  I've added this to my todo...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
