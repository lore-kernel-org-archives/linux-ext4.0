From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6
 (when rebooting during umount)
Date: Thu, 25 Oct 2012 10:12:26 -0400
Message-ID: <20121025141226.GC13562@thunk.org>
References: <87pq48nbyz.fsf_-_@spindle.srvr.nix>
 <508740B2.2030401@redhat.com>
 <87txtkld4h.fsf@spindle.srvr.nix>
 <50876E1D.3040501@redhat.com>
 <20121024052351.GB21714@thunk.org>
 <878vavveee.fsf@spindle.srvr.nix>
 <20121024210819.GA5484@thunk.org>
 <87y5iv78op.fsf_-_@spindle.srvr.nix>
 <20121025011056.GC4559@thunk.org>
 <87y5iv5noq.fsf@spindle.srvr.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Bryan Schumaker <bjschuma@netapp.com>,
	Peng Tao <bergwolf@gmail.com>, Trond.Myklebust@netapp.com,
	gregkh@linuxfoundation.org,
	Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
To: Nix <nix@esperi.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57500 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758321Ab2JYOMn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Oct 2012 10:12:43 -0400
Content-Disposition: inline
In-Reply-To: <87y5iv5noq.fsf@spindle.srvr.nix>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've been thinking about this some more, and if you don't have a lot
of time, perhaps the most important test to do is this.  Does the
chance of your seeing corrupted files in v3.6.3 go down if you run
3.6.3 with commit 14b4ed22a6 reverted?  Keep your current
configuration, using nobarrier, et. al, constant.  If reverting the
commit makes things better, then that's what would be most useful to
know as soon as possible, since the correct short-term solution is to
revert that commit for 3.7-rcX, as well as the 3.6 and 3.5 stable
kernels.

We can investigate later whether nobarrier, journal_async_commit seem
to make the problem worse, and whether the less common corruption case
that you were seeing with 3.6.1 was actually a change which was
introduced between 3.3 and 3.4.

But most importantly, even if the bug doesn't show up with the default
mount options at all (which explains why Eric and I weren't able to
reproduce it), there are probably other users using nobarrier, so if
the frequency with which you were seeing corruptions went up
significantly between 3.6.1 and 3.6.3, and reverting 14b4ed22a6 brings
the frequency back down to what you were seeing with 3.6.1, we should
do that ASAP.

Regards,

						- Ted
