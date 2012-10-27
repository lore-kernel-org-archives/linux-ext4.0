From: Nix <nix@esperi.org.uk>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3 (and other stable branches?)
Date: Sat, 27 Oct 2012 22:40:45 +0100
Message-ID: <87txtfy4o2.fsf@spindle.srvr.nix>
References: <874nllxi7e.fsf_-_@spindle.srvr.nix>
	<87pq48nbyz.fsf_-_@spindle.srvr.nix> <508AF3FA.4020506@redhat.com>
	<87wqydx957.fsf@spindle.srvr.nix> <20121026205618.GC8614@thunk.org>
	<87objpx84k.fsf@spindle.srvr.nix> <20121026211542.GE8614@thunk.org>
	<87haphx76u.fsf@spindle.srvr.nix> <20121027002258.GB31030@thunk.org>
	<873910xevu.fsf@spindle.srvr.nix> <20121027175534.GA7783@thunk.org>
	<87fw4zzra3.fsf@spindle.srvr.nix> <508C4FE5.1030102@redhat.com>
	<878varzk56.fsf@spindle.srvr.nix> <508C50BB.2040300@redhat.com>
	<87390zzjr9.fsf@spindle.srvr.nix> <508C5357.6090204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:41833 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559Ab2J0Vkv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Oct 2012 17:40:51 -0400
In-Reply-To: <508C5357.6090204@redhat.com> (Eric Sandeen's message of "Sat, 27
	Oct 2012 16:34:15 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 27 Oct 2012, Eric Sandeen stated:

> On 10/27/12 4:29 PM, Nix wrote:
>> (But, seriously, fsstress is a wonderful thing. And the kernel's test
>> culture *is* improving, and I'm happy to see filesystem hackers in the
>> front line.)
>
> I've been testing with a hacked up devicemapper target which creates
> a "dirty" snapshot which requires a replay; saves the actual power
> drop & restore cycle, and I could repro the journal_checksum bug
> right off.

I'm just not sure why a umount -l of an unused-but-mounted dirty
filesystem followed immediately by a reboot() is triggering a journal
replay at all.

If the umount has started, it should complete before the reboot and mark
the fs clean and !needs_recovery, no matter how much dirty data it has
to write -- all my testing in virtualization does just that -- but it
clearly isn't working that way on real hardware (or, if it is, something
is vaping the controller's cache after the umount has finished, which is
pretty disturbing: nothing but simultaneous failure of two or more
drives or the battery should be able to vape that cache before it is
flushed, certainly not anything as simple as a device disconnection /
reboot).

> XFS has an ioctl to make this easy in regression testing, and several
> tests in xfstests do cover xfs journal recovery.  We need
> to add such a thing to ext4.  Not being able to programatically 
> test recovery is a problem.

True enough.

You can rest assured that I will continue being a test load if necessary --
though for now I have removed journal_async_commit from my mount options,
at least until this bug is fixed, because I don't like being a test load
*that* much!

-- 
NULL && (void)
