From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: resize2fs memory footprint
Date: Mon, 15 Feb 2010 07:26:35 -0500
Message-ID: <4B793D7B.1020907@redhat.com>
References: <4B78FE19.5040208@miray.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Ulrich Bauer <u.bauer@miray.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754879Ab0BOM0m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Feb 2010 07:26:42 -0500
In-Reply-To: <4B78FE19.5040208@miray.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/15/2010 02:56 AM, Ulrich Bauer wrote:
> We develop a deployment solution that is able to resize up to 16 
> drives at a time. While testing, we observed that resize2fs' memory 
> usage scales with the volume size. Even in case of relatively small 
> file systems of about 1.5TB, resize2fs would need about 135MB of 
> application memory. Wit 16 large drives, one would need some GB of RAM 
> just to resize the drives. Our guess is that this is related to the 
> super block group bitmaps of ext4 that are held in memory to 
> manipulate/zero their on-disc counterparts. A quick observation of 
> resize2fs' source revealed that the latest git tree already has a 
> bitmap interface that allows for different implementations of the 
> bitmap manipulation algorithms. To solve the memory usage problem, two 
> solutions seem to be feasible:
>
> - For the huge bitmaps that already exist on the volume, we could 
> create a disk-backed bitmap implementation that would only cache a 
> small working set of the entire bitmap. My guess is that we can 
> implement this efficiently enough to not loose too much performance.
> - For the all-zero bitmaps, we could implement a dummy bitmap that 
> forces all bits to zero and spawns a real bitmap as soon as any bits 
> are set to one. An alternative would be a tree-based aproach that 
> works especially well when the bitmap is just sparsely set.
>
> I'd be glad if one of the developers involved in the ext4 development 
> could tell me if these thoughts make sense and if yes, are there any 
> plans to incorporate these approaches into the ext library anytime 
> soon or does it make sense if I would have a deeper look into these 
> issues and implement them? Thanks in advance for any thoughts about this.
>
> Sincerely
> U. Bauer
>

This is a similar problem to the amount of memory consumed during fsck - 
Ted has been thinking/designing ways to use memory savings encodings to 
minimize this but we have not had anyone step forward to push that work 
forward...

For now, you unfortunately will have to work around this by resizing 
your file systems one at a time or buy lots of memory.

Thanks!

Ric

