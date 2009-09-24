From: Andreas Dilger <adilger@sun.com>
Subject: Re: ext4 inode corruption
Date: Thu, 24 Sep 2009 12:27:49 -0600
Message-ID: <20090924182749.GB10562@webber.adilger.int>
References: <6601abe90909230927m6d45cd75wef3525fc23837110@mail.gmail.com>
 <6601abe90909231550g5b55f277l218560c827693322@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:53756 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbZIXS1y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Sep 2009 14:27:54 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n8OIRwoc016246
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2009 11:27:58 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KQH00E00N0TIF00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Thu,
 24 Sep 2009 11:27:58 -0700 (PDT)
In-reply-to: <6601abe90909231550g5b55f277l218560c827693322@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 23, 2009  15:50 -0700, Curt Wohlgemuth wrote:
> Sorry to reply to self, but I'm now pretty sure that I understand thi=
s
> problem.  (Of course this insight came mere hours after I sent this
> email -- and not in the previous 4 days of staring at it.)
>=20
> It's likely the same issue fixed by
>=20
>        commit	1b774f669b4b02f4d2abf2792362ab72a2e124ab
>        ext4: Use bforget() in no journal mode for ext4_journal_{forge=
t,revoke}()

I was going to say that this sounded like a familiar problem, but you
already did the leg (well, mouse) work.

> In the previous case, in no-journal mode an about-to-be-freed metadat=
a
> block is marked dirty and available for writeback.  The block is then
> marked free, and re-used as a data block for a different inode; the
> writeback takes place, corrupting the data block.
>=20
> In this case, the newly-freed block is re-used as a *metadata* block
> for a different inode.  Hence the same pattern we were seeing before:
> eh_entries =3D 0, eh_max =3D 340.
>=20
> These inodes were left on systems from kernels without the above
> patch.  Accessing the files on *patched* kernels will still make the
> BUG fire, hence the confusion.
>=20
> Thanks,
> Curt
>=20
>=20
> On Wed, Sep 23, 2009 at 9:27 AM, Curt Wohlgemuth <curtw@google.com> w=
rote:
> > We've been seeing sporadic inode corruption on our ext4 partitions =
which
> > we've been trying to analyze, without much success. =A0I'm wonderin=
g if
> > anybody might have some clues as to where things might be going wro=
ng.
> >
> > We find out about the corruption via a BUG firing in ext4_ext_get_b=
locks():
> >
> > =A0 =A0 =A0 =A0/*
> > =A0 =A0 =A0 =A0 * consistent leaf must not be empty;
> > =A0 =A0 =A0 =A0 * this situation is possible, though, _during_ tree=
 modification;
> > =A0 =A0 =A0 =A0 * this is why assert can't be put in ext4_ext_find_=
extent()
> > =A0 =A0 =A0 =A0 */
> > =A0 =A0 =A0 =A0BUG_ON(path[depth].p_ext =3D=3D NULL && depth !=3D 0=
);
> >
> > Of course, this fires long after the inode in question is corrupted=
=2E =A0With
> > some diagnostics added in front of this bug, we can find the inodes=
; they
> > all have characteristics like this:
> >
> > Output from debugfs' stat command:
> >
> > =A0 Inode: 1195575 =A0 Type: regular =A0 =A0Mode: =A00600 =A0 Flags=
: 0x80000
> > =A0 Generation: 2821101782 =A0 =A0Version: 0x00000001
> > =A0 User: 35800 =A0 Group: =A05000 =A0 Size: 8400896
> > =A0 File ACL: 0 =A0 =A0Directory ACL: 0
> > =A0 Links: 1 =A0 Blockcount: 8
> > =A0 Fragment: =A0Address: 0 =A0 =A0Number: 0 =A0 =A0Size: 0
> > =A0 ctime: 0x4a9f8009 -- Thu Sep =A03 01:36:25 2009
> > =A0 atime: 0x4a9f7ff7 -- Thu Sep =A03 01:36:07 2009
> > =A0 mtime: 0x4a9f8009 -- Thu Sep =A03 01:36:25 2009
> > =A0 EXTENTS:
> >
> > Note that no data blocks are printed out here.
> >
> > Following the actual extent tree, it always looks like this:
> >
> > =A0 in-inode extent header:
> > =A0 =A0 eh_magic: 0xf30a
> > =A0 =A0 eh_entries: 1
> > =A0 =A0 eh_max: 4
> > =A0 =A0 eh_depth: 1
> >
> > =A0 in-inode extent index 0:
> > =A0 =A0 ei_block: 0
> > =A0 =A0 ei_leaf_lo: 36738577
> > =A0 =A0 ei_leaf_hi: 0
> >
> > =A0 =A0 =A0leaf node header (at block 36738577):
> > =A0 =A0 =A0 =A0eh_magic: 0xf30a
> > =A0 =A0 =A0 =A0eh_entries: 0
> > =A0 =A0 =A0 =A0eh_max: 340
> > =A0 =A0 =A0 =A0eh_depth: 0
> >
> > The i_size value of the inode will vary, from 8192 to 8400896. =A0B=
ut the
> > i_blocks value is *always* 8.
> >
> > The extent tree always has depth of 1 in the in-inode header, and a=
 valid
> > leaf node header; but the leaf node header always has 0 entries. =A0=
This is
> > what's causing the BUG above to fire.
> >
> > We believe the general pattern of user space calls to create these =
files is
> > something like this:
> >
> > =A0 open(O_DIRECT)
> > =A0 fallocate(fd, FALLOC_FL_KEEP_SIZE, 0, 8400896)
> > =A0 < various writes to the file >
> > =A0 fallocate(fd, 0, 0, actual_size + BLOCK_SIZE)
> > =A0 ftruncate(fd, actual_size)
> >
> > The second fallocate() call without KEEP_SIZE allows the following
> > ftruncate to actually truncate the file -- a known issue recently f=
ixed by
> > Jiaying Zhang (but her fix is not in our kernel yet). =A0"actual_si=
ze" can be
> > 0 at times.
> >
> > I can't think of any actions that would cause the i_size to be so l=
arge, yet
> > the i_blocks always be 8. =A0Looking at the code in
> >
> > =A0 ext4_ext_remove_space()
> > =A0 ext4_ext_rm_leaf()
> > =A0 ext4_ext_rm_idx()
> >
> > I don't see a way for the extent tree to take the shape above. =A0T=
here are no
> > errors that I can see around the time the corrupted inodes are crea=
ted. =A0It
> > *seems* as though the corruption is coming during truncation, but a=
ll our
> > efforts to reproduce this with small test cases have so far failed.
> >
> > We're using a 2.6.26 code base, with most of the latest ext4 patche=
s
> > applied.
> >
> > Any insights/ruminations/guesses as to what might be happening are =
welcome.
> >
> > Thanks,
> > Curt
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
