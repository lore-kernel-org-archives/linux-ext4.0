From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: [PATCH 15/15][e2fsprogs] 64-bit mke2fs cleanup
Date: Wed, 16 Jul 2008 14:50:14 +0200
Message-ID: <87tzeq0z95.fsf@frosties.localdomain>
References: <20080715164332.28567.27913.stgit@ichigo>
	<20080715165129.28567.7837.stgit@ichigo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:59438 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384AbYGPMut (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jul 2008 08:50:49 -0400
In-Reply-To: <20080715165129.28567.7837.stgit@ichigo> (Jose R. Santos's
	message of "Tue, 15 Jul 2008 11:51:29 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Jose R. Santos" <jrs@us.ibm.com> writes:

> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 7171990..817be56 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -1402,12 +1402,12 @@ static void PRS(int argc, char *argv[])
>  
>  	fs_param.s_log_frag_size = fs_param.s_log_block_size;
>  
> -	if (noaction && fs_param.s_blocks_count) {
> -		dev_size = fs_param.s_blocks_count;
> +	if (noaction && ext2fs_blocks_count(&fs_param)) {
> +		dev_size = ext2fs_blocks_count(&fs_param);
>  		retval = 0;
>  	} else {
>  	retry:
> -		retval = ext2fs_get_device_size(device_name,
> +		retval = ext2fs_get_device_size2(device_name,
>  						EXT2_BLOCK_SIZE(&fs_param),
>  						&dev_size);
>  		if ((retval == EFBIG) &&

You should not assume that ext2fs_get_device_size2() will return EFBIG
if the size exceed 2^32 blocks. The point of ext2fs_get_device_size2()
was to be able to support more than 2^32 blocks and the library
function will certainly change to return larger numbers in the future.

So you need something like

if ((retval == EFBIG || dev_size >= (1ULL << 32)) &&

MfG
        Goswin
