From: Ric Wheeler <ric@emc.com>
Subject: Re: Mentor for a GSoC application wanted (Online ext2/3 filesystem
 checker)
Date: Mon, 21 Apr 2008 14:44:45 -0400
Message-ID: <480CE09D.4020402@emc.com>
References: <f19298770804180720w2e72b821j95b709c1dd1b1c25@mail.gmail.com> <20080419012952.GE25797@mit.edu> <f19298770804190244y5d6a8502p39f98d1c420135a@mail.gmail.com> <20080419185603.GA30449@mit.edu> <480A42F6.2030005@redhat.com> <20080419220432.GB30449@mit.edu> <87iqyc85q7.fsf@basil.nowhere.org> <20080420234241.GB23292@shareable.org> <20080421080111.GD14446@one.firstfloor.org> <480CD9CD.70607@emc.com> <480CDBFD.30009@redhat.com>
Reply-To: ric@emc.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andi Kleen <andi@firstfloor.org>, Theodore Tso <tytso@mit.edu>,
	Alexey Zaytsev <alexey.zaytsev@gmail.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Rik van Riel <riel@surriel.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([128.222.32.20]:21231 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758606AbYDUSxR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Apr 2008 14:53:17 -0400
In-Reply-To: <480CDBFD.30009@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Eric Sandeen wrote:
> Ric Wheeler wrote:
>> Andi Kleen wrote:
>>> On Mon, Apr 21, 2008 at 12:42:42AM +0100, Jamie Lokier wrote:
>>>> Andi Kleen wrote:
>>>>> [LVM] always disables barriers if you don't apply a so far unmerged
>>>>> patch that enables them in some special circumstances (only single
>>>>> backing device)
>>>> (I continue to be surprised at the un-safety of Linux fsync)
>>> Note barrier less does not necessarily always mean unsafe fsync,
>>> it just often means that.
>>>
>>> Also surprisingly lot more syncs or write cache off tend to lower the MTBF 
>>> of your disk significantly, so "unsafer" fsync might actually be more safe
>>> for your unbackuped data.
>>>
>> Hi Andi,
>>
>> Where did you get this data?
>>
>> I have never heard that using more barrier operations lowers the reliability or 
>> the MTBF of a drive and I look at a fairly huge population when doing this ;-)
> 
> Ric, what about the other part - turning write cache off?  I've also
> heard it suggested that this might hurt drive lifespan, and it sorta
> makes sense, I assume it keeps the head working harder...
> 
> -Eric

Turning the drive write cache off is the default case for most RAID products 
(including our mid and high end arrays).

I have not seen an issue with drives wearing out with either setting (cache 
disabled or enabled with barriers).

The theory does make some sense, but does not map into my experience ;-)

ric
