From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] ext4: clean up feature flag checking and usage
Date: Sun, 4 Oct 2015 09:36:09 +1100
Message-ID: <20151003223609.GK3902@dastard>
References: <1443865028-5943-1-git-send-email-adilger@dilger.ca>
 <1443865028-5943-2-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:51393 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745AbbJCWgN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Oct 2015 18:36:13 -0400
Content-Disposition: inline
In-Reply-To: <1443865028-5943-2-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 03, 2015 at 03:37:08AM -0600, Andreas Dilger wrote:
> Clean up the EXT4_{HAS,SET,CLEAR}_{,RO_,IN}COMPAT_FEATURE() flag
> checking to be easier to read, as well as safer from accidental
> coding mistakes.  Instead of passing the EXT4_FEATURE_*COMPAT_foo
> flag name to the macro, generate the EXT4_FEATURE_*COMPAT prefix
> within the macro, to ensure the flag name matches the check being
> done, since the numerical value might be for the wrong compat type.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>
> ---
>  fs/ext4/balloc.c    |   17 ++---
>  fs/ext4/dir.c       |    7 +-
>  fs/ext4/ext4.h      |   70 ++++++++++---------
>  fs/ext4/ext4_jbd2.h |   26 +++----
>  fs/ext4/extents.c   |    4 +-
>  fs/ext4/ialloc.c    |    4 +-
>  fs/ext4/indirect.c  |    3 +-
>  fs/ext4/inline.c    |    3 +-
>  fs/ext4/inode.c     |   18 ++---
>  fs/ext4/ioctl.c     |   15 ++---
>  fs/ext4/migrate.c   |   13 ++--
>  fs/ext4/mmp.c       |    7 +-
>  fs/ext4/namei.c     |    8 +--
>  fs/ext4/resize.c    |   29 +++-----
>  fs/ext4/super.c     |  191 ++++++++++++++++++++++++---------------------------
>  fs/ext4/xattr.c     |    4 +-
>  16 files changed, 194 insertions(+), 225 deletions(-)
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index cd6ea29..bc44979 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -213,7 +213,7 @@ static int ext4_init_block_bitmap(struct super_block *sb,
>  
>  	start = ext4_group_first_block_no(sb, block_group);
>  
> -	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
> +	if (EXT4_HAS_INCOMPAT_FEATURE(sb, FLEX_BG))

Rather than making it hard to use cscope/ctags to find the users of
these feature flags, wouldn't it be better to turn this around the
other way similar to the way XFS does this? i.e.:

 -	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
+	if (ext4_has_feature_flex_bg(sb))

static inline ext4_has_feature_flex_bg(struct super_block *sb)
{
	return EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG);
}

That way the code doing the feature checks is clear and concise, is
much less shouty and it's not cluttered by whether features are in
the incompat, ro or compat matrices. As a bonus, cscope still works
just fine.

And then you can clean up/factor the macros and shorten the flags
knowing that they there are all in the one place and so doesn't
cause problems with code maintenance.

just my 2c worth...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
