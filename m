From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: journal has aborted
Date: Thu, 3 Jul 2014 10:46:46 -0400
Message-ID: <20140703144646.GD5216@thunk.org>
References: <CAFnufp3TepsxxX8=WCJ0V=3TELP0rWR-NxFukSL8X=qS1q6Eew@mail.gmail.com>
 <20140701082619.1ac77f1d@archvile>
 <20140701084206.GG9743@birch.djwong.org>
 <CAFnufp2TPSyZe4NUSTVeSWuSDwsCLHDogBvAWV4_+JaQFRrw-w@mail.gmail.com>
 <20140703134338.GE2374@thunk.org>
 <20140703161551.5fd13245@archvile>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matteo Croce <technoboy85@gmail.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: David Jander <david@protonic.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43326 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755356AbaGCOqy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Jul 2014 10:46:54 -0400
Content-Disposition: inline
In-Reply-To: <20140703161551.5fd13245@archvile>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 03, 2014 at 04:15:51PM +0200, David Jander wrote:
> 
> Could (a) be caused by a bug in the mmc subsystem or in the MMC peripheral
> driver? Can you explain why I don't see any problems with EXT3?

It's possible.  I seem to recall a bug related to the mmc subsystem
that was causing file system corruption after power failure across
multiple file systems --- xfs, and reiserfs were mentioned, as I
recall.  I *thought* the problem was fixed, and then backported if
necessary.  Hmm...  Here's where that bug was reported:

	https://lkml.org/lkml/2014/6/12/19

... but I havne't found the fix yet.

Now, this would be quite different from the bug Matteo was seeing,
since he has a Samsung SSD which is *not* a MMC device.

As far as why you aren't seeing a problem with ext3, it doesn't have
the same sort of paranoid checks that ext4 has, so it's less likely to
catch certain problems at runtime.  If you ran fsck on an ext3 file
system, and it was corrupt, of course that that would show th
eproblem.

> I left the system running (it started from a dirty EXT4 partition), and I am
> seen the following error pop up after a few minutes. The system is not doing
> much (some syslog activity maybe, but not much more):
> 
> [  303.072983] EXT4-fs (mmcblk1p2): error count: 4
> [  303.077558] EXT4-fs (mmcblk1p2): initial error at 1404216838: ext4_mb_generate_buddy:756
> [  303.085690] EXT4-fs (mmcblk1p2): last error at 1404388969: ext4_mb_generate_buddy:757
> 
> What does that mean?

This means that file sysgtem has errors that weren't fixed after an
fsck.  The first error occured at:

% date -d @1404216838
Tue Jul  1 08:13:58 EDT 2014

and the most recent error occured at:

% date -d @1404388969
Thu Jul  3 08:02:49 EDT 2014

The error count information should have gotten cleared by e2fsck, so
long as you are using a version of e2fsck newer than 1.41.13, released
in December 2010.

So if it has not been cleared, and you've since rebooted, that's an
indication that e2fsck isn't getting run at boot.  If you haven't
rebooted yet, then about once a day, you'll see that message in your
syslog.  It's there so that people know that their file system has
been problems, and they *really* should get it unmounted and checked
before they lose more data....

The reason why I added this is because there were systems where people
weren't noticing that they had been running with a corrupted file
systems for days, weeks, months, etc., and then would complain that
they had lost lots of data.  By putting something in the logs once a
day, hopefully it would reduce the chance of this happening.  (And if
they had configured their file system to panic when an error was
detected, via "tune2fs -e panic /dev/sdXX", so long as their init
scripts were properly configured, the file system should have been
repaired after the reboot.)

					- Ted
