From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: fix mmp use after free during unmount
Date: Thu, 20 Oct 2016 14:26:38 -0600
Message-ID: <B4E24389-6BE1-4896-B426-EB60172133E3@dilger.ca>
References: <0b8909ed-ae65-1a89-263c-12aff513377a@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_C2F32C03-7068-4AA5-A87A-B3BD53E19821"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        shuwang@redhat.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:35369 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752333AbcJTU0o (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Oct 2016 16:26:44 -0400
Received: by mail-it0-f68.google.com with SMTP id 139so7864750itm.2
        for <linux-ext4@vger.kernel.org>; Thu, 20 Oct 2016 13:26:44 -0700 (PDT)
In-Reply-To: <0b8909ed-ae65-1a89-263c-12aff513377a@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_C2F32C03-7068-4AA5-A87A-B3BD53E19821
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Oct 20, 2016, at 12:19 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> 
> In ext4_put_super, we call brelse on the buffer head containing
> the ext4 superblock, but then try to use it when we stop the
> mmp thread, because when the thread shuts down it does:
> 
> write_mmp_block
>  ext4_mmp_csum_set
>    ext4_has_metadata_csum
>      WARN_ON_ONCE(ext4_has_feature_metadata_csum(sb)...)
> 
> which reaches into sb->s_fs_info->s_es->s_feature_ro_compat,
> which lives in the superblock buffer s_sbh which we just released.
> 
> Fix this by moving the brelse down to a point where we are no
> longer using it.
> 
> Reported-by: Wang Shu <shuwang@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> 
> Note: found by inspection after a bug report via KASAN,
> compile-tested only.
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 6db81fb..f273212 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -862,7 +862,6 @@ static void ext4_put_super(struct super_block *sb)
> 	percpu_counter_destroy(&sbi->s_dirs_counter);
> 	percpu_counter_destroy(&sbi->s_dirtyclusters_counter);
> 	percpu_free_rwsem(&sbi->s_journal_flag_rwsem);
> -	brelse(sbi->s_sbh);
> #ifdef CONFIG_QUOTA
> 	for (i = 0; i < EXT4_MAXQUOTAS; i++)
> 		kfree(sbi->s_qf_names[i]);
> @@ -894,6 +893,9 @@ static void ext4_put_super(struct super_block *sb)
> 	}
> 	if (sbi->s_mmp_tsk)
> 		kthread_stop(sbi->s_mmp_tsk);
> +
> +	/* Don't let this go until everything is done with the ext4 super */
> +	brelse(sbi->s_sbh);
> 	sb->s_fs_info = NULL;
> 	/*
> 	 * Now that we are completely done shutting down the
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_C2F32C03-7068-4AA5-A87A-B3BD53E19821
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWAkogHKl2rkXzB/gAQgTSBAAjDTjQwCw5ckiiaaFp6PZ97WC5HocPfWg
GyPTWcWpzZtbqOFDjkKeDlz+/cX6s4xhfQ12ZoJ1vZZATtbC7CeAW6p8FkLjyDUY
NUQJREGcbDH5JXfZJ7LQRZYn8oXnMCkICPrN01batJ9ao8YuzOvJJNQ9f2dRHT07
AR/JkCmwZJHeM5L57HFlXNqpSxvAky5lyN/lMVYGqQY/+3jk5SxLtaWA3x0qlFvT
FI/GoydYSlgmooCzbpAoA1k4Y4n/8yuqs0w7MLUzYWA0J9MR2N8Hwzlw7JnjXf9Z
DsluynZWwxUpYfaGtKssj/qNCYipJeQGDR7/UmbiqFEqJ4hBYdQv2+SkRi8Vz8XA
l8nOAqgHe4SBnTMkNGI7Dq0onPtI5v167GCjyJwCIflqLBxG1uTRZ7rzEBM+9/Gw
/XUDTYbilamEJQvtqCEVb2ehv96bOupgYClILpj3rSJtbEqGqsMAZKMlyhSNY6d5
9gnliIHi7ud6HlaZi7t0gkhvO5EnBuyc+tBfkfGZS8wJdTnxuzhAd7uKwBq62UaU
m3bmIwIjgOAr1sKDuST8jfdnCt1XgJXct5YQQ5cnuPjLlIxvSkAsQAtlzVNL3rNq
z/flLMMwywrHz9mhBFwOZabaz+oLupzNdd5cvMz2zCqIw2qYaNDTc8+Cmd9zTie2
upiL0GjFf6E=
=fgfX
-----END PGP SIGNATURE-----

--Apple-Mail=_C2F32C03-7068-4AA5-A87A-B3BD53E19821--
