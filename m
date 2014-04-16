From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Ext4: deadlock occurs when running fsstress and ENOSPC errors
 are seen.
Date: Wed, 16 Apr 2014 10:46:52 -0700
Message-ID: <20140416174652.GA8793@birch.djwong.org>
References: <CADDb1s2RvN_S+abFXCe4ZhZPKZgP_PiocJdpiLzRC_Se5sgVVg@mail.gmail.com>
 <20140415124743.GD3403@thunk.org>
 <CADDb1s3HYDvb51Ngrwk82gkpbUWg1bRo7kaUmbGRmb0g_9JKgw@mail.gmail.com>
 <20140416050729.GD21807@thunk.org>
 <CADDb1s3CnQJyY4f1xS6a=+ceE3cr0ZmkE1EQZ95fLDBw7DHfNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Namjae Jeon <linkinjeon@gmail.com>
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CADDb1s3CnQJyY4f1xS6a=+ceE3cr0ZmkE1EQZ95fLDBw7DHfNg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Apr 16, 2014 at 01:21:34PM +0530, Amit Sahrawat wrote:
> Sorry Ted, if it caused the confusion.
>=20
> There were actually 2 parts to the problem, the logs in the first mai=
l
> were from the original situation =E2=80=93 where in there were many b=
lock
> groups and error prints also showed that.
>=20
> EXT4-fs error (device sda1): ext4_mb_generate_buddy:742: group 1493, =
0
> clusters in bitmap, 58339 in gd
> EXT4-fs error (device sda1): ext4_mb_generate_buddy:742: group 1000, =
0
> clusters in bitmap, 3 in gd
> EXT4-fs error (device sda1): ext4_mb_generate_buddy:742: group 1425, =
0
> clusters in bitmap, 1 in gd
> JBD2: Spotted dirty metadata buffer (dev =3D sda1, blocknr =3D 0). Th=
ere's
> a risk of filesystem corruption in case of system crash.
> JBD2: Spotted dirty metadata buffer (dev =3D sda1, blocknr =3D 0). Th=
ere's
> a risk of filesystem corruption in case of system crash.
>=20
> 1)	Original case =E2=80=93 when the disk got corrupted and we only ha=
d the
> logs and the hung task messages. But not the HDD on which issue was
> observed.
> 2)	In order to reproduce the problem as was coming through the logs
> (which highlighted the problem in the bitmap corruption). To minimize
> the environment and make a proper case, we created a smaller partitio=
n
> size and with only 2 groups. And intentionally corrupted the group 1
> (our intention was just to replicate the error scenario).

I'm assuming that the original broken fs simply had a corrupt block bit=
map, and
that the dd thing was just to simulate that corruption in a testing
environment?

> 3)	After corruption we used =E2=80=98fsstress=E2=80=99  - we got the =
similar problem
> as was coming the original logs. =E2=80=93 We shared our analysis aft=
er this
> point for looping in the writepages part the free blocks mismatch.

Hm.  I tried it with 3.15-rc1 and didn't see any hangs.  Corrupt bitmap=
s shut
down allocations from the block group and the FS continues, as expected=
=2E

> 4)	We came across =E2=80=98Darrick=E2=80=99 patches(in which it also =
mentioned about
> how to corrupt to reproduce the problem) and applied on our
> environment. It solved the initial problem about the looping in
> writepages, but now we got hangs at other places.

There are hundreds of Darrick patches ... to which one are you referrin=
g? :)
(What was the subject line?)

> Using =E2=80=98tune2fs=E2=80=99 is not a viable solution in our case,=
 we can only
> provide the solution via. the kernel changes. So, we made the changes
> as shared earlier.

Would it help if you could set errors=3Dremount-ro in mke2fs?

--D
> So the question isn't how the file system got corrupted, but that
> you'd prefer that the system recovers without hanging after this
> corruption.
> >> Yes,  our priority is to keep the system running.
>=20
> Again, Sorry for the confusion. But the intention was just to show th=
e
> original problem and what we did in order to replicate the problem.
>=20
> Thanks & Regards,
> Amit Sahrawat
>=20
>=20
> On Wed, Apr 16, 2014 at 10:37 AM, Theodore Ts'o <tytso@mit.edu> wrote=
:
> > On Wed, Apr 16, 2014 at 10:30:10AM +0530, Amit Sahrawat wrote:
> >> 4)    Corrupt the block group =E2=80=981=E2=80=99  by writing all =
=E2=80=981=E2=80=99, we had one file
> >> with all 1=E2=80=99s, so using =E2=80=98dd=E2=80=99 =E2=80=93
> >> dd if=3Di_file of=3D/dev/sdb1 bs=3D4096 seek=3D17 count=3D1
> >> After this mount the partition =E2=80=93 create few random size fi=
les and then
> >> ran =E2=80=98fsstress,
> >
> > Um, sigh.  You didn't say that you were deliberately corrupting the
> > file system.  That wasn't in the subject line, or anywhere else in =
the
> > original message.
> >
> > So the question isn't how the file system got corrupted, but that
> > you'd prefer that the system recovers without hanging after this
> > corruption.
> >
> > I wish you had *said* that.  It would have saved me a lot of time,
> > since I was trying to figure out how the system had gotten so
> > corrupted (not realizing you had deliberately corrupted the file
> > system).
> >
> > So I think if you run "tune2fs -e remount-ro /dev/sdb1" before you
> > started the fsstress, the file system would have remounted the
> > filesystem read-only at the first EXT4-fs error message.  This woul=
d
> > avoid the hang that you saw, since the file system would hopefully
> > "failed fast", before th euser had the opportunity to put data into
> > the page cache that would be lost when the system discovered there =
was
> > no place to put the data.
> >
> > Regards,
> >
> >                                                 - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
