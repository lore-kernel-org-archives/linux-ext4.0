From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [Bug 421482] Firefox 3 uses fsync excessively
Date: Mon, 26 May 2008 07:38:46 -0400
Message-ID: <20080526113846.GE24507@mit.edu>
References: <bug-421482-310856@https.bugzilla.mozilla.org/> <200805260513.m4Q5DAU8018498@mrapp54.mozilla.org> <20080526000506.1d0fb047.akpm@linux-foundation.org> <20080526100751.GB24507@mit.edu> <20080526111015.GB20623@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:63369 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754079AbYEZLjS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 May 2008 07:39:18 -0400
Content-Disposition: inline
In-Reply-To: <20080526111015.GB20623@logfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 26, 2008 at 01:10:16PM +0200, J=F6rn Engel wrote:
> Don't we already have this bit since Linux 2.4.0-test12?  I_DIRTY_SYN=
C
> is admittedly not well-named for "smudged".  But it used to mean just
> that.  I_DIRTY_DATASYNC was the real dirty bit.  Which, in I_DIRTY_PA=
GES,
> has been split into I_DIRTY_DATASYNC and I_DIRTY_PAGES.
>=20
> Now we just have to use sane names.

We're currently forcing a new commit if I_DIRTY_SYNC or
I_DIRTY_DATASYNC (but not necessarily I_DIRTY_PAGES) is set.  If
I_DIRTY_SYNC really means "smudged" (I believe you but I'll want to go
through the code and prove it to myself :-), then this might be a very
easy fix.  We'll need to make sure that unmount time we do actually
force out all inodes even if only I_DIRTY_SYNC is set.

(And then, we should rename things to more sane names.  :-)

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
