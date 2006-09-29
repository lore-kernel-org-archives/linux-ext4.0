From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Bug#389772: e2fsprogs: e2fsck produces broken htree on ppc
Date: Fri, 29 Sep 2006 11:15:47 -0600
Message-ID: <20060929171547.GO22010@schatzie.adilger.int>
References: <20060927122251.GA732@alea.gnuu.de> <20060929010857.GC11055@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>,
	389772@bugs.debian.org, paulus@au.ibm.com,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:57302 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1161833AbWI2RPt
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Sep 2006 13:15:49 -0400
To: Theodore Tso <tytso@mit.edu>
Content-Disposition: inline
In-Reply-To: <20060929010857.GC11055@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 28, 2006  21:08 -0400, Theodore Tso wrote:
> On Wed, Sep 27, 2006 at 02:22:51PM +0200, J=F6rg Sommer wrote:
> > Package: e2fsprogs
> > Version: 1.39-1
> > Severity: important
> >=20
> > you set the compiler option -fsigned-char, but on PowerPC the defau=
lt is
> > unsigned char. This makes the kernel uses unsigned and e2fsck uses =
signed
> > chars.
> >=20
> > In the case of an 8 bit character, str2hashbuf() in lib/ext2fs/dirh=
ash.c
> > produces a different buf than the kernel, which leads to the proble=
m that
> > the hash calculated by TEA_transform() is a different one.
>=20
> Oh, dear.  This is actually a kernel bug, because the on all other
> platforms, the TEA hash will be using a signed char --- and if you
> want filesystems to be portable between different systems (hint: we
> do), then all architectures should be using the same algorithm.  And
> the vast majority of the systems out there are using signed chars.
> Unfortunately PowerPC decided to be different.  :-(
>=20
> But given that e2fsck is doing it right, and the kernel is doing it
> wrong, we have the mismatch already.  Sigh, this is going to be
> especially painful, given that all the major distributions (SLES,
> RHEL, Debian, Ubuntu, etc.) are now shipping with directory hashing
> enabled by default, and so this is going to impact a huge number of
> PowerPC Linux users and customers.

Hmm, except isn't the problem ALREADY that PPC is broken with 8-bit
chars and htree?  That's what started this problem in the first place.
Running e2fsck allowed the kernel htree code to find the file, when
it could not otherwise be looked up...  Need to verify that (my mental
stack is overflowing).

IIRC this problem was also reported in the past but no solution was fou=
nd.
I think fixing the kernel to specify signed chars for the hash will FIX
the PPC kernel code.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

-
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
