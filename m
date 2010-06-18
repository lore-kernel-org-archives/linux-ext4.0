From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: fio test triggering bad data on ext4
Date: Fri, 18 Jun 2010 19:32:17 +0200
Message-ID: <4C1BADA1.5090705@fusionio.com>
References: <4C1B292C.2080205@fusionio.com> <4C1B7C73.505@redhat.com> <4C1B89C1.6090408@redhat.com> <4C1B8D1F.3020002@fusionio.com> <4C1B90AE.1050703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"adilger@sun.com" <adilger@sun.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49213 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933739Ab0FRRcS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jun 2010 13:32:18 -0400
In-Reply-To: <4C1B90AE.1050703@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-06-18 17:28, Eric Sandeen wrote:
> Jens Axboe wrote:
>> On 18/06/10 16.59, Eric Sandeen wrote:
>>   
>>> Eric Sandeen wrote:
>>>     
>>>> Jens Axboe wrote:
>>>>       
>>>>> Hi,
>>>>>
>>>>> I was writing a small fio job file to do writes and read verifies on a
>>>>> device. It forks 32 processes, each writing randomly to 4 files with a
>>>>> block size between 4k and 16k. When it has written 1024 of those blocks,
>>>>> it'll verify the oldest 512 of them. Each block is checksummed for every
>>>>> 512b. It uses libaio and O_DIRECT.
>>>>>
>>>>> It works on ext2 and btrfs. I haven't run it to completion yet, but they
>>>>> survive 15-20 minutes just fine. ext4 doesn't even go a full minutes
>>>>> before this triggers:
>>>>>         
>>>> Jens, can you try XFS too?  Since ext3 can't do direct IO to a hole,
>>>> (and I'm not sure about btrfs in that regard), ext4 may be most similar
>>>> to xfs's behavior on the test ... wondering how it fares.
>>>>
>>>> Thanks,
>>>> -Eric
>>>>       
>>> Actually mingming had a patch for direct-io.c which may be related, I'll
>>> test that out.
>>>     
>>
>> OK, I'll try XFS tonight as well.
>>
>>
>>   
> I haven't been able to reproduce it on ext4 here, yet.
> 
> FWIW here's the patch from mingming:
> 
> When unaligned DIO writes, skip zero out the block if the buffer is marked
> unwritten. That means there is an asynconous direct IO (append or fill the hole)
> still pending.
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> ---
>  fs/direct-io.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-git/fs/direct-io.c
> ===================================================================
> --- linux-git.orig/fs/direct-io.c	2010-05-07 15:42:22.855033403 -0700
> +++ linux-git/fs/direct-io.c	2010-05-07 15:44:17.695007770 -0700
> @@ -740,7 +740,8 @@
>  	struct page *page;
>  
>  	dio->start_zero_done = 1;
> -	if (!dio->blkfactor || !buffer_new(&dio->map_bh))
> +	if (!dio->blkfactor || !buffer_new(&dio->map_bh)
> +	    || buffer_unwritten(&dio->map_bh))
>  		return;
>  
>  	dio_blocks_per_fs_block = 1 << dio->blkfactor;
> 
> 

What is this patch against?

-- 
Jens Axboe

