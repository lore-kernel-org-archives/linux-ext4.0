From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ext3: also fix loop in do_split()
Date: Tue, 2 Dec 2008 12:07:51 -0800
Message-ID: <20081202120751.8b0226ca.akpm@linux-foundation.org>
References: <49310E1A.60105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, adilger@sun.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: roel kluin <roel.kluin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750852AbYLBUJ2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Dec 2008 15:09:28 -0500
In-Reply-To: <49310E1A.60105@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 29 Nov 2008 04:40:42 -0500
roel kluin <roel.kluin@gmail.com> wrote:

> unsigned i >= 0 is always true
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index 3e5edc9..8f5e15d 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -1188,7 +1188,7 @@ static struct ext3_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
>  	/* Split the existing block in the middle, size-wise */
>  	size = 0;
>  	move = 0;
> -	for (i = count-1; i >= 0; i--) {
> +	for (i = count-1; i < count; i--) {
>  		/* is more than half of this entry in 2nd half of the block? */
>  		if (size + map[i].size/2 > blocksize/2)
>  			break;

A local variable called `i' should always have signed type.  In fact,
it should have `int' type.  Doing

	unsigned i;

is an act of insane vandalism, punishable by spending five additional
years coding in fortran.

I suggest you fix this by giving `i' the type God intended, or by
making it unsigned and then renaming it to something which is not
intended to trick programmers and reviewers.

Sheesh.
