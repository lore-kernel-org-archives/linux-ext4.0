From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH] e4defrag : Open the source file for e4defrag in read
 write 	mode to avoid failures from EXT4_IOC_EXT_MOVE
Date: Tue, 19 Jan 2010 13:37:31 +0900
Message-ID: <4B55370B.4060801@rs.jp.nec.com>
References: <ea11fea31001182021m66f82afei1750a9e92b53e047@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:59992 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab0ASEiB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jan 2010 23:38:01 -0500
In-Reply-To: <ea11fea31001182021m66f82afei1750a9e92b53e047@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi Manish,

(2010/01/19 13:21), Manish Katiyar wrote:
> Hi Akira,
> 
> I am consistently getting -EBADF while trying out e4defrag and it
> fails with below error.
> 
> /home/mkatiyar/e2fs-git/e2fsprogs/misc>  ./e4defrag -v /tmp/ohsm/mntdir/f1
> ext4 defragmentation for /tmp/ohsm/mntdir/f1
> [1/1]/tmp/ohsm/mntdir/f1:	  0%
> 	Failed to defrag:Bad file descriptor	[ NG ]
>   Success:			[0/1]
> 
> Below patch fixes the issue for me, though I am not sure if this is
> the right fix to open the source file in readwrite mode or fix the
> ext4 ioctl part.
> 

Patch looks good to me.
# I send same patch to Ted last month, but it is not on linux-ext4, sorry.

By commit 4a58579b9e4e2a35d57e6c9c8483e52f6f1b7fd6 of Linus' kernel tree,
rw mode check was added to EXT4_IOC_MOVE_EXTENT.
But command patch which corresponds to this change
has not been merged into e2fsprogs.
So this change is needed to run e4defrag command on current Linux kernel.

Regards,
Akira Fujita


> Open the source file in read write mode to avoid failures from EXT4_IOC_EXT_MOVE
> 
> Signed-off-by: Manish Katiyar<mkatiyar@gmail.com>
> ---
>   misc/e4defrag.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/misc/e4defrag.c b/misc/e4defrag.c
> index 82e3868..424e0ca 100644
> --- a/misc/e4defrag.c
> +++ b/misc/e4defrag.c
> @@ -1605,7 +1605,7 @@ static int file_defrag(const char *file, const
> struct stat64 *buf,
>   		return 0;
>   	}
> 
> -	fd = open64(file, O_RDONLY);
> +	fd = open64(file, O_RDWR);
>   	if (fd<  0) {
>   		if (mode_flag&  DETAIL) {
>   			PRINT_FILE_NAME(file);


