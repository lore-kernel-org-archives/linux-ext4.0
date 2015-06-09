From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [4.1-rc] File was modified, but mtime stayed the same (according
 to unison)
Date: Tue, 9 Jun 2015 17:34:29 +0200
Message-ID: <20150609153429.GA704@amd>
References: <20150609104330.GA29980@amd>
 <20150609151209.GR19168@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Theodore Ts'o <tytso@mit.edu>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org,
	kernel list <linux-kernel@vger.kernel.org>, jack@suse.cz
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150609151209.GR19168@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 2015-06-09 11:12:09, Theodore Ts'o wrote:
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

I believe it is using checksum in the process, yes.=20

> And if it has modified, how was it modified (can you do a diff with
> what the other side of the synchronization setup had for that file),
> and do you know by which process. and what was it trying to do?  And
> how is unison being run?

No, sorry, I don't think I can get old version of file.

> One thing that could be going on is that if you have a file which is
> mmap'ed, the mtime field is set the first time the page is modified
> (when the page table entry is set to read/write from read-only).  If
> unison then takes a snapshot of the file, and then file is
> subsequently modified via a write to the mmap'ed page, the mtime fiel=
d
> will not be updated again.  We *could* constantly reset the page tabl=
e
> flags but it would be disastrous from a performance standpoint, and i=
f
> mmap is involved, Posix does *not* guarantee that mtime field will be
> set each time a process writes to the mmap'ed segment --- because tha=
t
> would be insane.

Ok, I guess mmap() can explain this. So... basically mtime is useless
in detecting if file have been updated?

Thats... not welcome.

I see that constantly updating on-disk timestamp is not
feasible. Could we do something like

  on page_being_mmapped_rw:
	     file.mtime =3D "future".

  on last_rw_mmap_disappearing:
  	     file.mtime =3D now().

  stat():
	if file.mtime !=3D "future":
		result.mtime =3D file.mtime
	else:
		result.mtime =3D now()

? I see making stat slower is not welcome, but having to read complete
files to determine if they were modified is even worse than that...

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses=
/blog.html
