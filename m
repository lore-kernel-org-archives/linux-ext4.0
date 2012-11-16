From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 settings in an embedded system
Date: Fri, 16 Nov 2012 10:58:26 -0600
Message-ID: <50A670B2.4080603@redhat.com>
References: <C0489DC3A08C21449F8FE865472DC75204876ACE@BUDMLVEM03.e2k.ad.ge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Ohlsson, Fredrik (GE Healthcare, consultant)"
	<Fredrik.Ohlsson@ge.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816Ab2KPQ6d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Nov 2012 11:58:33 -0500
In-Reply-To: <C0489DC3A08C21449F8FE865472DC75204876ACE@BUDMLVEM03.e2k.ad.ge.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/16/12 10:18 AM, Ohlsson, Fredrik (GE Healthcare, consultant) wrote:
> Thank you very much for your helpful response and answers.
> 
> I would like to describe some background for our embedded system. The
> system has recently been upgraded, before the upgrade we did not see
> "filesystem" related problems. Before the upgrade we used  another
> filesystem, kernel and IDE Flash Disk(kernel 2.6.12 kernel, reiserfs and
> a smaller 256 MB IDE Flash Disk).  Today we have kernel 2.6.32,
> ext4(default options) and a 1GB Transend TS1GDOM44H-S IDE Flash Disk.
> We have a very low IO intensity towards the flash disk and low
> requirements on the filesystem performance. 
> 
> In our case with the file of size 0 bytes. We use a bash shell script to
> upgrade our application. The shell script calls the program "tar" and
> tar overwrites/recreates  our application bin file. After some minutes
> the power is cut and our bin file had the new size 0 bytes when the
> system came up again . This particular case was solved by adding a sync
> in the end of our upgrade shell script. I still don't understand why the
> data is not committed to the disk after several minutes? Even if tar
> leaves the file truncated tar must have closed the file and ext4 would
> have done an implicit write-back?

I would have expected all data to make it out after several minutes,
yes (how many is several?)  Background writeout kicks off every
30s by default, I would have expected that after at most a couple of those
cycles you would have seen it all make it to disk.  To investigate, it
might be worth tracing the system to see whether or not it is pushing data
out when the script completes (iostat might be simplest, or blktrace).

I'm curious, did the sync at the end of the script take a very long
time to complete?

> We are worried that this will happen again where we use programs not
> written by ourselves. Will the nodelalloc option solve this behavior?

Doubtful.  For starters, I'd argue that nodelalloc is a less tested
and therefore potentially more bug-prone path in ext4.  

> If I understand you right the corrupted journal superblock (inode #8) is
> most probably a result of a problem in the IDE Flash Disk.  

ok so you got:

> Superblock has an invalid journal (inode 8).
> Clear? yes

after this, of course, fsck is at a disadvantage for recovering the fs
and finds many more errors.  However, things like bad resize inodes
& bad acl index inodes are a bit more suprising; those were written
at mkfs time.

What version of e2fsprogs was this?

You could get the journal message for a few reasons, unfortunately e2fsck
doesn't say which one it was.  An e2image (or maybe just raw dd)
of the fs prior to the repair would offer some clues to someone with
time to investigate.

> I have
> attached dumpe2fs.output from this problem. I booted the system from a
> usb-drive and the filesystem could be repaired by e2fsck, but this is
> not something the customer can do, we have to replace units like this.
> The Transend TS1GDOM44H-S IDE Flash Disk is intended for demanding
> embedded systems that require reliability, I guess it could still be the
> part creating this problem. 
> 
> I think you are saying that ext4 should work fine in our setup were we
> have regular power-cuts if we use sync/fsync and applies the following
> settings:
> -barrier, which we already use by default (Can't see barrier in the
> attached dumpe2fs.output thou).

it's just runtime behavior, so you wouldn't see it there.

> -nodelalloc

I'm a little skeptical of that.  I think you need to get to the root
cause before you start turning more knobs.  I guess I am most skeptical
about the storage, for starters.

I can't tell if the transcend device has a cache or not; presumably
the flash controller does.  I have no idea if it responds to cache flush
requests, or not.

If you look at dmesg, you probably get something like:
[sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

but what the device actually does internally - who knows.

I wonder if a test like this would be interesting:

* Boot system from USB.
* Write a unique pattern directly to the transcend block device, not through the fs.
* Use something like lmdd or xfs_io or some tool which will write a pattern, not
just 0s.
* Wait a minute or two, then cut power (watch iostat maybe to see when all IO is done)
* boot up again and check the pattern

If the pattern is bad, try it again (with a different pattern) and issue
sync prior to the power cut.  See if that behaves differently.

fsync (and, I think, sys_sync) will issue cache flushes to the storage.
Simple writeback won't, AFAIK.  So it'd be interesting to see if data
is being lost inside the device when it loses power; the above test might
be decent to check that.

I'm half tempted to find one of these devices & test it myself ;)

-Eric


> You also advise us to implement or own power-cut tests.
> 
> Are there more settings that could be to our favor, like
> journal_checksum? Tune2fs data=journal?
> 
> Best Regards
> 
> Fredrik Ohlsson
> Software Engineer
> 
> 
> 
> 
> 
> 

