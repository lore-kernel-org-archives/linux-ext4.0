From: Theodore Tso <tytso@mit.edu>
Subject: Re: xt4 - True Readonly mount [WAS - Re: [Bug 14354] Bad
	corruption with 2.6.32-rc1 and upwards]
Date: Tue, 3 Nov 2009 08:52:42 -0500
Message-ID: <20091103135242.GA6510@mit.edu>
References: <87f94c370910300720s5ea3d780o45fcf32303820a3c@mail.gmail.com> <20091101054542.GP18464@mit.edu> <87f94c370911021359x19f57427o19e6f7bfcfadae21@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Augustine <taugustine@techpathways.com>,
	Alexey Fisher <bug-track@fisher-privat.net>,
	linux-ext4@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33495 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbZKCNwn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Nov 2009 08:52:43 -0500
Content-Disposition: inline
In-Reply-To: <87f94c370911021359x19f57427o19e6f7bfcfadae21@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 02, 2009 at 04:59:18PM -0500, Greg Freemyer wrote:
> Queisce application (databases, etc. have utils to do this.)
> 
> Queisce filesystem (xfs_freeze -f can be done from userspace. is there
> a ext4 util?)
> 
> issue raid array command to create snapshot.
> 
> release filesystem (xfs_freeze -u)
> 
> release the app (util provided by app).
> 
> Mount the snapshot readonly (true readonly with zero writes to the
> block device).
> 
> Backup the readonly snapshot (to tape, etc.).

This works today using ext4.  The freeze ioctl quiesces the filesystem
and leaves the journal in clean state, so there is no need for a
journal replay.  I take snapshots using LVM all the time.  It's
slightly more work if you are using a hardware raid array since you
can't use a single integrated "lvcreate --snapshot" command, but
should Just Work today.

						- Ted
