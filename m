From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
Date: Fri, 03 Dec 2010 13:24:59 -0500
Message-ID: <4CF935FB.5010903@gmail.com>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com> <20101118130630.GJ6178@parisc-linux.org> <20101118134804.GN5618@dhcp231-156.rdu.redhat.com> <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org> <1290100750.3041.72.camel@mulgrave.site> <1290102616-sup-7212@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: James Bottomley <james.bottomley@suse.de>,
	Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	sandeen <sandeen@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35247 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab0LCSZH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Dec 2010 13:25:07 -0500
In-Reply-To: <1290102616-sup-7212@think>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/18/2010 12:55 PM, Chris Mason wrote:
> Excerpts from James Bottomley's message of 2010-11-18 12:19:10 -0500:
>> On Thu, 2010-11-18 at 09:29 -0500, Christoph Hellwig wrote:
>>> On Thu, Nov 18, 2010 at 07:19:58AM -0700, Matthew Wilcox wrote:
>>>> I guess I was assuming that, on receiving a FALLOC_FL_PUNCH_HOLE, a
>>>> filesystem that was TRIM-aware would pass that information down to the
>>>> block device that it's mounted on.  I strongly feel that we shouldn't
>>>> have two interfaces to do essentially the same thing.
>>>>
>>>> I guess I'm saying that you're going to have to learn about TRIM :-)
>>> Did you actually look Lukas FITRIM code (not the slight reordering here,
>>> but the original one).  It's the ext4 version of the batched discard
>>> model, that is a userspace ioctl to discard free space in the
>>> filesystem.
>>>
>>> hole punching will free the blocks into the free space pool.  If you do
>>> online discard it will also get discarded, but a filesystem that has
>>> online discard enabled doesn't need FITRIM.
>> Not stepping into the debate: I'm happy to see punch go to the mapping
>> data and FITRIM pick it up later.
>>
>> However, I think it's time to question whether we actually still want to
>> allow online discard at all.  Most of the benchmarks show it to be a net
>> lose to almost everything (either SSD or Thinly Provisioned arrays), so
>> it's become an "enable this to degrade performance" option with no
>> upside.
> I think we want to keep it.  In general we've (except for hch) spent
> almost zero time actually tuning online discard, and the benchmarking
> needs to be redone with the shiny new barrier code.
>
> -chris
>

Very belated response - I agree that we should keep the online discard support 
in (but off by default).

Some of the devices we have tested perform well with it and I expect that 
hardware vendors will get better now that we have the support for them to test with.

Ric


