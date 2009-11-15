From: Damien Guibouret <damien.guibouret@partition-saving.com>
Subject: Re: s_first_meta_bg treatment incompatibility between kernel and
 e2fsprogs
Date: Sun, 15 Nov 2009 11:28:13 +0100
Message-ID: <4AFFD7BD.1080300@partition-saving.com>
References: <4AFAA95C.5000304@partition-saving.com> <20091115042057.GC4323@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:47743 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbZKOK0l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Nov 2009 05:26:41 -0500
In-Reply-To: <20091115042057.GC4323@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Wed, Nov 11, 2009 at 01:09:00PM +0100, Damien Guibouret wrote:
> 
> Yup, you're right.  Ouch.  That is a kernel bug, and it means that if
> we resize a filesystem to the point where we need to use meta_bg
> (because we've run out of blocks to reserve), if there are
> uninitialized block bitmaps, kernels that don't have a fix will
> misbehave by reserving too many file system metadata blocks.  This
> will waste bit of disk space, which fsck will fix.
> 
> (s_first_meta_bg by definition is always less than or equal to
> s_gdb_count.)
> 
> I think this patch should fix things up.
> 
> 					- Ted
> 
> commit b33c339814f97fc48a843f45f6068f84bc735141
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Sat Nov 14 23:20:30 2009 -0500
> 
>     ext4: Fix uninit block bitmap initialization when s_meta_first_bg is non-zero
>     
>     The number of old-style block group descriptor blocks is
>     s_meta_first_bg when the meta_bg feature flag is set.
>     
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 1d04189..f3032c9 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -761,7 +761,13 @@ static unsigned long ext4_bg_num_gdb_meta(struct super_block *sb,
>  static unsigned long ext4_bg_num_gdb_nometa(struct super_block *sb,
>  					ext4_group_t group)
>  {
> -	return ext4_bg_has_super(sb, group) ? EXT4_SB(sb)->s_gdb_count : 0;
> +	if (!ext4_bg_has_super(sb, group))
> +		return 0;
> +
> +	if (EXT4_HAS_INCOMPAT_FEATURE(sb,EXT4_FEATURE_INCOMPAT_META_BG))
> +		return le32_to_cpu(EXT4_SB(sb)->s_es->s_first_meta_bg);
> +	else
> +		return EXT4_SB(sb)->s_gdb_count;
>  }
>  
>  /**
> 
> 

Hello,

I've open a kernel bug since: 
http://bugzilla.kernel.org/show_bug.cgi?id=14601
with a proposed patch (little different from yours but it is matter of 
taste :)
And I think there is some other places where kernel should be fixed when 
it uses s_gdb_count (but here my knowledge of the sources are not deep 
enough to be sure on what shall be performed).

Regards,

Damien
