From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [4.1-rc] File was modified, but mtime stayed the same (according
 to unison)
Date: Tue, 9 Jun 2015 11:12:09 -0400
Message-ID: <20150609151209.GR19168@thunk.org>
References: <20150609104330.GA29980@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	kernel list <linux-kernel@vger.kernel.org>, jack@suse.cz
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150609104330.GA29980@amd>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 09, 2015 at 12:43:30PM +0200, Pavel Machek wrote:
>=20
> Hi!
>=20
> Today, I got strange warning from unison:
>=20
> pavel/.config/chromium/Default/Extension State/LOG.old =E2=80=94 tran=
sport
> failure
> =E2=80=A2 The source file /data/pavel/.config/chromium/Default/Extens=
ion
> State/LOG.old
> has been modified but the fast update detection mechanism
> failed to detect it.  Try running once with the fastcheck
> option set to 'no'.

What does this mean, precisely?  Is Unison checking that files have
been modified using some kind of a checksum or file comparison
mechanism?  And I assume that the "fast update detection mechanism"
using mtime?

And if it has modified, how was it modified (can you do a diff with
what the other side of the synchronization setup had for that file),
and do you know by which process. and what was it trying to do?  And
how is unison being run?

One thing that could be going on is that if you have a file which is
mmap'ed, the mtime field is set the first time the page is modified
(when the page table entry is set to read/write from read-only).  If
unison then takes a snapshot of the file, and then file is
subsequently modified via a write to the mmap'ed page, the mtime field
will not be updated again.  We *could* constantly reset the page table
flags but it would be disastrous from a performance standpoint, and if
mmap is involved, Posix does *not* guarantee that mtime field will be
set each time a process writes to the mmap'ed segment --- because that
would be insane.

Regards,

						- Ted
