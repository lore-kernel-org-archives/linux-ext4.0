From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Subject: Re: [PATCH -V2 3/5] ext4: Fix the race between read_block_bitmap
	and mark_diskspace_used
Date: Tue, 25 Nov 2008 15:29:33 +0100
Message-ID: <1227623373.3810.7.camel@frecb007923.frec.bull.fr>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <20081123140038.GC26473@mit.edu> <492A5453.9030801@sun.com>
	 <20081124113323.GC8462@skywalker>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Alex Zhuravlev <Alex.Zhuravlev@Sun.COM>,
	Theodore Tso <tytso@MIT.EDU>, cmm@us.ibm.com,
	sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:38191 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbYKYO1s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Nov 2008 09:27:48 -0500
In-Reply-To: <20081124113323.GC8462@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Ok the changes was not done for this purpose. I need to make sure we
> update bitmap and clear group_desc uninit flag after taking sb_bgl_lock
> That means when we claim blocks we can't use mb_set_bits with
> sb_bgl_lock because we would already be holding it. How about the below
> change
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 444ad99..53180b1 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -1031,7 +1031,10 @@ static void mb_clear_bits(spinlock_t *lock, void *bm, int cur, int len)
>  			cur += 32;
>  			continue;
>  		}
> -		mb_clear_bit_atomic(lock, cur, bm);
> +		if (lock)
> +			mb_clear_bit_atomic(lock, cur, bm);
> +		else
> +			mb_clear_bit(cur, bm);
>  		cur++;
>  	}
>  }
> @@ -1049,7 +1052,10 @@ static void mb_set_bits(spinlock_t *lock, void *bm, int cur, int len)
>  			cur += 32;
>  			continue;
>  		}
> -		mb_set_bit_atomic(lock, cur, bm);
> +		if (lock)
> +			mb_set_bit_atomic(lock, cur, bm);
> +		else
> +			mb_set_bit(cur, bm);
>  		cur++;
>  	}
>  }


Aneesh,

I've just tried your patch on top of the patch queue and I still have
this error when I resize the fs while allocating blocks concurrently
(with dd):

EXT4-fs error (device md0): ext4_mb_mark_diskspace_used: Allocating
block in system zone - block = 9117697
EXT4-fs error (device md0): ext4_mb_generate_buddy: EXT4-fs: group 1113:
6144 blocks in bitmap, 6014 in gd


Anyway I'm not sure if it is related to the race you try to fix.

FYI this error first appeared with the first set of patches concerning
resize and mballoc.

Regards,

Frederic







