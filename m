From: Nix <nix@esperi.org.uk>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3 (and other stable branches?)
Date: Wed, 24 Oct 2012 00:34:42 +0100
Message-ID: <87y5iwlq3x.fsf@spindle.srvr.nix>
References: <87objupjlr.fsf@spindle.srvr.nix>
	<20121023013343.GB6370@fieldses.org> <87mwzdnuww.fsf@spindle.srvr.nix>
	<20121023143019.GA3040@fieldses.org>
	<874nllxi7e.fsf_-_@spindle.srvr.nix>
	<87pq48nbyz.fsf_-_@spindle.srvr.nix>
	<20121023221913.GC28626@thunk.org> <87bofsn5zm.fsf@spindle.srvr.nix>
	<20121023232813.GF28626@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Bryan Schumaker <bjschuma@netapp.com>,
	Peng Tao <bergwolf@gmail.com>, Trond.Myklebust@netapp.com,
	gregkh@linuxfoundation.org,
	Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
	Eric Sandeen <sandeen@redhat.com>, stable@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:59819 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933579Ab2JWXez (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Oct 2012 19:34:55 -0400
In-Reply-To: <20121023232813.GF28626@thunk.org> (Theodore Ts'o's message of
	"Tue, 23 Oct 2012 19:28:13 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 24 Oct 2012, Theodore Ts'o told this:

> hurt, but we do want to make 100% sure that it really fixes the
> problem.

Well, yes, that would be nice. I can certainly try to verify that it
stops my filesystems getting corrupted. (And if so, I owe you a
$BEVERAGE. Though I suspect I owe you about three million of those
already for other code written in the past.)

>> The bug did really quite a lot of damage to my /home fs in only a few
>> minutes of uptime, given how few files I wrote to it. What it could have
>> done to a more conventional distro install with everything including
>> /home on one filesystem, I shudder to think.
>
> Well, the problem won't show up if the journal has wrapped.  So it
> will only show up if the system has been rebooted twice in fairly
> quick succession.  A full conventional distro install probably
> wouldn't have triggered a bug...

A full *install* from scratch, no. I was more worried about the
possibility of someone running -stable kernels on an existing distro
installation, and shutting down every night (given what's been happening
to UK electricity prices in the last few years I suspect there are quite
a lot of people doing that in the UK to save power). If they happen not
to do much on one particular day other than a bit of light distro
updating, they could perfectly well end up roasting things touched
during the distro update. Things like glibc :(

>                                  although someone who habitually
> reboots their laptop instead of using suspend/resume or hiberbate, or
> someone who is trying to bisect the kernel looking for some other bug
> could easily trip over this --- which I guess is how you got hit by
> it.

I was first hit by it in /var before I was even trying to bisect: I was
just rebooting to unwedge NFS lockd. It's true that in less than a week
probably not all that many people have rebooted often enough to trip
over this.

I hope.

-- 
NULL && (void)
