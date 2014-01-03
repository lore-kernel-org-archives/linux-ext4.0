From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/5] e2image: fix resource leak when running e2image -n
Date: Fri, 03 Jan 2014 10:32:29 -0600
Message-ID: <52C6E61D.7080708@redhat.com>
References: <1388726998-14349-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbaACQcd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jan 2014 11:32:33 -0500
In-Reply-To: <1388726998-14349-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/2/14, 11:29 PM, Theodore Ts'o wrote:
> Addresses-Coverity-ID: #1147783
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Thanks for fixing these - 

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

(Aside:  Seems odd that -n emits "Writing block XXX" when it's
not actually writing anything, but *shrug*)

-Eric

> ---
>  misc/e2image.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/misc/e2image.c b/misc/e2image.c
> index ab6a4fa..253fad1 100644
> --- a/misc/e2image.c
> +++ b/misc/e2image.c
> @@ -174,7 +174,7 @@ static void generic_write(int fd, void *buf, int blocksize, blk64_t block)
>  		printf(_("Writing block %llu\n"), (unsigned long long) block);
>  		if (fd != 1)
>  			seek_relative(fd, blocksize);
> -		return;
> +		goto free_and_return;
>  	}
>  	count = write(fd, buf, blocksize);
>  	if (count != blocksize) {
> @@ -191,6 +191,7 @@ static void generic_write(int fd, void *buf, int blocksize, blk64_t block)
>  
>  		exit(1);
>  	}
> +free_and_return:
>  	if (free_buf)
>  		ext2fs_free_mem(&buf);
>  }
> 

