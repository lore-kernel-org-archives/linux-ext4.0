From: Nix <nix@esperi.org.uk>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3 (and other stable branches?)
Date: Wed, 24 Oct 2012 00:06:21 +0100
Message-ID: <87bofsn5zm.fsf@spindle.srvr.nix>
References: <87objupjlr.fsf@spindle.srvr.nix>
	<20121023013343.GB6370@fieldses.org> <87mwzdnuww.fsf@spindle.srvr.nix>
	<20121023143019.GA3040@fieldses.org>
	<874nllxi7e.fsf_-_@spindle.srvr.nix>
	<87pq48nbyz.fsf_-_@spindle.srvr.nix>
	<20121023221913.GC28626@thunk.org>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121023221913.GC28626@thunk.org> (Theodore Ts'o's message of
	"Tue, 23 Oct 2012 18:19:13 -0400")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 23 Oct 2012, Theodore Ts'o verbalised:
> *Sigh*.  My apologies for not catching this when I reviewed this
> patch.  I believe the following patch should fix the bug; once it's
> reviewed by other ext4 developers, I'll push this to Linus ASAP.

I note that the patch is in the latest stable releases of 3.4.x and
3.5.x, which are IIRC end-of-lifed. I'd say that if your patch does
indeed fix it, this justifies pushing out new releases of both these
stable kernels with just this patch in, just to make sure people taking
the latest stable kernel from those releases don't eat their
filesystems.

The bug did really quite a lot of damage to my /home fs in only a few
minutes of uptime, given how few files I wrote to it. What it could have
done to a more conventional distro install with everything including
/home on one filesystem, I shudder to think.

(I've posted a note to the LWN thread announcing 3.6.3, just in case
that saves someone's fs.)

-- 
NULL && (void)
