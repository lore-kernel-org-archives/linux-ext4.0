From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [Bug 421482] Firefox 3 uses fsync excessively
Date: Mon, 26 May 2008 13:10:16 +0200
Message-ID: <20080526111015.GB20623@logfs.org>
References: <bug-421482-310856@https.bugzilla.mozilla.org/> <200805260513.m4Q5DAU8018498@mrapp54.mozilla.org> <20080526000506.1d0fb047.akpm@linux-foundation.org> <20080526100751.GB24507@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080526100751.GB24507@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 26 May 2008 06:07:51 -0400, Theodore Tso wrote:
> On Mon, May 26, 2008 at 12:05:06AM -0700, Andrew Morton wrote:
> > It's purportedly showing that fdatasync() on ext3 is syncing the wh=
ole
> > world in fsync()-fashion even with an application which does not gr=
ow
> > the file size.
> >=20
> > But fdatasync() shouldn't do that.  Even if the inode is dirty from
> > atime or mtime updates, that shouldn't cause fdatasync() to run an
> > ext3 commit?
>=20
> Well, ideally it shouldn't, although POSIX allows fdatasync() to be
> implemented in terms of fsync().  It is at the moment.  :-/
>=20
> The problem is we don't currently have a way of distinguishing betwee=
n
> a "smudged" inode (only the mtime/atime has changed) and a "dirty"
> inode (even if the number of blocks hasn't changed, if i_size has
> changed, or i_mode, or anything else, including extended attributes
> inline in the inode).  We're not tracking that difference.  If we onl=
y
> allow mtime/atime changes through setattr (see Cristoph's patches),
> and don't set the VFS dirty bit, but our own "smudged" bit, we could
> do it --- but at the moment, we're not.

Don't we already have this bit since Linux 2.4.0-test12?  I_DIRTY_SYNC
is admittedly not well-named for "smudged".  But it used to mean just
that.  I_DIRTY_DATASYNC was the real dirty bit.  Which, in I_DIRTY_PAGE=
S,
has been split into I_DIRTY_DATASYNC and I_DIRTY_PAGES.

Now we just have to use sane names.

J=C3=B6rn

--=20
Don't worry about people stealing your ideas. If your ideas are any goo=
d,
you'll have to ram them down people's throats.
-- Howard Aiken quoted by Ken Iverson quoted by Jim Horning quoted by
   Raph Levien, 1979
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
