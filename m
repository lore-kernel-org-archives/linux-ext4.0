From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: wishful thinking about atomic, multi-sector or full MD stripe
 width, writes in storage
Date: Thu, 03 Sep 2009 11:09:43 -0400
Message-ID: <4A9FDC37.5060004@redhat.com>
References: <20090828064449.GA27528@elf.ucw.cz>	<20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz>	<alpine.DEB.2.00.0908300550320.6822@asgard.lang.hm>	<4A9A88B6.9050902@redhat.com> <4A9A9034.8000703@msgid.tls.msk.ru>	<20090830163513.GA25899@infradead.org> <4A9BCCEF.7010402@redhat.com>	<20090831131626.GA17325@infradead.org> <4A9BCDFE.50008@rtr.ca>	<20090831132139.GA5425@infradead.org> <4A9F230F.40707@redhat.com>	<m3ab1cp9ii.fsf@intrepid.localdomain> <4A9FA5F2.9090704@redhat.com>	<m3ljkwnoct.fsf@intrepid.localdomain> <4A9FC9B3.1080809@redhat.com>	<m3ab1cnn7y.fsf@intrepid.localdomain> <4A9FCF6B.1080704@redhat.com> <823a74w1cg.fsf@mid.bfk.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Hellwig <hch@infradead.org>, Mark Lord <lkml@rtr.ca>,
	Michael Tokarev <mjt@tls.msk.ru>, david@lang.hm,
	Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
	NeilBrown <neilb@suse.de>, Rob Landley <rob@landley.net>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Florian Weimer <fweimer@bfk.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328AbZICPIy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Sep 2009 11:08:54 -0400
In-Reply-To: <823a74w1cg.fsf@mid.bfk.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/03/2009 10:26 AM, Florian Weimer wrote:
> * Ric Wheeler:
>
>> Note that even without MD raid, the file system issues IO's in file
>> system block size (4096 bytes normally) and most commodity storage
>> devices use a 512  byte sector size which means that we have to update
>> 8 512b sectors.
>
> Database software often attempts to deal with this phenomenon
> (sometimes called "torn page writes").  For example, you can make sure
> that the first time you write to a database page, you keep a full copy
> in your transaction log.  If the machine crashes, the log is replayed,
> first completely overwriting the partially-written page.  Only after
> that, you can perform logical/incremental logging.
>
> The log itself has to be protected with a different mechanism, so that
> you don't try to replay bad data.  But you haven't comitted to this
> data yet, so it is fine to skip bad records.

Yes - databases worry a lot about this. Another technique that they tend to use 
is to have state bits at the beginning and end of their logical pages. For 
example, the first byte and last byte toggle together from 1 to 0 to 1 to 0 as 
you update.

If the bits don't match, that is a quick level indication of a torn write.

Even with the above scheme, you can still have data loss of course - you just 
need an IO error in the log and in your db table that was recently updated. Not 
entirely unlikely, especially if you use write cache enabled storage and don't 
flush that cache :-)

>
> Therefore, sub-page corruption is a fundamentally different issue from
> super-page corruption.

We have to be careful to keep our terms clear since the DB pages are (usually) 
larger than the FS block size which in turn is larger than non-RAID storage 
sector size. At the FS level, we send down multiples of fs blocks (not 
blocked/aligned at RAID stripe levels, etc).

In any case, we can get sub-FS block level "torn writes" even with a local S-ATA 
drive in edge conditions.


>
> BTW, older textbooks will tell you that mirroring requires that you
> read from two copies of the data and compare it (and have some sort of
> tie breaker if you need availability).  And you also have to re-read
> data you've just written to disk, to make sure it's actually there and
> hit the expected sectors.  We can't even do this anymore, thanks to
> disk caches.  And it doesn't seem to be necessary in most cases.
>

We can do something like this with the built in RAID in btrfs. If you detect an 
IO error (or bad checksum) on a read, btrfs knows how to request/grab another copy.

Also note that the SCSI T10 DIF/DIX has baked in support for applications to 
layer on extra data integrity (look for MKP's slide decks). This is really neat 
since you can intercept bad IO's on the way down and prevent overwriting good data.

ric

