From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH] mke2fs, tune2fs, resize2fs: add warning messages for bigalloc and quota
Date: Mon, 21 Jan 2013 19:19:29 -0500 (EST)
Message-ID: <679935ED-C84D-42C4-B6C4-2F104774FBB0@redhat.com>
References: <1358813397-26528-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:46475 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab3AVATb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jan 2013 19:19:31 -0500
In-Reply-To: <1358813397-26528-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 21, 2013, at 6:16 PM, "Theodore Ts'o" <tytso@mit.edu> wrote:

> The bigalloc and quota features have some known issues, so issue
> warnings in case users try to use them.
> 
Looks good, thanks Ted.

Eric

> More information can be found here:
>    https://ext4.wiki.kernel.org/index.php/Bigalloc
>    https://ext4.wiki.kernel.org/index.php/Quota
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> misc/mke2fs.c  | 12 ++++++++++++
> misc/tune2fs.c |  4 ++++
> resize/main.c  | 14 ++++++++++++++
> 3 files changed, 30 insertions(+)
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index ace9eae..fe5ce7d 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -1942,6 +1942,18 @@ profile_error:
>        exit(1);
>    }
> 
> +    if (fs_param.s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_BIGALLOC)
> +        fprintf(stderr, _("\nWarning: the bigalloc feature is still "
> +                  "under development\n"
> +                  "See https://ext4.wiki.kernel.org/"
> +                  "index.php/Bigalloc for more information\n\n"));
> +
> +    if (fs_param.s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_QUOTA)
> +        fprintf(stderr, _("\nWarning: the quota feature is still "
> +                  "under development\n"
> +                  "See https://ext4.wiki.kernel.org/"
> +                  "index.php/Quota for more information\n\n"));
> +
>    /* Since sparse_super is the default, we would only have a problem
>     * here if it was explicitly disabled.
>     */
> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> index 2c8b9e8..849f3a0 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -736,6 +736,10 @@ void handle_quota_options(ext2_filsys fs)
>    quota_release_context(&qctx);
> 
>    if ((usrquota == QOPT_ENABLE) || (grpquota == QOPT_ENABLE)) {
> +        fprintf(stderr, _("\nWarning: the quota feature is still "
> +                  "under development\n"
> +                  "See https://ext4.wiki.kernel.org/"
> +                  "index.php/Quota for more information\n\n"));
>        fs->super->s_feature_ro_compat |= EXT4_FEATURE_RO_COMPAT_QUOTA;
>        ext2fs_mark_super_dirty(fs);
>    } else if (!fs->super->s_usr_quota_inum &&
> diff --git a/resize/main.c b/resize/main.c
> index 711e375..4cbfe69 100644
> --- a/resize/main.c
> +++ b/resize/main.c
> @@ -147,6 +147,18 @@ static void determine_fs_stride(ext2_filsys fs)
> #endif
> }
> 
> +static bigalloc_check(ext2_filsys fs, int force)
> +{
> +    if (!force && EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
> +                EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
> +        fprintf(stderr, _("\nResizing bigalloc file systems has "
> +                  "not been fully tested.  Proceed\n"
> +                  "at your own risk!  Use the force option "
> +                  "if you want to go ahead anyway.\n\n"));
> +        exit(1);
> +    }
> +}
> +
> int main (int argc, char ** argv)
> {
>    errcode_t    retval;
> @@ -428,6 +440,7 @@ int main (int argc, char ** argv)
>        exit(0);
>    }
>    if (mount_flags & EXT2_MF_MOUNTED) {
> +        bigalloc_check(fs, force);
>        retval = online_resize_fs(fs, mtpt, &new_size, flags);
>    } else {
>        if (!force && ((fs->super->s_lastcheck < fs->super->s_mtime) ||
> @@ -438,6 +451,7 @@ int main (int argc, char ** argv)
>                device_name);
>            exit(1);
>        }
> +        bigalloc_check(fs, force);
>        printf(_("Resizing the filesystem on "
>             "%s to %llu (%dk) blocks.\n"),
>               device_name, new_size, fs->blocksize / 1024);
> -- 
> 1.7.12.rc0.22.gcdd159b
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
