From: Dave Chinner <david@fromorbit.com>
Subject: Re: [4.1-rc] File was modified, but mtime stayed the same (according
 to unison)
Date: Wed, 10 Jun 2015 08:13:19 +1000
Message-ID: <20150609221319.GA24666@dastard>
References: <20150609104330.GA29980@amd>
 <20150609151209.GR19168@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Theodore Ts'o <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	kernel list <linux-kernel@vger.kernel.org>, jack@suse.cz
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150609151209.GR19168@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 09, 2015 at 11:12:09AM -0400, Theodore Ts'o wrote:
> On Tue, Jun 09, 2015 at 12:43:30PM +0200, Pavel Machek wrote:
> >=20
> > Hi!
> >=20
> > Today, I got strange warning from unison:
> >=20
> > pavel/.config/chromium/Default/Extension State/LOG.old =E2=80=94 tr=
ansport
> > failure
> > =E2=80=A2 The source file /data/pavel/.config/chromium/Default/Exte=
nsion
> > State/LOG.old
> > has been modified but the fast update detection mechanism
> > failed to detect it.  Try running once with the fastcheck
> > option set to 'no'.
>=20
> What does this mean, precisely?  Is Unison checking that files have
> been modified using some kind of a checksum or file comparison
> mechanism?  And I assume that the "fast update detection mechanism"
> using mtime?
>=20
> And if it has modified, how was it modified (can you do a diff with
> what the other side of the synchronization setup had for that file),
> and do you know by which process. and what was it trying to do?  And
> how is unison being run?
>=20
> One thing that could be going on is that if you have a file which is
> mmap'ed, the mtime field is set the first time the page is modified
> (when the page table entry is set to read/write from read-only).  If
> unison then takes a snapshot of the file, and then file is
> subsequently modified via a write to the mmap'ed page, the mtime fiel=
d
> will not be updated again.

That's not right: when dirty mmap pages are cleaned by writeback the
PTEs are cleaned, too.  Hence on the next modification of that page
we will get a new write page fault that modifies the mtime. IOWs, if
the "snapshot" involves writing back the file, then it will be
marked clean and the next page fault will cause the mtime to be
updated.

In general, this means that constantly dirtied mmap files will have
the mtime updated at least every 30s and background writeback cleans
dirty pages. Usually, however, it is much more often than that as
each clean page that is dirtied will cause the mtime to be updated
due to traversal through the ->page_mkwrite -> ext4_page_mkwrite()
-> file_update_time() path.

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
