From: Nix <nix@esperi.org.uk>
Subject: Re: [PATCH] ext4: fix unjournaled inode bitmap modification
Date: Sun, 28 Oct 2012 13:59:17 +0000
Message-ID: <87mwz6hf4a.fsf@spindle.srvr.nix>
References: <87objupjlr.fsf@spindle.srvr.nix>
	<20121023013343.GB6370@fieldses.org> <87mwzdnuww.fsf@spindle.srvr.nix>
	<20121023143019.GA3040@fieldses.org>
	<874nllxi7e.fsf_-_@spindle.srvr.nix>
	<87pq48nbyz.fsf_-_@spindle.srvr.nix> <508CB35D.9080102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Ted Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:45461 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab2J1N7b (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 28 Oct 2012 09:59:31 -0400
In-Reply-To: <508CB35D.9080102@redhat.com> (Eric Sandeen's message of "Sat, 27
	Oct 2012 23:23:57 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 28 Oct 2012, Eric Sandeen outgrape:

> I've tested this by mounting with journal_checksum and
> running fsstress then dropping power; I've also tested by
> hacking DM to create snapshots w/o first quiescing, which
> allows me to test journal replay repeatedly w/o actually
> power-cycling the box.  Without the patch I hit a journal
> checksum error every time.  With this fix it survives
> many iterations.

Works for me too. Looks like you fixed it.


btw, I dug back through my old notes and found the reason I turned on
journal_async_commit in the first place, back in 2009. It's got nothing
to do with performance: I was trying to save power.

The server that's been having all this trouble has four WD GreenPower
disks. These are rightly maligned for leaving the way they save power
undocumented, changing it without notice, and having most of those
power-saving methods be extremely silly (e.g. complete spindowns, with a
nonresponsive disk for N seconds until it spins up again). But I was
lucky and got disks that actually did save power without being damaged.

By observing the machine's power draw I was able to guess that they spin
partway down (rumour says to ~2500rpm) after about eight seconds with no
activity at all, following which it takes a fairly large burst of
activity to get them to spin up again: they can service low loads
without spinning up.

Unfortunately back in 2009 ext4's journalling was preventing them from
ever spinning down, since even on idle rw-mounted filesystems it was
touching the disk with what blktrace said was something journal-related
once every five seconds, so the disks decided they should never spin
down, costing me about 10W of power. Now laptop_mode would have solved
this problem, but laptop_mode makes other changes that I didn't want
(e.g. changing the way dirty writeout is done so that all writeout is
lumpy: smooth dirty writeout is fine, I just don't want the disks
touched all the time when the system is actually idle).

So I turned on commit=30... and nothing changed, a steady pulse of
commits every five seconds. Only when I threw caution to the wind and
tried turning on journal_async_commit (even though the description of
its function seemed quite unrelated) did the commit rate slow to one
every 30s as the commit interval suggested.

I now suspect this was a bug, or multiple bugs, and I should have
reported it rather than flailing around to try to get things working --
but whatever the problem it has by now been fixed: journal committing is
now working rather better, one commit every 15s, even with async commit
turned off. (It is peculiar that I'm seeing one commit every 15s when I
asked for commit=30, but it's less often than once every 8s and that's
what matters to me.)

-- 
NULL && (void)
