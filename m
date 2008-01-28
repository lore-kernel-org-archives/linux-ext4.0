From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [3/18] BKL-removal: Convert ext3 to use unlocked_ioctl
Date: Sun, 27 Jan 2008 21:33:47 -0800
Message-ID: <20080127213347.5bf5c324.akpm@linux-foundation.org>
References: <20080127317.043953000@suse.de>
	<20080127021709.55F0814D2E@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, adilger@clusterfs.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andi Kleen <ak@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46931 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755368AbYA1FeG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2008 00:34:06 -0500
In-Reply-To: <20080127021709.55F0814D2E@wotan.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 27 Jan 2008 03:17:09 +0100 (CET) Andi Kleen <ak@suse.de> wrote:

> 
> I checked ext3_ioctl and it looked largely safe to not be used
> without BKL.  So convert it over to unlocked_ioctl.
> 
> The only case where I wasn't quite sure was for the
> dynamic fs grow ioctls versus umounting -- I kept the BKL for those. 
> 

Please cpoy linux-ext4 on ext2/3/4 material.

I skippped a lot of these patches because I just got bored of fixing
rejects.  Now is a very optimistic time to be raising patches against
mainline.

I'm going to work on getting a unified devel tree operating: one which
contains everyone's latest stuff and is updated daily.  Basically it'll be
-mm without a couple of the quilt trees.  People can then prepare patches
against that, as it seems that most can't be bothered patching against -mm,
let alone building and testing it.  More later.

> +		/* AK: not sure the BKL is needed, but this might prevent
> +		 * races against umount */
> +		lock_kernel();
>  		err = ext3_group_extend(sb, EXT3_SB(sb)->s_es, n_blocks_count);
>  		journal_lock_updates(EXT3_SB(sb)->s_journal);
>  		journal_flush(EXT3_SB(sb)->s_journal);
>  		journal_unlock_updates(EXT3_SB(sb)->s_journal);
> +		unlock_kernel();
>  
>  		return err;
>  	}
> @@ -245,11 +249,14 @@ flags_err:
>  		if (copy_from_user(&input, (struct ext3_new_group_input __user *)arg,
>  				sizeof(input)))
>  			return -EFAULT;
> -
> +		/* AK: not sure the BKL is needed, but this might prevent
> +		 * races against umount */
> +		lock_kernel();
>  		err = ext3_group_add(sb, &input);
>  		journal_lock_updates(EXT3_SB(sb)->s_journal);
>  		journal_flush(EXT3_SB(sb)->s_journal);
>  		journal_unlock_updates(EXT3_SB(sb)->s_journal);
> +		unlock_kernel();
>  

The ext3_ioctl() caller has an open fd against the fs - should be
sufficient to keep unmount away?

(gets even more rejects, drops all the fasync patches too)

It's all reached the stage of stupid.
