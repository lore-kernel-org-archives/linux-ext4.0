From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Date: Tue, 23 Oct 2012 19:28:13 -0400
Message-ID: <20121023232813.GF28626@thunk.org>
References: <87objupjlr.fsf@spindle.srvr.nix>
 <20121023013343.GB6370@fieldses.org>
 <87mwzdnuww.fsf@spindle.srvr.nix>
 <20121023143019.GA3040@fieldses.org>
 <874nllxi7e.fsf_-_@spindle.srvr.nix>
 <87pq48nbyz.fsf_-_@spindle.srvr.nix>
 <20121023221913.GC28626@thunk.org>
 <87bofsn5zm.fsf@spindle.srvr.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Bryan Schumaker <bjschuma@netapp.com>,
	Peng Tao <bergwolf@gmail.com>, Trond.Myklebust@netapp.com,
	gregkh@linuxfoundation.org,
	Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
	Eric Sandeen <sandeen@redhat.com>, stable@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57113 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934083Ab2JWX22 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Oct 2012 19:28:28 -0400
Content-Disposition: inline
In-Reply-To: <87bofsn5zm.fsf@spindle.srvr.nix>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 24, 2012 at 12:06:21AM +0100, Nix wrote:
> I note that the patch is in the latest stable releases of 3.4.x and
> 3.5.x, which are IIRC end-of-lifed. I'd say that if your patch does
> indeed fix it, this justifies pushing out new releases of both these
> stable kernels with just this patch in, just to make sure people taking
> the latest stable kernel from those releases don't eat their
> filesystems.

Eric is in the process of reviewing the bug, and creating a repro case
so we can definitely show that my theory is sound, and that the bug
has been fixed by my proposed fix.  We know that my patch definitely
restores the behaviour previous to commit eeecef0af5, so it can't
hurt, but we do want to make 100% sure that it really fixes the
problem.  (I found the potential bug by desk checking the all of the
commits between v3.6.1 and v3.6.3, and none of the other commits
triggered my WTF alarm, but we want to have a easy repro case so we
can be 100% sure it's been fixed.  It's always nice when theory is
backed up with empircal evidence.  :-)

Until then, it should also be fine to just revert that commit on the
other stable kernels.

> The bug did really quite a lot of damage to my /home fs in only a few
> minutes of uptime, given how few files I wrote to it. What it could have
> done to a more conventional distro install with everything including
> /home on one filesystem, I shudder to think.

Well, the problem won't show up if the journal has wrapped.  So it
will only show up if the system has been rebooted twice in fairly
quick succession.  A full conventional distro install probably
wouldn't have triggered a bug... although someone who habitually
reboots their laptop instead of using suspend/resume or hiberbate, or
someone who is trying to bisect the kernel looking for some other bug
could easily trip over this --- which I guess is how you got hit by
it.

Regards,

						- Ted
