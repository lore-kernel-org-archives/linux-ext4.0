From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC] ext4: block reservation allocation
Date: Mon, 27 Feb 2012 14:11:27 -0700
Message-ID: <944BA011-1D65-4816-BB97-E886942B4464@dilger.ca>
References: <20120227090901.GA13953@gmail.com> <alpine.LFD.2.00.1202271234250.5597@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:63307 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab2B0VL3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Feb 2012 16:11:29 -0500
In-Reply-To: <alpine.LFD.2.00.1202271234250.5597@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-02-27, at 5:00 AM, Lukas Czerner wrote:
> On Mon, 27 Feb 2012, Zheng Liu wrote:
>> 
>> Now, in ext4, we have multi-block allocation and delay allocation. They work
>> well for most scenarios. However, in some specific scenarios, they cannot help
>> us to optimize block allocation. For example, the user may want to indicate some
>> file set to be allocated at the beginning of the disk because its speed in this
>> position is faster than its speed at the end of disk.
>> 
>> I have done the following experiment. The experiment is on my own server, which
>> has 16 Intel(R) Xeon(R) CPU E5620 @ 2.40GHz, 48G memory and a 1T sas disk. I
>> split this disk into two partitions, one has 900G, and another has 100G. Then I
>> use dd to get the speed of read/write. The result is as following.
>> 
>> [READ]
>> # dd if=/dev/sdk1 of=/dev/null bs=128k count=10000 iflag=direct
>> 1310720000 bytes (1.3 GB) copied, 9.41151 s, 139 MB/s
>> 
>> # dd if=/dev/sdk2 of=/dev/null bs=128k count=10000 iflag=direct
>> 1310720000 bytes (1.3 GB) copied, 17.952 s, 73.0 MB/s
>> 
>> [WRITE]
>> # dd if=/dev/zero of=/dev/sdk1 bs=128k count=10000 oflag=direct
>> 1310720000 bytes (1.3 GB) copied, 8.46005 s, 155 MB/s
>> 
>> # dd if=/dev/zero of=/dev/sdk2 bs=128k count=10000 oflag=direct
>> 1310720000 bytes (1.3 GB) copied, 15.8493 s, 82.7 MB/s
>> 
>> So filesystem can provide a new feature to let the user to indicate a value
>> for reserving some blocks from the beginning of the disk. When the user needs
>> to allocate some blocks for an important file that needs to be read/write as
>> quick as possible, the user can use ioctl(2) and/or other ways to notify
>> filesystem to allocate these blocks in the reservation area. Thereby, the user
>> can obtain the higher performance for manipulating this file set.
>> 
>> This idea is very trivial. So any comments or suggestions are appreciated.
> 
> Hi Zheng,
> 
> I have to admit I do not like it :). I think that this kind of
> optimization is useless in the long run. There are several reasons for
> this:
> 
> - the test you've done is purely fabricated and does not respond to
>   real workload at all. Especially because it is done on a huge files.
>   I can imagine this approach improving boot speed, but you will
>   usually have to load just small files, so for single file it does not
>   make much sense. Moreover with small files more seeks would have to
>   be done hugely reducing the advantage you can see with dd.

Lukas,
I think the generalization "you will usually have to load just small files"
is not something that you can make.  Some workloads have small files (e.g.
distro installers) and some have large files (e.g. media servers, HPC, etc).

> - HDD might have more platters than just one
> - Your file system might span across several drives

These two typically do not matter, since the tracks on the HDD are still
interleaved between the drive heads, so that there is never a huge seek
between block N and N+1 just because N was at the outside of one platter
and N+1 was on the inside of the next platter.

Similarly, with RAID storage the blocks are typically interleaved between
drives in a sequential manner for the same reason.  It's true that this
not guaranteed for LVM, but it is still _generally_ true, since LVM will
allocate LEs from lower numbers to higher numbers unless there is some
reason not to do so.

> - On thinly provisioned storage this does not make sense at all

True, but even with thin provisioned storage the backing file blocks will
typically try to allocate sequentially if possible.  I don't think this
can be used as an argument _against_ giving the filesystem more allocation
information, since it cannot be worse than having no information at all.

> - SSD's are more and more common and this optimization is useless for
>   them.

Sure, but it also isn't _harmful_ for SSDs, and not everyone can afford
huge amounts of SSDs.

> Is there any 'real' problem you would want to solve with this ? Or is it
> just something that came to you mind ? I agree that we want to improve
> our allocators, but IMHO especially for better scalability, not to cover
> this disputable niche.
> 
> Anyway, you may try to come up with better experiment. Something which
> would actually show how much can we get from the more realistic workload
> rather than showing that contiguous serial writes are faster closely to
> the center of the disk platter, we know that.
> 
> Thanks!
> -Lukas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





