From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/10] libext2fs: add explicit casts to ext2fs.h
Date: Tue, 3 Dec 2013 12:13:55 -0800
Message-ID: <20131203201355.GC9541@birch.djwong.org>
References: <20131203002503.GA18601@thunk.org>
 <1386047418-32431-1-git-send-email-tytso@mit.edu>
 <1386047418-32431-6-git-send-email-tytso@mit.edu>
 <20131203191608.GC9535@birch.djwong.org>
 <20131203195238.GA14229@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Kit Westneat <kwestneat@ddn.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46024 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3LCUOE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Dec 2013 15:14:04 -0500
Content-Disposition: inline
In-Reply-To: <20131203195238.GA14229@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 03, 2013 at 02:52:38PM -0500, Theodore Ts'o wrote:
> On Tue, Dec 03, 2013 at 11:16:08AM -0800, Darrick J. Wong wrote:
> >=20
> > The function prototypes up around line 1604 need to be updated:
> >=20
> > In file included from inline.c:38:0:
> > ext2fs.h:1810:17: error: conflicting types for =E2=80=98ext2fs_grou=
p_of_blk=E2=80=99
> > ext2fs.h:1604:12: note: previous declaration of =E2=80=98ext2fs_gro=
up_of_blk=E2=80=99 was here
> > ext2fs.h:1817:17: error: conflicting types for =E2=80=98ext2fs_grou=
p_of_ino=E2=80=99
> > ext2fs.h:1605:12: note: previous declaration of =E2=80=98ext2fs_gro=
up_of_ino=E2=80=99 was here
>=20
> Nice catch; I didn't get these errors on my build for some reason.

I think it's because at some point I edited one of my debug patches to =
#define
NO_INLINE_FUNCS unconditionally so that I'd get bonked by things like t=
hat.

--D
>=20
> I've applied your fix, thanks.
>=20
> 					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
