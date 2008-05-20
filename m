From: Bas van Schaik <bas@tuxes.nl>
Subject: Re: Scripting e2fsck: no errors, but still exit code 1 "FILE	SYSTEM
 WAS MODIFIED"
Date: Tue, 20 May 2008 23:19:36 +0200
Message-ID: <48334068.1090205@tuxes.nl>
References: <483006F1.6080008@tuxes.nl> <20080518122853.GB31413@mit.edu> <483056DC.4060108@tuxes.nl> <48316565.1040501@tuxes.nl> <20080520120953.GO15035@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pollux.sshunet.nl ([145.97.192.42]:35313 "EHLO
	pollux.sshunet.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760055AbYETVTl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 May 2008 17:19:41 -0400
In-Reply-To: <20080520120953.GO15035@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Mon, May 19, 2008 at 01:32:53PM +0200, Bas van Schaik wrote:
>   
>> Does this tell you anything?
>>
>>     
>
> Unfortunately comparing the two dumpe2fs outputs don't show anything
> interesting.  It did rule out a few cases where e2fsck can silently
> mark the filesystem has having been modified (setting the directory
> hash hint, moving the journal inode, which it does silently without
> informing the user --- and I should fix that one of these days; I'll
> create some bug reports to remind myself they need to be fixed), but I
> don't see why it happened for your case.
>
> It's definitely not normal; doing a journal replay does not cause fsck
> to exit with a non-zero status, if it didn't make any other changes.
> I just tested that with e2fsprogs 1.40.8 just in case something had
> gotten screwed up, and it worked as expected.
>   
Actually I also wouldn't expect e2fsck to do so. Maybe I'm overseeing
something really stupid, this is the bash code I'm running:
> e2fsck.static -f -y -v /dev/loop1 &> $TMPLOGFILE
> retcode="$?"
>
> (...)
>
> if [ ! "$retcode" = "0" ]; then
>         echo "e2fsck had nonzero exitcode $retcode, aborting!"
>         (...)
> fi


> I know how to debug it if you are really motiviated to get to the
> bottom of this.  It would involve running a modified e2fsck/e2fsprogs
> which changes ext2fs_mark_changed() and ext2fs_mark_super_dirty() to
> be real functions, and setting breakpoints in gdb so we can trap any
> calls made to those functions and dump out a stack backtrace, and then
> continuing the e2fsck run, and then reporting to me the stack
> backtraces where gdb trapped calls to ext2fs_mark_changed() and/or
> ext2fs_mark_super_dirty().
>   
To be honest, I'm currently trying to find out the cause of all these
filesystem corruptions. Maybe I'll try to sort this out later using gdb
and so on.

> Andreas is right though that if you are taking a proper snapshot, the
> disk really should be quiesced and no journal replay should be
> required at all.  That's how a devicemapper snapshot works in LVM ---
> so one good question to explore is how *are* you doing your snapshots.
Exactly my thoughts, but apparently something is wrong here too. Maybe I
should note that my journal commit interval is set to something like 5
or 10 seconds, is that relevant? Again a small snippet of bash
responsible for snapshotting:
> snapshot_stamp=`date +%Y%m%d-%H%M%S`
> lvcreate --snapshot --size 50G --name backups-snapshot-$snapshot_stamp
> $LV &> $TMPLOGFILE

This is not a weird way to snapshot, is it?

  -- Bas
