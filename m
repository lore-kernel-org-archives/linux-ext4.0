From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: [PATCH] ext4: turn on i_version updates by default
Date: Mon, 14 May 2012 09:02:12 -0600
Message-ID: <9124E59E-2479-4C32-A528-3237B48DEC01@dilger.ca>
References: <20120514140618.GA29902@fieldses.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>,
	"linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120514140618.GA29902-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 2012-05-14, at 8:06, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org> wrote:
> knfsd needs i_version updates on, as will userspace nfs servers and
> probably others.
> 
> The only effects are that inode->i_version is bumped (under the i_lock)
> in more places, and that ->dirty_inode(I_DIRTY_DATASYNC) may be called
> more frequently than once per jiffy on write (see file_update_time).
> However the latter appears to be mostly a no-op in that case.

I thought this can have noticeable performance impact, since ext4_mark_inode_dirty() is quite heavyweight?

This is one of the reasons that the i_version update is conditional. If someone is exporting a filesystem from userspace the should be able to turn this on as a mount option, and knfsd could do it from inside the kernel. Why add overhead when it is not needed?

> So, simplify our life and just keep this feature turned on all the time.
> 
> Signed-off-by: J. Bruce Fields <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> fs/ext4/super.c |    3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
> 
> If people are worried that the performance impact isn't obvious, I'll
> find the time somehow to test this properly....
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index e1fb1d5..a99f827 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1483,7 +1483,7 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
>        sbi->s_mount_flags |= EXT4_MF_FS_ABORTED;
>        return 1;
>    case Opt_i_version:
> -        sb->s_flags |= MS_I_VERSION;
> +        /* no-op; this is on by default now */
>        return 1;
>    case Opt_journal_dev:
>        if (is_remount) {
> @@ -2979,6 +2979,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>        goto out_free_orig;
>    }
>    sb->s_fs_info = sbi;
> +    sb->s_flags |= MS_I_VERSION;
>    sbi->s_mount_opt = 0;
>    sbi->s_resuid = EXT4_DEF_RESUID;
>    sbi->s_resgid = EXT4_DEF_RESGID;
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
