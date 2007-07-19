From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsck bogus error report on orphan-list
Date: Thu, 19 Jul 2007 12:55:10 -0400
Message-ID: <20070719165510.GB14815@thunk.org>
References: <873azkl7x4.wl%ryoichi@me.sony.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com,
	Tim Bird <tim.bird@am.sony.com>
To: Ryoichi.Kato@jp.sony.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:57092 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756401AbXGSQzV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jul 2007 12:55:21 -0400
Content-Disposition: inline
In-Reply-To: <873azkl7x4.wl%ryoichi@me.sony.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 20, 2007 at 12:39:19AM +0900, Ryoichi.Kato@jp.sony.com wrote:
> Hi,
> I hit a problem of ext3/e2fsck on orphan-list handling.

Wow, I'm rather impressed that this was sufficient for a presentation
at a conference.  You could have just sent me e-mail.  :-)

> 
> The following sequence produces bogus e2fsck error report:
> "/dev/XXX: Inodes that were part of a corrupted orphan linked list found."
> 
>    1. Delete a file in an ext3 filesystem in early 1970

Dare I ask *why* the system clock was set in the 1970's?  Umm... don't
do that.

>    2. Set RTC to 2007, and then mount/write the filesystem.

There is code that detects when the time is set back in the 1970's
(normally due to a bad clock battery) and thus disables this
particular check.  So it only triggers when the clock was previously
bad, and is now good.

> This is because i_dtime (deletion time) field is also used as a
> next-pointer of an orphan-list (stores inode number rather than time),
> and e2fsck handles it improperly.
> You will have the same probrem if you run e2fsck on an ext3
> filesystem with 1.2+ billion of files in it. (Is it possible?)

It's *possible* but in practice no one does it, because the fsck times
if the filesystem had that many inodes would be pretty scary --- and
there will always be times when you must run fsck --- for example, if
you have hardware induced corruption and you need to salvage the
filesystem because your backups had failed (or you weren't doing
backups :-).


The net is that the check is basically a sanity check to make any bugs
in the orphaned list handling would be discovered, although it can
also trigger if there is block device corruption where part of the
inode table is corrupted.  I had added hueristics that for most people
meant that it never triggered, so I'm surprised that it actually did
in your environment.  Still, if it did, the easist thing to do is to
just turn it off.

We haven't had bugs in that area of the code for a long time, and if
it's actually causing you trouble, the simplest thing to do is to just
comment out the check.  That, or just make sure that the time is
correct, which is generally a good idea anyway.  Hmm, maybe I should
add an e2fsck configuration parameter:

[options]
	unreliable_system_clock = 1

Which disables various hueristics that assumes that the system clock
can be trusted.

	       	  	      	   		 - Ted
