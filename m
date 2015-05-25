From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/4] libext2fs: Support for orphan file feature
Date: Mon, 25 May 2015 10:01:33 +0200
Message-ID: <20150525080133.GD2387@quack.suse.cz>
References: <1432294137-26078-1-git-send-email-jack@suse.cz>
 <1432294137-26078-2-git-send-email-jack@suse.cz>
 <4CA1ABFA-BDCE-44D7-AC06-FF1D606803A4@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbbEYIBj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 May 2015 04:01:39 -0400
Content-Disposition: inline
In-Reply-To: <4CA1ABFA-BDCE-44D7-AC06-FF1D606803A4@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 22-05-15 15:59:19, Andreas Dilger wrote:
> On May 22, 2015, at 5:28 AM, Jan Kara <jack@suse.cz> wrote:
> > diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> > index a755cfac8eae..a77c8fa09938 100644
> > --- a/lib/ext2fs/ext2_fs.h
> > +++ b/lib/ext2fs/ext2_fs.h
> > @@ -52,6 +52,7 @@
> > #define EXT2_JOURNAL_INO	 8	/* Journal inode */
> > #define EXT2_EXCLUDE_INO	 9	/* The "exclude" inode, for snapshots */
> > #define EXT4_REPLICA_INO	10	/* Used by non-upstream feature */
> > +#define EXT4_ORPHAN_INO		 9	/* Inode with orphan entries */
> 
> This still has a problem here, and can't be safely landed until it is
> resolved.  At a minimum, it shouldn't be possible to create a filesystem
> with COMPAT_ORPHAN_FILE at the same time as COMPAT_EXCLUDE_BITMAP.  Since
> EXCLUDE_BITMAP never made it upstream, that might be a reasonable
> compromise for now.

Yeah, for now I've chosen inode number 9 as for testing it's good enough.
We can make this feature incompatible with COMPAT_EXCLUDE_BITMAP as you
suggest or we can use some higher inode number and require increased number
of reserved inodes. I don't mind either too much.

> That said, we still need to do something about the lack of reserved inodes.

Agreed. I've tried to get some decision from Ted regarding this a few times
but failed.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
