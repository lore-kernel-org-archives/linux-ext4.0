From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4:fix unexpected error from ext4_reserve_global
Date: Fri, 15 Jun 2007 16:41:24 -0700
Message-ID: <1181950884.3808.16.camel@dyn9047017103.beaverton.ibm.com>
References: <20070614152927.GC6517@localhost.sw.ru>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dmitriy Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:38953 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbXFOXlb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Jun 2007 19:41:31 -0400
In-Reply-To: <20070614152927.GC6517@localhost.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


On Thu, 2007-06-14 at 19:29 +0400, Dmitriy Monakhov wrote:
> I just cant belive my eyes then i saw this at the first time...
> simple test: strace dd if=/dev/zero of=/mnt/file
> 
Thanks for reporting it. 

> open("/dev/zero", O_RDONLY)             = 0
> close(1)                                = 0
> open("/mnt/test/file", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 1
> read(0, "\0\0\0\0\0\0\0\0\0"..., 512) = 512
> write(1, "\0\0\0\0\0\0\0\0"..., 512) = 512
> read(0, "\0\0\0\0\0\0\0\0\0"..., 512) = 512
> write(1, "\0\0\0\0\0\0\0\0"..., 512) = -1 ENOENT (No such fil
> e or directory)
> 
> This strange error returned from ext4_reserve_global().
> It's just typo because:
> a) In fact this is 100% ENOSPC situation
> b) simular function ext4_reserve_local() returns -ENOSPC
> 
I agree.

Patch is put in ext4 patch queue. Alex if you can Ack, that would be
great.


Thanks,

Mingming
> Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/balloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 4d7bfd2..43ae8f8 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -1920,7 +1920,7 @@ int ext4_reserve_global(struct super_block *sb, int blocks)
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
>  	struct ext4_reservation_slot *rs;
> -	int i, rc = -ENOENT;
> +	int i, rc = -ENOSPC;
>  	__u64 free = 0;
> 
>  	rs = sbi->s_reservation_slots;
