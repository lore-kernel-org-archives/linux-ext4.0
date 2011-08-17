From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] ext4: Resolve the hang of direct i/o read in handling
 EXT4_IO_END_UNWRITTEN.
Date: Wed, 17 Aug 2011 10:32:16 +0800
Message-ID: <4E4B2830.202@tao.ma>
References: <1313476673-4866-1-git-send-email-tm@tao.ma> <20110816182922.GA12374@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:35010 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753175Ab1HQCcU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Aug 2011 22:32:20 -0400
In-Reply-To: <20110816182922.GA12374@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/17/2011 02:29 AM, Ted Ts'o wrote:
> On Tue, Aug 16, 2011 at 02:37:53PM +0800, Tao Ma wrote:
>> From: Tao Ma <boyu.mt@taobao.com>
>>
>> EXT4_IO_END_UNWRITTEN flag set and the increase of i_aiodio_unwritten should
>> be done simultaneously since ext4_end_io_nolock always clear the flag and
>> decrease the counter in the same time.
>>
>> We don't increase i_aiodio_unwritten when setting EXT4_IO_END_UNWRITTEN so
>> it will go nagative and causes some process to wait forever.
>>
>> Part of the patch came from Eric in his e-mail, but it doesn't fix the problem
>> met by Michael actually.
>> http://marc.info/?l=linux-ext4&m=131316851417460&w=2
>>
>> Reported-and-Tested-by: Michael Tokarev<mjt@tls.msk.ru>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> 
> Thanks I've taken this into the ext4 tree.  I am a bit worried this
> will trigger a GCC warning:
> 
> +	/*
> +	 * It may be over-defensive here to check EXT4_IO_END_UNWRITTEN now,
> +	 * but being more careful is always safe for the future change.
> +	 */
>  	inode = io_end->inode;
> +	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
> +		io_end->flag |= EXT4_IO_END_UNWRITTEN;
> +		atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
> +	}
>  
>  	/* Add the io_end to per-inode completed io list*/
>  	spin_lock_irqsave(&EXT4_I(inode)->i_completed_io_lock, flags);
> 
> ... since in Google we've been compiling with -Werror, but it's not
> causing an error on gcc 4.4, which is what I still have on my laptop.
> It may be that newer versions of GCC are smart enough to notice tha
> the above is dead code, and then complain with a warning.
Sorry for my bluntness. But where is the 'dead code' you mean?

Thanks
Tao
