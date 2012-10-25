From: Nix <nix@esperi.org.uk>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6 (when rebooting during umount)
Date: Thu, 25 Oct 2012 15:15:48 +0100
Message-ID: <8739124oyz.fsf@spindle.srvr.nix>
References: <87pq48nbyz.fsf_-_@spindle.srvr.nix> <508740B2.2030401@redhat.com>
	<87txtkld4h.fsf@spindle.srvr.nix> <50876E1D.3040501@redhat.com>
	<20121024052351.GB21714@thunk.org> <878vavveee.fsf@spindle.srvr.nix>
	<20121024210819.GA5484@thunk.org> <87y5iv78op.fsf_-_@spindle.srvr.nix>
	<20121025011056.GC4559@thunk.org> <87y5iv5noq.fsf@spindle.srvr.nix>
	<20121025141226.GC13562@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Bryan Schumaker <bjschuma@netapp.com>,
	Peng Tao <bergwolf@gmail.com>, Trond.Myklebust@netapp.com,
	gregkh@linuxfoundation.org,
	Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121025141226.GC13562@thunk.org> (Theodore Ts'o's message of
	"Thu, 25 Oct 2012 10:12:26 -0400")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 25 Oct 2012, Theodore Ts'o stated:

> I've been thinking about this some more, and if you don't have a lot
> of time,

I've got time, but it's this weekend, not during the week :)

>          perhaps the most important test to do is this.  Does the
> chance of your seeing corrupted files in v3.6.3 go down if you run
> 3.6.3 with commit 14b4ed22a6 reverted?

This I can verify, sometime this evening. (I presume what we're really
interested in is whether the window in which files get corrupted has
narrowed such that my 5s sleep after umount is now long enough to have a
lower likelihood of corruption, since we know that a near-0s sleep after
umount causes corruption almost every time on 3.6.1 as well: I've now
done that three times and got corruption every time.)

> But most importantly, even if the bug doesn't show up with the default
> mount options at all (which explains why Eric and I weren't able to
> reproduce it), there are probably other users using nobarrier, so if
> the frequency with which you were seeing corruptions went up
> significantly between 3.6.1 and 3.6.3, and reverting 14b4ed22a6 brings
> the frequency back down to what you were seeing with 3.6.1, we should
> do that ASAP.

Agreed.

-- 
NULL && (void)
