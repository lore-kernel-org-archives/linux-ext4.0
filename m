From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] HACK: ext3: mount fast even when recovering
Date: Tue, 14 Jul 2009 14:34:49 -0700
Message-ID: <20090714143449.cae624c8.akpm@linux-foundation.org>
References: <20090714140548.26116.2919.sendpatchset@ahunter-tower>
	<20090714140554.26116.54779.sendpatchset@ahunter-tower>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, adilger@sun.com, adrian.hunter@nokia.com,
	linux-ext4@vger.kernel.org, artem.bityutskiy@nokia.com
To: Adrian Hunter <adrian.hunter@nokia.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751663AbZGNVfa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Jul 2009 17:35:30 -0400
In-Reply-To: <20090714140554.26116.54779.sendpatchset@ahunter-tower>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 14 Jul 2009 17:05:54 +0300
Adrian Hunter <adrian.hunter@nokia.com> wrote:

> Speed up ext3 recovery mount time by not sync'ing the
> block device.  Instead place all dirty buffers into the
> I/O queue and add a write barrier.  This ensures that
> no subsequent write will reach the disk before all the
> recovery writes, but that we do not have to wait for the
> I/O.
> 
> Note that ext3 reads sectors the correct way: through the
> buffer cache, so there is no risk of reading old metadata.

hm.  The change seems reasonable to me.  afaict it leaves no timing
windows during which another crash could muck things up.

As long as those write barriers actually work.  Do they?  For all
conceivable devices and IO schedulers?

It would be useful if you could quantify the benefits please - some
before-and-after timing results with both your funky hardware as well
as regular old disks would suit.

I'd suggest that if we're going to do this, we should aim to do it
unconditionally - no mount option needed.  We could leave the option
there for a while, for testing purposes (ie: we think the code might be
buggy).  But the new feature should perhaps default to "on", and we
plan to remove the mount option after a while.

Because there's no reason to retain the mount option in the long term.

