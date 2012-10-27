From: Nix <nix@esperi.org.uk>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3 (and other stable branches?)
Date: Sat, 27 Oct 2012 22:29:30 +0100
Message-ID: <87390zzjr9.fsf@spindle.srvr.nix>
References: <874nllxi7e.fsf_-_@spindle.srvr.nix>
	<87pq48nbyz.fsf_-_@spindle.srvr.nix> <508AF3FA.4020506@redhat.com>
	<87wqydx957.fsf@spindle.srvr.nix> <20121026205618.GC8614@thunk.org>
	<87objpx84k.fsf@spindle.srvr.nix> <20121026211542.GE8614@thunk.org>
	<87haphx76u.fsf@spindle.srvr.nix> <20121027002258.GB31030@thunk.org>
	<873910xevu.fsf@spindle.srvr.nix> <20121027175534.GA7783@thunk.org>
	<87fw4zzra3.fsf@spindle.srvr.nix> <508C4FE5.1030102@redhat.com>
	<878varzk56.fsf@spindle.srvr.nix> <508C50BB.2040300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:41813 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab2J0V3g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Oct 2012 17:29:36 -0400
In-Reply-To: <508C50BB.2040300@redhat.com> (Eric Sandeen's message of "Sat, 27
	Oct 2012 16:23:07 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 27 Oct 2012, Eric Sandeen spake thusly:

> On 10/27/12 4:21 PM, Nix wrote:
>> On 27 Oct 2012, Eric Sandeen verbalised:
>>> That's what we needed.  Woulda been great a few days ago ;)
>> 
>> *wince* sorry!
>
> It's ok, I know sometimes this testing takes time.

It took much less time once I figured out that umount -l at the last
moment before reboot would reliably corrupt one filesystem and one
filesystem only. Before that, I was having to fsck 2.5Tb of filesystems
on every test run, just in case the latest reboot had zapped them too...

> It has exposed the fact that we are not doing a good job
> regression testing all of the available configurations.

This is the Linux kernel: what was it Linus joked years ago, users are
the test load? I'm impressed you have any regression testing at all, let
alone as much as you seem to. :P :P

(But, seriously, fsstress is a wonderful thing. And the kernel's test
culture *is* improving, and I'm happy to see filesystem hackers in the
front line.)

-- 
NULL && (void)
