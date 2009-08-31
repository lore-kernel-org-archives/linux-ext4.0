From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
 document conditions when reliable operation is possible)
Date: Mon, 31 Aug 2009 09:15:27 -0400
Message-ID: <4A9BCCEF.7010402@redhat.com>
References: <200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com> <20090827221319.GA1601@ucw.cz> <4A9733C1.2070904@redhat.com> <20090828064449.GA27528@elf.ucw.cz> <20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz> <alpine.DEB.2.00.0908300550320.6822@asgard.lang.hm> <4A9A88B6.9050902@redhat.com> <4A9A9034.8000703@msgid.tls.msk.ru> <20090830163513.GA25899@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Michael Tokarev <mjt@tls.msk.ru>, david@lang.hm,
	Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
	NeilBrown <neilb@suse.de>, Rob Landley <rob@landley.net>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbZHaNOc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Aug 2009 09:14:32 -0400
In-Reply-To: <20090830163513.GA25899@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/30/2009 12:35 PM, Christoph Hellwig wrote:
> On Sun, Aug 30, 2009 at 06:44:04PM +0400, Michael Tokarev wrote:
>>> If you lose power with the write caches enabled on that same 5 drive
>>> RAID set, you could lose as much as 5 * 32MB of freshly written data on
>>>   a power loss (16-32MB write caches are common on s-ata disks these
>>> days).
>>
>> This is fundamentally wrong.  Many filesystems today use either barriers
>> or flushes (if barriers are not supported), and the times when disk drives
>> were lying to the OS that the cache got flushed are long gone.
>
> While most common filesystem do have barrier support it is:
>
>   - not actually enabled for the two most common filesystems
>   - the support for write barriers an cache flushing tends to be buggy
>     all over our software stack,
>

Or just missing - I think that MD5/6 simply drop the requests at present.

I wonder if it would be worth having MD probe for write cache enabled & warn if 
barriers are not supported?

>>> For MD5 (and MD6), you really must run with the write cache disabled
>>> until we get barriers to work for those configurations.
>>
>> I highly doubt barriers will ever be supported on anything but simple
>> raid1, because it's impossible to guarantee ordering across multiple
>> drives.  Well, it *is* possible to have write barriers with journalled
>> (and/or with battery-backed-cache) raid[456].
>>
>> Note that even if raid[456] does not support barriers, write cache
>> flushes still works.
>
> All currently working barrier implementations on Linux are built upon
> queue drains and cache flushes, plus sometimes setting the FUA bit.
>

