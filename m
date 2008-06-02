From: Shen Feng <shen@cn.fujitsu.com>
Subject: Re: [PATCH]ext4: Fix ext4_mb_init_cache return error
Date: Mon, 02 Jun 2008 09:16:05 +0800
Message-ID: <484349D5.2020104@cn.fujitsu.com>
References: <483FE24F.50105@rs.jp.nec.com>	 <1212173573.8596.84.camel@BVR-FS.beaverton.ibm.com> <1212354146.4368.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: cmm@us.ibm.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1212354146.4368.3.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Mingming Cao Wrote:
> ext4: Fix ext4_mb_init_cache return error
> 
> From: Mingming Cao <cmm@us.ibm.com>
> 
> ext4_mb_init_cache() incorrectly always return EIO on success. This
> causes the caller of ext4_mb_init_cache() fail when it checks
>  the return value.
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> ---
>  fs/ext4/mballoc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.26-rc4/fs/ext4/mballoc.c
> ===================================================================
> --- linux-2.6.26-rc4.orig/fs/ext4/mballoc.c	2008-06-01 12:55:19.000000000 -0700
> +++ linux-2.6.26-rc4/fs/ext4/mballoc.c	2008-06-01 12:55:23.000000000 -0700
> @@ -798,7 +798,7 @@ static int ext4_mb_init_cache(struct pag
>  	for (i = 0; i < groups_per_page && bh[i]; i++)
>  		wait_on_buffer(bh[i]);
>  
> -	err = -EIO;
> +	err = 0;
>  	for (i = 0; i < groups_per_page && bh[i]; i++)
>  		if (!buffer_uptodate(bh[i]))
>  			goto out;
> 
> 

I think the fix should be

   	err = -EIO;
  	for (i = 0; i < groups_per_page && bh[i]; i++)
  		if (!buffer_uptodate(bh[i]))
  			goto out;
 +	err = 0;

Is that right?

Shen Feng
