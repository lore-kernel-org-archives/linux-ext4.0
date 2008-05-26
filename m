From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [Bug 421482] Firefox 3 uses fsync excessively
Date: Mon, 26 May 2008 21:22:11 +0100
Message-ID: <20080526202210.GA29046@shareable.org>
References: <bug-421482-310856@https.bugzilla.mozilla.org/> <200805260513.m4Q5DAU8018498@mrapp54.mozilla.org> <20080526000506.1d0fb047.akpm@linux-foundation.org> <20080526100751.GB24507@mit.edu> <20080526111015.GB20623@logfs.org> <20080526113846.GE24507@mit.edu> <20080526125209.GC20623@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@MIT.EDU>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:43347 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795AbYEZUWX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 May 2008 16:22:23 -0400
Content-Disposition: inline
In-Reply-To: <20080526125209.GC20623@logfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

J=F6rn Engel wrote:
> > We're currently forcing a new commit if I_DIRTY_SYNC or
> > I_DIRTY_DATASYNC (but not necessarily I_DIRTY_PAGES) is set.  If
> > I_DIRTY_SYNC really means "smudged" (I believe you but I'll want to=
 go
> > through the code and prove it to myself :-),
>=20
> Proving it to yourself is good advice indeed.  I'm sure it used to me=
an
> "smudged" in 2.4.0 time.  Whether any changes since have damaged that
> property I haven't checked.

I noticed fdatasync() doing a full fsync(), and had a look at those
flags a few kernels ago, to implement fdatasync().  I wasn't convinced
the flags were being used in that way, but now I don't remember why.

So, yes, do check what they mean _now_.  And then, please, make us all
happy and implement fdatasync() :-)

Here's a thought for someone implementing fdatasync().  If a database
uses O_DIRECT writes (typically with aio), then wants data which it's
written to be committed to the hard disk platter, and the filesystem
is mounted "barrier=3D1" - should it call fdatasync()?  Should that emi=
t
the barrier?  If another application uses normal (not O_DIRECT)
writes, and then _is delayed_ so long that kernel writeback occurs and
all cache is clean, and then calls fdatasync(), should that call emit
a barrier in that case?  (Answers imho: yes and yes).

> > (And then, we should rename things to more sane names.  :-)

Please, yes!  The names made sense instinctively, until I looked at
the code then they didn't :-)

-- Jamie
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
