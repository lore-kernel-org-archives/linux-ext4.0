From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [Bug 421482] Firefox 3 uses fsync excessively
Date: Mon, 26 May 2008 14:52:10 +0200
Message-ID: <20080526125209.GC20623@logfs.org>
References: <bug-421482-310856@https.bugzilla.mozilla.org/> <200805260513.m4Q5DAU8018498@mrapp54.mozilla.org> <20080526000506.1d0fb047.akpm@linux-foundation.org> <20080526100751.GB24507@mit.edu> <20080526111015.GB20623@logfs.org> <20080526113846.GE24507@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lazybastard.de ([212.112.238.170]:46628 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbYEZMwY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 May 2008 08:52:24 -0400
Content-Disposition: inline
In-Reply-To: <20080526113846.GE24507@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 26 May 2008 07:38:46 -0400, Theodore Tso wrote:
>=20
> On Mon, May 26, 2008 at 01:10:16PM +0200, J=C3=B6rn Engel wrote:
> > Don't we already have this bit since Linux 2.4.0-test12?  I_DIRTY_S=
YNC
> > is admittedly not well-named for "smudged".  But it used to mean ju=
st
> > that.  I_DIRTY_DATASYNC was the real dirty bit.  Which, in I_DIRTY_=
PAGES,
                                                               ^^^^^^^^=
^^^^^
That should have been "2.4.0-prerelease".

> > has been split into I_DIRTY_DATASYNC and I_DIRTY_PAGES.
> >=20
> > Now we just have to use sane names.
>=20
> We're currently forcing a new commit if I_DIRTY_SYNC or
> I_DIRTY_DATASYNC (but not necessarily I_DIRTY_PAGES) is set.  If
> I_DIRTY_SYNC really means "smudged" (I believe you but I'll want to g=
o
> through the code and prove it to myself :-),

Proving it to yourself is good advice indeed.  I'm sure it used to mean
"smudged" in 2.4.0 time.  Whether any changes since have damaged that
property I haven't checked.

> then this might be a very
> easy fix.  We'll need to make sure that unmount time we do actually
> force out all inodes even if only I_DIRTY_SYNC is set.
>=20
> (And then, we should rename things to more sane names.  :-)

J=C3=B6rn

--=20
Joern's library part 11:
http://www.unicom.com/pw/reply-to-harmful.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
