From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4.
Date: Mon, 26 Apr 2010 13:52:42 -0400
Message-ID: <4BD5D2EA.1070008@redhat.com>
References: <1271674527-2977-2-git-send-email-lczerner@redhat.com> <1271674527-2977-3-git-send-email-lczerner@redhat.com> <r2k87f94c371004201421se796c0ekbae28495e62a9eb7@mail.gmail.com> <4BCE6243.5010209@teksavvy.com> <4BCE66C5.3060906@redhat.com> <v2w87f94c371004211159ue3a48923u6a543e8090dcdfa6@mail.gmail.com> <4BCF4C53.3010608@redhat.com> <x49zl0w1uhh.fsf@segfault.boston.devel.redhat.com> <k2y87f94c371004211344xfd17387fwc62432d022145376@mail.gmail.com> <alpine.LFD.2.00.1004230944070.2814@localhost> <20100426165527.GB21179@atrey.karlin.mff.cuni.cz> <alpine.LFD.2.00.1004261903260.2797@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Greg Freemyer <greg.freemyer@gmail.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Mark Lord <kernel@teksavvy.com>, linux-ext4@vger.kernel.org,
	Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab0DZRtO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Apr 2010 13:49:14 -0400
In-Reply-To: <alpine.LFD.2.00.1004261903260.2797@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/26/2010 01:46 PM, Lukas Czerner wrote:
> On Mon, 26 Apr 2010, Jan Kara wrote:
>
>>> On Wed, 21 Apr 2010, Greg Freemyer wrote:
>>> And also, currently I am rewriting the patch do use rbtree instead of the
>>> bitmap, because there were some concerns of memory consumption. It is a
>>> question whether or not the rbtree will be more memory friendly.
>>> Generally I think that in most "normal" cases it will, but there are some
>>> extreme scenarios, where the rbtree will be much worse. Any comment on
>>> this ?
>>    I see two possible improvements here:
>> a) At a cost of some code complexity, you can bound the worst case by combining
>> RB-trees with bitmaps. The basic idea is that when space to TRIM gets too
>> fragmented (memory to keep to-TRIM blocks in RB-tree for a given group exceeds
>> the memory needed to keep it in a bitmap), you convert RB-tree for a
>> problematic group to a bitmap and attach it to an appropriate RB-node. If you
>> track with a bitmap also a number of to-TRIM extents in the bitmap, you can
>> also decide whether it's benefitial to switch back to an RB-tree.
>
> This sounds like a good idea, but I wonder if it is worth it :
>   1. The tree will have very short life, because with next ioctl all
>   stored deleted extents will be trimmed and removed from the tree.
>   2. Also note, that the longer it lives the less fragmented it possibly
>   became.
>   3. I do not expect, that deleted ranges can be too fragmented, and
>   even if it is, it will be probably merged into one big extent very
>   soon.
>
>>
>> b) Another idea might be: When to-TRIM space is fragmented (again, let's say
>> in some block group), there's not much point in sending tiny trim commands
>> anyway (at least that's what I've understood from this discussion). So you
>> might as well stop maintaining information which blocks we need to trim
>> for that group. When the situation gets better, you can always walk block
>> bitmap and issue trim commands. You might even trigger this rescan from
>> kernel - if you'd maintain number of free block extents for each block group
>> (which is rather easy), you could trigger the bitmap rescan and trim as soon
>> as ratio number of free blocks / number of extents gets above a reasonable
>> threshold.
>>
>> 								Honza
>>
>
> In what I am preparing now, I simple ignore small extents, which would
> be created by splitting the deleted extent into smaller pieces by chunks
> of used blocks. This, in my opinion, will prevent the fragmentation,
> which otherwise may occur in the longer term (between ioctl calls).
>
> Thanks for suggestions.
> -Lukas

I am not convinced that ignoring small extents is a good idea. Remember that for 
SSD's specifically, they remap *everything* internally so our "fragmentation" 
set of small spaces could be useful for them.

That does not mean that we should not try to send larger requests down to the 
target device which is always a good idea I think :-)

ric

