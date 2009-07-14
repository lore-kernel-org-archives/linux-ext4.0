From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/2] HACK: ext3: mount fast even when recovering
Date: Tue, 14 Jul 2009 16:46:37 -0500
Message-ID: <4A5CFCBD.70305@redhat.com>
References: <20090714140548.26116.2919.sendpatchset@ahunter-tower>	<20090714140554.26116.54779.sendpatchset@ahunter-tower> <20090714143449.cae624c8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Adrian Hunter <adrian.hunter@nokia.com>, sct@redhat.com,
	adilger@sun.com, linux-ext4@vger.kernel.org,
	artem.bityutskiy@nokia.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46793 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401AbZGNVrO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Jul 2009 17:47:14 -0400
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

Good point .... for many devices the barriers will fail, but by then I
think this code has already moved on, right?  (And some devices will
lie, but at that point, oh well).

You could do a test barrier IO at the start, and keep the old behavior
if it fails, perhaps?

(whoa, can barriers make something faster?  who woulda thunk it)

-Eric
