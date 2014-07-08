From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: fix potential null pointer dereference in
 ext4_free_inode
Date: Tue, 8 Jul 2014 13:00:09 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1407081259150.2180@localhost.localdomain>
References: <002901cf9a6f$401a0c50$c04e24f0$@samsung.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	"'Dan Carpenter'" <dan.carpenter@oracle.com>,
	Ashish Sangwan <a.sangwan@samsung.com>
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906AbaGHLAU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jul 2014 07:00:20 -0400
In-Reply-To: <002901cf9a6f$401a0c50$c04e24f0$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 8 Jul 2014, Namjae Jeon wrote:

> Date: Tue, 08 Jul 2014 14:41:22 +0900
> From: Namjae Jeon <namjae.jeon@samsung.com>
> To: Theodore Ts'o <tytso@mit.edu>
> Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
>     'Dan Carpenter' <dan.carpenter@oracle.com>,
>     Ashish Sangwan <a.sangwan@samsung.com>
> Subject: [PATCH] ext4: fix potential null pointer dereference in
>     ext4_free_inode
> 
> Fix potential null pointer dereferencing problem caused by e43bb4e612
> ("ext4: decrement free clusters/inodes counters when block group declared bad")
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>

Looks good.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> ---
>  fs/ext4/ialloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index a87455d..6bfe7eb 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -338,7 +338,7 @@ out:
>  			fatal = err;
>  	} else {
>  		ext4_error(sb, "bit already cleared for inode %lu", ino);
> -		if (!EXT4_MB_GRP_IBITMAP_CORRUPT(grp)) {
> +		if (gdp && !EXT4_MB_GRP_IBITMAP_CORRUPT(grp)) {
>  			int count;
>  			count = ext4_free_inodes_count(sb, gdp);
>  			percpu_counter_sub(&sbi->s_freeinodes_counter,
> 
