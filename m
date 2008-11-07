From: Andreas Dilger <adilger@sun.com>
Subject: Re: "tune2fs -I 256" runtime---can it be interrupted safely?
Date: Fri, 07 Nov 2008 14:16:43 -0700
Message-ID: <20081107211643.GB3184@webber.adilger.int>
References: <20081101151002.4ed9be99@zest> <20081101194617.0dc131c3@zest>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Michael B. Trausch" <mike@trausch.us>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:41824 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbYKGVQv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2008 16:16:51 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mA7LGj1S028560
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 13:16:45 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K9Z00701F3O1C00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 07 Nov 2008 13:16:45 -0800 (PST)
In-reply-to: <20081101194617.0dc131c3@zest>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 01, 2008  19:46 -0400, Michael B. Trausch wrote:
> On Sat, 1 Nov 2008 15:10:02 -0400
> "Michael B. Trausch" <mike@trausch.us> wrote:
> > I converted my home directory to ext4 without issue and so I
> > (stupidly, I admit) did not take a backup of this 250 GB drive's
> > contents before I started the conversion process.  Oops.  Lesson
> > learned.  My thinking at this point is that it would take _far_ less
> > time to interrupt, backup, and just use mkfs.ext4 on the drive and
> > then restore (about 2 hours instead of an unknown quantity which is
> > already nearing 13 hours).
> 
> At 18:01:34 (after 15 hours and change) I decided to give it up and
> sent tune2fs a SIGINT.  It happily aborted, and fsck appears to have
> fixed whatever inconsistencies were introduced during the tune2fs run
> and the files on the volume appear to be perfectly intact.

That is good news.  I would have worried that interrupting this operation
isn't very safe, because it is moving some core filesystem data around.

> Am going to go the route of simply pulling the data off and using
> mkfs.ext4 to create a new filesystem on the device.  But, I am still
> curious as to why this would run for so long.  Some volume statistics,
> in case they may be of help in trying to determine why this process was
> running for so long; I don't even know how much longer it would have
> run for.

> Inode size:               128

It looks like it did not finish the inode resize operation, for whatever
reason.

If you have time, after the backup is done could you please re-try the
"tune2fs -I 256" operation and let it go for a while, then "ltrace -p {pid}"
on the process from another window to see what it is doing (if anything).
You may need to have the "e2fsprogs-debuginfo" RPM installed to get useful
data there.

After grabbing some of the data with ltrace, also run "strace -p {pid}"
to get disk IO information, and finally "gdb -p {pid}" and grab a
stack trace with "bt", let it continue for a few seconds with "c", and
then CTRL-C again and grab another stack trace with "bt".

I'm assuming the code shouldn't actually have taken 13h to complete, but
is instead confused about something in the filesystem and is looping.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

