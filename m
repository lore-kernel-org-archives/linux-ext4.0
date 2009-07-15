From: Adrian Hunter <adrian.hunter@nokia.com>
Subject: Re: [PATCH 1/2] HACK: ext3: mount fast even when recovering
Date: Wed, 15 Jul 2009 18:35:34 +0300
Message-ID: <4A5DF746.5010801@nokia.com>
References: <20090714140548.26116.2919.sendpatchset@ahunter-tower>	<20090714140554.26116.54779.sendpatchset@ahunter-tower> <20090714143449.cae624c8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "sct@redhat.com" <sct@redhat.com>,
	"adilger@sun.com" <adilger@sun.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:25687 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489AbZGOPf0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jul 2009 11:35:26 -0400
In-Reply-To: <20090714143449.cae624c8.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andrew Morton wrote:
> On Tue, 14 Jul 2009 17:05:54 +0300
> Adrian Hunter <adrian.hunter@nokia.com> wrote:
> 
>> Speed up ext3 recovery mount time by not sync'ing the
>> block device.  Instead place all dirty buffers into the
>> I/O queue and add a write barrier.  This ensures that
>> no subsequent write will reach the disk before all the
>> recovery writes, but that we do not have to wait for the
>> I/O.
>>
>> Note that ext3 reads sectors the correct way: through the
>> buffer cache, so there is no risk of reading old metadata.
> 
> hm.  The change seems reasonable to me.  afaict it leaves no timing
> windows during which another crash could muck things up.
> 
> As long as those write barriers actually work.  Do they?  For all
> conceivable devices and IO schedulers?

As far as I know I/O barriers work.  The I/O schedulers are forcibly
drained so they do not affect the barrier.  I am not sure about all
devices - I guess some device drivers might return errors if asked to
provide a barrier and they can't.

Our device is a MMC and does one I/O at a time, so hardware barriers
are not needed and are ignored.

> It would be useful if you could quantify the benefits please - some
> before-and-after timing results with both your funky hardware as well
> as regular old disks would suit.

I will send some examples.

> I'd suggest that if we're going to do this, we should aim to do it
> unconditionally - no mount option needed.  We could leave the option
> there for a while, for testing purposes (ie: we think the code might be
> buggy).  But the new feature should perhaps default to "on", and we
> plan to remove the mount option after a while.
> 
> Because there's no reason to retain the mount option in the long term.

