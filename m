From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH][BUG] ext4: dx_map_entry cannot support over 64KB block	size
Date: Fri, 05 Jun 2009 15:20:00 -0600
Message-ID: <20090605212000.GV9002@webber.adilger.int>
References: <20090605165049.e8bd9c74.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:33526 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbZFEVUa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Jun 2009 17:20:30 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n55LKWaZ006957
	for <linux-ext4@vger.kernel.org>; Fri, 5 Jun 2009 14:20:32 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KKS00900AVB5900@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Fri,
 05 Jun 2009 14:20:32 -0700 (PDT)
In-reply-to: <20090605165049.e8bd9c74.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 05, 2009  16:50 +0900, Toshiyuki Okajima wrote:
> From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> 
> The dx_map_entry structure doesn't support over 64KB block size by current
> usage of its member("offs"). Because "offs" treats an offset of copies of
> the ext4_dir_entry_2 structure as is. This member size is 16 bits. But real
> offset for over 64KB(256KB) block size needs 18 bits. However, real offset
> keeps 4 byte boundary, so lower 2 bits is not used.
> 
> Therefore, we do the following to fix this limitation:
> For "store": 
> 	we divide the real offset by 4 and then store this result to "offs" 
> 	member.
> For "use":
> 	we multiply "offs" member by 4 and then use this result 
> 	as real offset.

This patch unfortunately doesn't address all of the issues related
to blocksize > 64kB.

There are a number of other places where there are limits related
to > 64kB blocksize like ext4_dir_entry_2 itself having only a
"__u16 rec_len", so without changing the on-disk format it is not
possible to have > 64kB blocksize.

You would only notice this if you create a large enough directory.
It might be possible to force very large directory blocks to have
multiple directory entries (max size 65536 bytes using the helpers
ext4_rec_len_{to,from}_disk() to convert 0xffff -> 0x10000).


The dx_map_entry you are changing is only an in-memory structure,
so changing it to use an int doesn't matter, but without changing
the on-disk structures it is not useful.

> Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> ---
>  fs/ext4/namei.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> --- linux-2.6.30-rc6/fs/ext4/namei.c.orig	2009-05-26 01:35:09.000000000 +0900
> +++ linux-2.6.30-rc6/fs/ext4/namei.c	2009-06-06 00:05:51.000000000 +0900
> @@ -750,7 +750,7 @@ static int dx_make_map(struct ext4_dir_e
>  			ext4fs_dirhash(de->name, de->name_len, &h);
>  			map_tail--;
>  			map_tail->hash = h.hash;
> -			map_tail->offs = (u16) ((char *) de - base);
> +			map_tail->offs = ((char *) de - base)>>2;
>  			map_tail->size = le16_to_cpu(de->rec_len);
>  			count++;
>  			cond_resched();
> @@ -1148,7 +1148,8 @@ dx_move_dirents(char *from, char *to, st
>  	unsigned rec_len = 0;
>  
>  	while (count--) {
> -		struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *) (from + map->offs);
> +		struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *) 
> +							(from + (map->offs<<2));
>  		rec_len = EXT4_DIR_REC_LEN(de->name_len);
>  		memcpy (to, de, rec_len);
>  		((struct ext4_dir_entry_2 *) to)->rec_len =

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

