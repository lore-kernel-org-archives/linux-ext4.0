From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v2] ext4: avoid reusing recently deleted inodes in no
 journal mode
Date: Wed, 7 Aug 2013 17:03:28 -0700
Message-ID: <20130807170328.5f601d92735dd147781ff4d1@linux-foundation.org>
References: <1374809631-5258-1-git-send-email-tytso@mit.edu>
	<1374867164-21942-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41235 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933571Ab3HHAD3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Aug 2013 20:03:29 -0400
In-Reply-To: <1374867164-21942-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 26 Jul 2013 15:32:43 -0400 "Theodore Ts'o" <tytso@mit.edu> wrote:

> In no journal mode, if an inode has recently been deleted, we
> shouldn't reuse it right away.  Otherwise it's possible, after an
> unclean shutdown, to hit a situation where a recently deleted inode
> gets reused for some other purpose before the inode table block has
> been written to disk.  However, if the directory entry has been
> updated, then the directory entry will be pointing at the old inode
> contents.

Sounds a bit hacky :(

> E2fsck will make sure the file system is consistent after the
> unclean shutdown.  However, if the recently deleted inode is a
> character mode device, or an inode with the immutable bit set, even
> after the file system has been fixed up by e2fsck, it can be
> possible for a *.pyc file to be pointing at a character mode
> device, and when python tries to open the *.pyc file, Hilarity
> Ensues.  We could change all of userspace to be very suspicious
> about stat'ing files before opening them, and clearing the
> immutable flag if necessary --- or we can just avoid reusing an
> inode number if it has been recently deleted.
> 
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -625,6 +625,51 @@ static int find_group_other(struct super_block *sb, struct inode *parent,
>  }
>  
>  /*
> + * In no journal mode, if an inode has recently been deleted, we want
> + * to avoid reusing it until we're reasonably sure the inode table
> + * block has been written back to disk.
> + */
> +int recently_deleted(struct super_block *sb, ext4_group_t group, int ino)
> +{
> +	struct ext4_group_desc	*gdp;
> +	struct ext4_inode	*raw_inode;
> +	struct buffer_head	*bh;
> +	unsigned long		dtime, now;
> +	int	inodes_per_block = EXT4_SB(sb)->s_inodes_per_block;
> +	int	offset, ret = 0, recentcy = 30;

The version in linux-next is different from this.  it uses

+       int     offset, ret = 0, recentcy = dirty_expire_interval;

which breaks the build because dirty_expire_interval isn't exported to
modules.  Good luck fixing this without adding a bisection hole :(

Also, it's spelled "recency"!

What's the rationale for using this anyway?  Seems a bit arbitrary. 
Wouldn't using the ext4 commit interval be more appropriate?


