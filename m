From: "Marcel Partap" <mpartap@gmx.net>
Subject: Re: Fwd: fsck ate my ext4 home partition, help!?
Date: Sun, 10 May 2009 16:51:30 +0200
Message-ID: <20090510145130.262830@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@thunk.org, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53784 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753336AbZEJOve (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 May 2009 10:51:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> On Sat, May 09, 2009 at 04:56:55PM +0200, Marcel Partap wrote: Hi
> > Theodore, i have run into quite an unlucky situation, developing
> > within this thread http://markmail.org/message/5vnfqx7jfzy7dk4f and
> > no longer true to the title (actually, it was an ext3 volume and i
> > can't blame e2fsck..)
>=20
> OK, so when people have this happen to them, what has happened is tha=
t
> somehow, blocks have gotten written to the wrong place on disk.  In
> some cases, such has here:
>=20
> > -----------------------------------------------
> > debugfs:  pwd
> > [pwd]   INODE: 28409857  PATH: /homedirs
> > [root]  INODE:      2  PATH: /
> > debugfs:  stat currenthomebase
> > Inode: 27672580   Type: regular    Mode:  0644   Flags: 0x0
> > Generation: 3792779416    Version: 0x00000000
> > User:  1000   Group:   100   Size: 9715
> > File ACL: 0    Directory ACL: 0
> > Links: 1   Blockcount: 24
> > Fragment:  Address: 0    Number: 0    Size: 0
> > ctime: 0x48c67d84 -- Tue Sep  9 15:43:32 2008
> > atime: 0x48c67d84 -- Tue Sep  9 15:43:32 2008
> > mtime: 0x443915e6 -- Sun Apr  9 16:10:46 2006
> > BLOCKS:
> > (0):3704694, (1-2):3704826-3704827
> > TOTAL: 3
> > -----------------------------------------------
> > SHOULD be a directory.=20
>=20
> Was probably the case of some inode table block gettin written to the
> wrong place on diks.
Maybe because of the half-unmounted state things were in.

> In the case of these error messages:
>=20
> > Inode 65633 was part of the orphaned inode list.  IGNORED.
> > Inode 65633 is in use, but has dtime set.  Fix? no
> >=20
> > Inode 65633 has imagic flag set.  Clear? no
> >=20
> > Inode 65634 was part of the orphaned inode list.  IGNORED.
> > Inode 65634 is in use, but has dtime set.  Fix? no
> >=20
> > Inode 65634 has imagic flag set.  Clear? no
> >=20
> > Inode 65635 is in use, but has dtime set.  Fix? no
> >=20
> > Inode 65636 is in use, but has dtime set.  Fix? no
> >=20
> > Inode 65636 has imagic flag set.  Clear? no
> >=20
> > Inode 65637 is in use, but has dtime set.  Fix? no
> >=20
> > Inode 65638 was part of the orphaned inode list.  IGNORED.
> > Inode 65638 is in use, but has dtime set.  Fix? no
>=20
> It's probably some data block getting written to the inode table.
> Many things can cause this problem.  Filesystem corruption which
> causes indirect blocks to point at the inode table can do this
> (although it doesn't explain an inode table block getting written to
> the wrong place on disk and overwriting another inode table block).
> It can be caused by a kernel bug.  It can also be caused by hardware
> problems; a hiccup in the controller or in the disk drive can cause a
> disk to be written to the wrong location on disk.  (The most likely
> cause of an inode table block getting written to the wrong location o=
n
> disk.)
Even though smartd regularly warns the drive had two unrecoverable sect=
or incidents, i highly doubt it's the hardware's fault. Strongly assume=
 full scale user error instead.

> Hardware screwing up happens more often that hard drive manufacturers
> like to admit.  There's a reason why enterprise databases put
> checksums and block location information in each table block they
> write out, so they can catch this.  As another example, the SCSI Data
> Integrity Field[1] is used by hardware to provide an separate
> end-to-end check that the block will be written to the right location
> on disk.  Unfortunately, only the most expensive, high-end storage
> devices supports the DIF feature.
> [1] http://lwn.net/Articles/290145/
>=20
Well a software RAID setup, redunant parity (PAR2) files and regular ba=
ckups minimize the risk of data loss much more price worthy for us non-=
professionals.. but i haven't had it setup yet. Someone hit me with a l=
arge stick. Nah - BIGGER.

> In any case, it's not as simple as:
> > Can i just change the mode of the inode and run fsck?=20
> The problem is that it's not just the matter of the mode on the inode
> being incorrect; the entire inode is probably from another location o=
n
> disk.  Judging from the timestamp, it hasn't been modified in a while=
:
>=20
> > ctime: 0x48c67d84 -- Tue Sep  9 15:43:32 2008
> > atime: 0x48c67d84 -- Tue Sep  9 15:43:32 2008
> > mtime: 0x443915e6 -- Sun Apr  9 16:10:46 2006
>=20
> And if you were to use debugfs to dump out the contents of the file:
>=20
> debugfs: dump <27672580> /tmp/currenthomebase-contents
>=20
> And then run "file" over that file, you'll probably find that it is
> some text file or executable file -- but not a directory.
Yes it is - it's auth.php from phpBB, might belong to a local mirror of=
 a site i maintain. Duh.

> The only way to recover this, I'm afraid, is to let fsck:
>
> > attaches all thousands of sub objects into lost+found, which is not
> > really usable (see fsck -vn /dev/sdd4 log attached).
Nooooh :O
Not giving up yet. Must find my home dir's inode somewhere!! Not transc=
ending state of denial yet.

> You may find that this is much more useful than you think.  For
> directories that are dumped into lost+found, you can use ls to look a=
t
> the contents (i.e., ls /mnt/lost+found/#12345) and then from that,
> reconstruct where it was supposed to go.
I know, i tried it. All (almost?) data ends up there, and as the files =
mostly resided in subdirectories, which get recovered. But the director=
y contained about 8K objects, and i'm not yet letting loose on that met=
adata.
> If you have a locatedb
> available (was this the root directory or some secondary filesystem?)=
,
> you can sometimes use the locate command to figure out where director=
y
> is supposed to end up.  i.e.,
Yeah stupid me. I even pondered in time: duh, maybe i really should sto=
p that slocate cron from recreating the database. At that time though, =
i really wasn't as close to acknowledging the loss of that directory as=
 i am now. I didn't do it, so the locate db has already lost this infor=
mation. Is there a chance the old one can be found on the partition it =
resides on? Gonna grep through the partition if there's no better way t=
o find it..

>=20
> % ls /mnt/lost+found/#12345
> certdata     krb5-smtp.c     Makefile.in       prot.o	util.o
> config.h     krb5-smtp.o     outgoing-465.txt  retry.c
> CVS	     krb5-smtp.save  outgoing-587.txt  util.c
> exitcodes.h  Makefile	     prot.c	       util.h
> krb5-smtp    Makefile~	     prot.h	       util.h~
> % locate krb5-smtp.c
> /usr/projects/krb5-smtp/imtest/krb5-smtp.c
>=20
> Ah, hah!  So therefore #12345 is supposed to be
> /usr/local/krb5-smtp/imtest
>=20
> For regular files dumped in /lost+found, you'll have to use the "file=
"
> command to see what they are, and then examine them by hand, and look
> at the file ownership, to figure out where they were supposed to go.
Yeah i kinda know how to proceed with that. As explained, because of th=
e amount of files and also because of the actual low importance of them=
 files, i'd really try and take any other measures to recover them file=
names before doing that.
I know some of the filenames that were in that directory. Is there any =
more usable method to find these inodes? for example, i know there was =
a symlink drive_c in there, and a file 'snippetz'. Can't i use this to =
somehow locate some of the dangling meta information? For sure it can't=
 be all overwritten... If i grep the partition image for that filename =
and look up any resulting blocks with debugfs, is that getting me anywh=
ere nearer the list of files in that directory?

> No, it won't be easy, but at least you haven't lost the contents of
> the files!  You should be able to recover 90+% of your files, and for
> the rest hopefully you'll be able to recover them from your backups
> (you *WERE* doing regular backups, *RIGHT*?  :-)
Uhhmm yeah backups, RIIIGHT *g
Not of that directory though. Going to start doing that - as soon as i =
resolved this mess.

> There are other things you can do if you are regularly having this
> problem, including using e2image to take backups of your metadata
> (which can help you recover overwritten inode table blocks) --- this
> is *still* not a substitute for regular backups, but if this is
> happening a lot, especially with ext3, I'd take a very long, hard loo=
k
> at your hardware. =20
>=20
> This BTW, is one of the reasons why debugging the problem with ext4 i=
s
> so frustrating.  By the time people report the symptoms, the damage
> was done long ago, and it might not have been the filesystem code's
> fault; it could just as easily be a bug in the md layer, or the a
> hardware problem.  However, it's getting reported *just* frequently
> enough, and by enough people, that we're worried it's being caused by
> an ext4 bug.  But we don't know that for sure.  =20
Well in this incident, this was a situation where i neglected the subtl=
e signs of something (clean unmounting) going wrong, so: user error.

> If you're seeing this with ext3, and you're also using the md
> (software raid) driver, maybe there's something to the suspicion that
> it might be an md bug.  On the other hand, there are lots of people
> using the md layer, so I would have thought we would have gotten more
> bug reports from ext3 users of the md driver.  Or maybe it's just
> hardware bugs, and we're just seeing a statistical blip such that
> we've gotten 3 or 4 reports from ext4 users.  I really doubt that (as
> much as I would like to believe it), but it's possible.
Not using md and don't think any kernel bugs involved. Messing with hal=
f-dangling file systems is just never going to be a good idea.

> In any case, I suspect your best bet is to let e2fsck dump the result=
s
> into lost+found, and then try to recover your files from there.  You
Denial. Disbelief. Shock. Angst. Horror. Rage. Iterating that randomly =
since incident occured one week ago..

> probably will have lost some files, since it looks like at least one
> or two other inode table blocks were also corrupted.  Hopefully thoug=
h
> they are system files that can be reinstaled, and/or files for which
> you have backups.
Well the system is still up, the files are not critical to anything, li=
fe goes on. But state of denial continues, not giving up. Must try ever=
ything...

> Good luck,
Thx, and thx for your time Theo.
regards, marcel.
--=20
Neu: GMX FreeDSL Komplettanschluss mit DSL 6.000 Flatrate + Telefonansc=
hluss f=FCr nur 17,95 Euro/mtl.!* http://dslspecial.gmx.de/freedsl-surf=
flat/?ac=3DOM.AD.PD003K11308T4569a
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
