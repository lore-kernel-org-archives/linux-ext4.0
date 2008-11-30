From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH] ext4: fix loop in do_split()
Date: Sat, 29 Nov 2008 19:36:52 -0500
Message-ID: <4931E024.2010500@tmr.com>
References: <49310D34.1000205@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, adilger@sun.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: roel kluin <roel.kluin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.tmr.com ([64.65.253.246]:57243 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755590AbYK3AhW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Nov 2008 19:37:22 -0500
In-Reply-To: <49310D34.1000205@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

roel kluin wrote:
> unsigned i >= 0 is always true
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 63adcb7..389cf60 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1198,7 +1198,7 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
>  	/* Split the existing block in the middle, size-wise */
>  	size = 0;
>  	move = 0;
> -	for (i = count-1; i >= 0; i--) {
> +	for (i = count-1; i < count; i--) {
>  		/* is more than half of this entry in 2nd half of the block? */
>  		if (size + map[i].size/2 > blocksize/2)
>  			break;
> 
While this unsigned wrap method is technically valid, it certainly isn't 
obvious, and making code readable should be a goal as well as making it correct. 
  After all, code which is hard to read is hard to understand, making it hard to 
maintain. I therefore suggest the simpler form:
	for (i = count; i--; ) {
which gives the same i values inside the loop, but does assume that the reader 
remembers that i is unsigned, and intuitively understand wraparound while 
passing zero.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
