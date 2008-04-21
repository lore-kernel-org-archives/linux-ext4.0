From: Ric Wheeler <ric@emc.com>
Subject: Re: Mentor for a GSoC application wanted (Online ext2/3 filesystem
 checker)
Date: Mon, 21 Apr 2008 15:11:29 -0400
Message-ID: <480CE6E1.20302@emc.com>
References: <f19298770804190244y5d6a8502p39f98d1c420135a@mail.gmail.com> <20080419185603.GA30449@mit.edu> <480A42F6.2030005@redhat.com> <20080419220432.GB30449@mit.edu> <87iqyc85q7.fsf@basil.nowhere.org> <20080420234241.GB23292@shareable.org> <20080421080111.GD14446@one.firstfloor.org> <480CD9CD.70607@emc.com> <480CDBFD.30009@redhat.com> <480CE09D.4020402@emc.com> <20080421185849.GD20637@parisc-linux.org>
Reply-To: ric@emc.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, Theodore Tso <tytso@mit.edu>,
	Alexey Zaytsev <alexey.zaytsev@gmail.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Rik van Riel <riel@surriel.com>
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([128.222.32.20]:28555 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374AbYDUTUL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Apr 2008 15:20:11 -0400
In-Reply-To: <20080421185849.GD20637@parisc-linux.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Matthew Wilcox wrote:
> On Mon, Apr 21, 2008 at 02:44:45PM -0400, Ric Wheeler wrote:
>> Turning the drive write cache off is the default case for most RAID 
>> products (including our mid and high end arrays).
>>
>> I have not seen an issue with drives wearing out with either setting (cache 
>> disabled or enabled with barriers).
>>
>> The theory does make some sense, but does not map into my experience ;-)
> 
> To be fair though, the gigabytes of NVRAM on the array perform the job
> that the drive's cache would do on a lower-end system.

The population I deal with personally is a huge number of 1U Centera nodes, each 
of which has 4 high capacity ATA or S-ATA drives (no NVRAM). We run with 
barriers (and write cache) enabled and I have not seen anything that leads me to 
think that this is an issue.

One way to think about this is that even with barriers, relatively few 
operations actually turn into cache flushes (fsync's, journal syncs, unmounts?).

Another thing to keep in mind is that drives are constantly writing and moving 
heads - disabling write cache or doing a flush just adds an incremental number 
of writes/head movements.

Using barriers or disabling write cache matters only when you are doing a write 
intensive load, read intensive loads are not impacted (and random, cache miss 
reads will move the heads often).

I just don't see it being an issue for any normal user (laptop user or desktop 
user) since the write workload more people have is a small fraction of what we 
run into in production data centers.

Running your drives in a moderate way will probably help them last longer, but I 
am just not convinced that the write cache/barrier load makes much of a 
difference...

ric

