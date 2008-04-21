From: Ric Wheeler <ric@emc.com>
Subject: Re: Mentor for a GSoC application wanted (Online ext2/3 filesystem
 checker)
Date: Mon, 21 Apr 2008 14:15:41 -0400
Message-ID: <480CD9CD.70607@emc.com>
References: <f19298770804180720w2e72b821j95b709c1dd1b1c25@mail.gmail.com> <20080419012952.GE25797@mit.edu> <f19298770804190244y5d6a8502p39f98d1c420135a@mail.gmail.com> <20080419185603.GA30449@mit.edu> <480A42F6.2030005@redhat.com> <20080419220432.GB30449@mit.edu> <87iqyc85q7.fsf@basil.nowhere.org> <20080420234241.GB23292@shareable.org> <20080421080111.GD14446@one.firstfloor.org>
Reply-To: ric@emc.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Alexey Zaytsev <alexey.zaytsev@gmail.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Rik van Riel <riel@surriel.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([128.222.32.20]:13655 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbYDUS0m (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Apr 2008 14:26:42 -0400
In-Reply-To: <20080421080111.GD14446@one.firstfloor.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



Andi Kleen wrote:
> On Mon, Apr 21, 2008 at 12:42:42AM +0100, Jamie Lokier wrote:
>> Andi Kleen wrote:
>>> [LVM] always disables barriers if you don't apply a so far unmerged
>>> patch that enables them in some special circumstances (only single
>>> backing device)
>> (I continue to be surprised at the un-safety of Linux fsync)
> 
> Note barrier less does not necessarily always mean unsafe fsync,
> it just often means that.
> 
> Also surprisingly lot more syncs or write cache off tend to lower the MTBF 
> of your disk significantly, so "unsafer" fsync might actually be more safe
> for your unbackuped data.
> 

Hi Andi,

Where did you get this data?

I have never heard that using more barrier operations lowers the reliability or 
the MTBF of a drive and I look at a fairly huge population when doing this ;-)

ric



