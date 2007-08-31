From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] placate checkpatch.pl to some degree for mballoc.c
Date: Fri, 31 Aug 2007 16:58:54 -0600
Message-ID: <20070831225854.GS5377@schatzie.adilger.int>
References: <46D887F2.1040502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:58234 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbXHaW6m (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Aug 2007 18:58:42 -0400
Content-Disposition: inline
In-Reply-To: <46D887F2.1040502@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 31, 2007  16:28 -0500, Eric Sandeen wrote:
> Here's a patch for mballoc.c, to make checkpatch happier with it.
> 
> I was about as pedantic as I could be, except for a few things it 
> complained about which I just could not agree with. :)

I'm happy with the changes, since I've adopted the kernel CodingStyle
as my own, but not everyone at CFS has.

> One of the comments in the series file in git says checkpatch doesn't like
> mballoc, so, here you go, if it's helpful.  Applies to the bottom of the
> patch stack - should some of these mballoc patches get rolled together by
> now?
> 
> -Eric
> 
> Make checkpatch happier with mballoc.c
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

You can add my "Signed-off-by: Andreas Dilger <adilger@clusterfs.com>"

> @@ -829,7 +845,8 @@ ext4_mb_mark_free_simple(struct super_bl
> -			mb_clear_bit(first >> min, buddy + sbi->s_mb_offsets[min]);
> +			mb_clear_bit(first >> min,
> +					buddy + sbi->s_mb_offsets[min]);

Hmm, shouldn't "buddy" be aligned on the '(' from the previous line?

>  #define	MB_PROC_HANDLER(name, var)					\
> +    do {								\
>  	proc = create_proc_entry(name, mode, sbi->s_mb_proc);		\
>  	if (proc == NULL) {						\
>  		printk(KERN_ERR "EXT4-fs: can't to create %s\n", name);	\
> @@ -2722,7 +2796,8 @@ MB_PROC_VALUE_WRITE(group_prealloc);
>  	}								\
>  	proc->data = sbi;						\
>  	proc->read_proc  = ext4_mb_read_##var ;				\
> -	proc->write_proc = ext4_mb_write_##var;
> +	proc->write_proc = ext4_mb_write_##var;				\
> +    } while (0)

Should the "do {" and "} while (0)" be left aligned instead of indented 4
spaces?

> @@ -2871,7 +2947,8 @@ int ext4_mb_mark_diskspace_used(struct e
>  		}
>  	}
>  #endif
> -	mb_set_bits(bitmap_bh->b_data, ac->ac_b_ex.fe_start, ac->ac_b_ex.fe_len);
> +	mb_set_bits(bitmap_bh->b_data, ac->ac_b_ex.fe_start,
> +						ac->ac_b_ex.fe_len);

Align with '(' on previous line?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
