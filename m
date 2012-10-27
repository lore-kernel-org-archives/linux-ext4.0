From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Date: Sat, 27 Oct 2012 16:34:15 -0500
Message-ID: <508C5357.6090204@redhat.com>
References: <874nllxi7e.fsf_-_@spindle.srvr.nix> <87pq48nbyz.fsf_-_@spindle.srvr.nix> <508AF3FA.4020506@redhat.com> <87wqydx957.fsf@spindle.srvr.nix> <20121026205618.GC8614@thunk.org> <87objpx84k.fsf@spindle.srvr.nix> <20121026211542.GE8614@thunk.org> <87haphx76u.fsf@spindle.srvr.nix> <20121027002258.GB31030@thunk.org> <873910xevu.fsf@spindle.srvr.nix> <20121027175534.GA7783@thunk.org> <87fw4zzra3.fsf@spindle.srvr.nix> <508C4FE5.1030102@redhat.com> <878varzk56.fsf@spindle.srvr.nix> <508C50BB.2040300@redhat.com> <87390zzjr9.fsf@spindle.srvr.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab2J0VeW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 27 Oct 2012 17:34:22 -0400
In-Reply-To: <87390zzjr9.fsf@spindle.srvr.nix>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/27/12 4:29 PM, Nix wrote:
> On 27 Oct 2012, Eric Sandeen spake thusly:
> 
>> On 10/27/12 4:21 PM, Nix wrote:
>>> On 27 Oct 2012, Eric Sandeen verbalised:
>>>> That's what we needed.  Woulda been great a few days ago ;)
>>>
>>> *wince* sorry!
>>
>> It's ok, I know sometimes this testing takes time.
> 
> It took much less time once I figured out that umount -l at the last
> moment before reboot would reliably corrupt one filesystem and one
> filesystem only. Before that, I was having to fsck 2.5Tb of filesystems
> on every test run, just in case the latest reboot had zapped them too...
> 
>> It has exposed the fact that we are not doing a good job
>> regression testing all of the available configurations.
> 
> This is the Linux kernel: what was it Linus joked years ago, users are
> the test load? I'm impressed you have any regression testing at all, let
> alone as much as you seem to. :P :P

Well, that should not be the case, or at least minimized.  It takes
constant vigilance... 

> (But, seriously, fsstress is a wonderful thing. And the kernel's test
> culture *is* improving, and I'm happy to see filesystem hackers in the
> front line.)

I've been testing with a hacked up devicemapper target which creates
a "dirty" snapshot which requires a replay; saves the actual power
drop & restore cycle, and I could repro the journal_checksum bug
right off.

XFS has an ioctl to make this easy in regression testing, and several
tests in xfstests do cover xfs journal recovery.  We need
to add such a thing to ext4.  Not being able to programatically 
test recovery is a problem.

-Eric

