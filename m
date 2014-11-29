From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Filesystem corruption on Synology iSCSI LUN
Date: Fri, 28 Nov 2014 22:04:21 -0500
Message-ID: <20141129030421.GA4362@thunk.org>
References: <CAOE-YndzkhbAPjc=bBqioQkjbdbE2dKaq8AnrZBcLxDuupfg-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Villa <villa@vansid.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57658 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbaK2DE2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Nov 2014 22:04:28 -0500
Content-Disposition: inline
In-Reply-To: <CAOE-YndzkhbAPjc=bBqioQkjbdbE2dKaq8AnrZBcLxDuupfg-w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 28, 2014 at 09:32:21PM +0000, Villa wrote:
> The problem is occurring with an iSCSI LUN presented to an Ubuntu
> 12.04 x64 Linux system via a Synology DS1513 using DSM version 5.1.
> This filesystem has been running flawlessly for quite some time.  It
> is on UPS and no power outages or unscheduled shutdowns have taken
> place lately.  I very recently upgraded from DSM 5.0 to 5.1, and
> roughly after this I started noticing the filesystem corruption
> problem.  However, it is far too simplistic to immediately assume that
> DSM 5.1 is the culprit, and instead I am trying to find out what else
> may be causing the issue.

Unfortunately, I suspect all we can say is that DSM 5.1 is probably
the issue.

> [126085.888075] sd 9:0:0:0: [sdd]  Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE
> [126085.888081] sd 9:0:0:0: [sdd]  Sense Key : Illegal Request [current]
> [126085.888086] sd 9:0:0:0: [sdd]  <<vendor>> ASC=0x80 ASCQ=0x0ASC=0x80 ASCQ=0x0
> [126085.888093] sd 9:0:0:0: [sdd] CDB: Write(16): 8a 00 00 00 00 01 e1
> c0 95 c0 00 00 00 08 00 00
> [126085.888105] end_request: I/O error, dev sdd, sector 8082462144
> [126085.890808] Buffer I/O error on device sdd1, logical block 1010307512
> [126085.893509] lost page write due to I/O error on sdd1

This I/O error is coming from the SCSI stack, and indicates something
is going very wrong at the iSCSI target or iSCSI initiator.  Until you
can get this resolved, it's hopeless to try to look at anything at the
file system layer.  You always have to fix the problems lowest on the
storage stack before moving upwards...

> I know this list doesn't exist to fix my personal problems and I
> understand that this is a lot (especially for the first post in the
> thread), but I'd like to know if any of you think this filesystem is
> salvageable and if it can be permanently fixed.  Luckily this is a
> backup LUN and all of the data is safely elsewhere, so I can
> "experiment" if necessary.  I wonder if this is some sort of
> kernel/module problem.  If anyone can help, I'd greatly appreciate it.
> Let me know if you need more info.

The main thing is can you get the bits off of the iSCSI volume
successfully.  If you can, there is a high probability that the file
system can be fixed, with hopefully minor amounts of data loss.  But
given the malfunctioning at the SCSI layer, any attempt to try to
"fix" things on at the file system level can very easily make things
much worse.

Cheers,

						- Ted
