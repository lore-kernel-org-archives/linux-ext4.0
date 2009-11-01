From: Theodore Tso <tytso@mit.edu>
Subject: Re: xt4 - True Readonly mount [WAS - Re: [Bug 14354] Bad
	corruption with 2.6.32-rc1 and upwards]
Date: Sun, 1 Nov 2009 01:45:42 -0400
Message-ID: <20091101054542.GP18464@mit.edu>
References: <87f94c370910300720s5ea3d780o45fcf32303820a3c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Augustine <taugustine@techpathways.com>,
	Alexey Fisher <bug-track@fisher-privat.net>,
	linux-ext4@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56471 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbZKAFpt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Nov 2009 01:45:49 -0400
Content-Disposition: inline
In-Reply-To: <87f94c370910300720s5ea3d780o45fcf32303820a3c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 30, 2009 at 10:20:35AM -0400, Greg Freemyer wrote:
> Ignoring computer forensics, with LVM snapshots, hardware raid array
> snapshots, etc. even in the presence of a dirty log, we need to be
> able to mount a drive in true read-only fashion fro many backup
> operations to function correctly.

Can you go into more detail about "many backup operations"?   

> XFS added an extra mount flag for that 5 or so years ago.

As Eric has already pointed out, "norecovery" and "noload" mean the
same thing.  But not recovering the journal is dangerous; the file
system is not necessarily going to be consistent, and while the kernel
_shouldn't_ crash given an inconsistent filesystem image --- and a lot
of fsfuzzer testing and bug fixing means that it _probably_ won't
crash --- taking a backup of an inconsistent file system image due to
the journal recovery being suppressed isn't such a great idea.

As I mentioned, trying to _simulate_ a journal recovery by using the
journal instead of data blocks for those blocks in the journal is
possible, but it's a non-trival task to code up.  A Google Summer of
Student project could probably do it, but it's not a day or half-day
project.

If someone is interested in simulating a journal recovery in a true ro
fashion, I'm happy to lay out the design for such a thing.  Contact me
if you're interested....

						- Ted

P.S.  We can certainly add an alias so that ext4 understands
norecovery much like XFS does.  If we are going to standardize on a
mount option, I'd agree that XFS's norecovery is probably a better
choice than ext3/4's noload.

