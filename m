From: Theodore Tso <tytso@mit.edu>
Subject: Re: Bug#389772: e2fsprogs: e2fsck produces broken htree on ppc
Date: Thu, 28 Sep 2006 21:08:57 -0400
Message-ID: <20060929010857.GC11055@thunk.org>
References: <20060927122251.GA732@alea.gnuu.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: paulus@au.ibm.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:43451 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1161119AbWI2BJU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Sep 2006 21:09:20 -0400
To: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>,
	389772@bugs.debian.org
Content-Disposition: inline
In-Reply-To: <20060927122251.GA732@alea.gnuu.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 27, 2006 at 02:22:51PM +0200, J=F6rg Sommer wrote:
> Package: e2fsprogs
> Version: 1.39-1
> Severity: important
>=20
> you set the compiler option -fsigned-char, but on PowerPC the default=
 is
> unsigned char. This makes the kernel uses unsigned and e2fsck uses si=
gned
> chars.
>=20
> In the case of an 8 bit character, str2hashbuf() in lib/ext2fs/dirhas=
h.c
> produces a different buf than the kernel, which leads to the problem =
that
> the hash calculated by TEA_transform() is a different one.

Oh, dear.  This is actually a kernel bug, because the on all other
platforms, the TEA hash will be using a signed char --- and if you
want filesystems to be portable between different systems (hint: we
do), then all architectures should be using the same algorithm.  And
the vast majority of the systems out there are using signed chars.
Unfortunately PowerPC decided to be different.  :-(

=46ixing this is going to be painful, because if we fix the kernel to
suddenly use signed chars in the TEA algorithm, like all other right
thinking architectures (joke! joke!), then existing ext3 filesystems
with directory hashing enabled will break.

But given that e2fsck is doing it right, and the kernel is doing it
wrong, we have the mismatch already.  Sigh, this is going to be
especially painful, given that all the major distributions (SLES,
RHEL, Debian, Ubuntu, etc.) are now shipping with directory hashing
enabled by default, and so this is going to impact a huge number of
PowerPC Linux users and customers.

OK, I think how are going to have to fix this is to define two new
flags in the superblock, which indicates whether str2hashbuf is using
signed or unsigned chars.  If neither flag is set, then new kernels
and new e2fsprogs will set the flag for the "native" signed/unsigned
char convention, and assume that it is correct.  I think this is only
a PowerPC problem, but we'll probably need to do a quick check of all
of the other architectures.

Paul, since you're the PowerPC maintainer, I figured I'd better cc
you.  Does this sound sane to you?

							- Ted
-
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
