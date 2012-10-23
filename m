From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Date: Tue, 23 Oct 2012 19:16:07 -0400
Message-ID: <20121023231607.GE28626@thunk.org>
References: <87objupjlr.fsf@spindle.srvr.nix>
 <20121023013343.GB6370@fieldses.org>
 <87mwzdnuww.fsf@spindle.srvr.nix>
 <20121023143019.GA3040@fieldses.org>
 <874nllxi7e.fsf_-_@spindle.srvr.nix>
 <87pq48nbyz.fsf_-_@spindle.srvr.nix>
 <20121023221913.GC28626@thunk.org>
 <87k3ugn6v4.fsf@spindle.srvr.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Bryan Schumaker <bjschuma@netapp.com>,
	Peng Tao <bergwolf@gmail.com>, Trond.Myklebust@netapp.com,
	gregkh@linuxfoundation.org,
	Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
	Eric Sandeen <sandeen@redhat.com>, stable@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: Nix <nix@esperi.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87k3ugn6v4.fsf@spindle.srvr.nix>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Just to follow up (mostly for ext4 developers).  After talking to Eric
via irc, it appears he thought it was sufficient to check (s_start ==
0) from commit 24bcc89c7e, which was authored by Jan Kara.  (Which we
now need to audit very carefully, although it's been in the upstream
kernel since 3.4, so it's obviously not causing failures as
spectacularly or as easily as eeecef0af5e.)

And I suspect the reason why Jan thought this was OK is because of the
following totally bogus comment at fs/jbd2/recovery.c:259:

	/*
	 * The journal superblock's s_start field (the current log head)
	 * is always zero if, and only if, the journal was cleanly
	 * unmounted.
	 */

After doing some code archeology, I've found that this comment dates
back to the very first commit in the historic git tree when the fs/jbd
code was added to the 2.4.14 tree.  I suspect that s_start was
originally a physical block number (in the very early days when sct
was initially developing ext3, before it was submitted to the kernel),
but then when Stephen added the ability to store the journal in an
inode, it became a logical block number, and this comment became
incorrect, but no one noticed and/or decided to fix the comment in the
last ten years.  :-(

So now we know the root cause of the thought processes that lead to
the bug, and now we need to double check the changes in commits
24bcc89c7e for jbd2, and 9754e39c7b for jbd (a similar change was also
added to ext3 in v3.5).

						- Ted
