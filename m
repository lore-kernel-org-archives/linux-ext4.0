From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: barriers off by default?
Date: Sat, 17 May 2008 14:02:57 -0500
Message-ID: <482F2BE1.3040705@redhat.com>
References: <482868A5.1000102@redhat.com> <20080515144355.GB19325@atrey.karlin.mff.cuni.cz> <482CA094.20703@redhat.com> <20080516002145.GA24369@duck.suse.cz> <482CDC27.4090505@redhat.com> <20080517173840.GD8009@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbYEQTDA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 May 2008 15:03:00 -0400
In-Reply-To: <20080517173840.GD8009@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> Given the discussion on the other thread about the performance impact
> and hard-to-hit nature of barrier problems, how about this?

I still want to do a bit of testing to see if it's really that hard to
hit :)  (trying to hook up my x10-power-killer is a challenge with no
serial ports....)

But in any case, adding these to potential default mount options sounds
good to me.

-Eric

>     		       	  	  	    	- Ted
> 
> ext4: Add EXT4_DEFM_BARRIER and EXT4_DEFM_I_VERSION default mount options
> 
> Allow the i_version and barrier mount options to be set by default via
> flags in the ext4 superblock.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index b7ffb91..afeba1f 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -785,6 +785,8 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
>  #define EXT4_DEFM_JMODE_DATA	0x0020
>  #define EXT4_DEFM_JMODE_ORDERED	0x0040
>  #define EXT4_DEFM_JMODE_WBACK	0x0060
> +#define EXT4_DEFM_BARRIER	0x0080
> +#define EXT4_DEFM_I_VERSION	0x0100
>  
>  /*
>   * Structure of a directory entry
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 09d9359..c0a657c 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -729,7 +729,7 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
>  		seq_printf(seq, ",commit=%u",
>  			   (unsigned) (sbi->s_commit_interval / HZ));
>  	}
> -	if (test_opt(sb, BARRIER))
> +	if (test_opt(sb, BARRIER) && !(def_mount_opts & EXT4_DEFM_BARRIER))
>  		seq_puts(seq, ",barrier=1");
>  	if (test_opt(sb, NOBH))
>  		seq_puts(seq, ",nobh");
> @@ -737,7 +737,7 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
>  		seq_puts(seq, ",noextents");
>  	if (!test_opt(sb, MBALLOC))
>  		seq_puts(seq, ",nomballoc");
> -	if (test_opt(sb, I_VERSION))
> +	if (test_opt(sb, I_VERSION) && !(def_mount_opts & EXT4_DEFM_I_VERSION))
>  		seq_puts(seq, ",i_version");
>  
>  	if (sbi->s_stripe)
> @@ -1896,6 +1896,12 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
>  	else if ((def_mount_opts & EXT4_DEFM_JMODE) == EXT4_DEFM_JMODE_WBACK)
>  		sbi->s_mount_opt |= EXT4_MOUNT_WRITEBACK_DATA;
>  
> +	if (def_mount_opts & EXT4_DEFM_BARRIER)
> +		set_opt(sbi->s_mount_opt, BARRIER);
> +
> +	if (def_mount_opts & EXT4_DEFM_I_VERSION)
> +		sb->s_flags |= MS_I_VERSION;
> +
>  	if (le16_to_cpu(sbi->s_es->s_errors) == EXT4_ERRORS_PANIC)
>  		set_opt(sbi->s_mount_opt, ERRORS_PANIC);
>  	else if (le16_to_cpu(sbi->s_es->s_errors) == EXT4_ERRORS_CONTINUE)

