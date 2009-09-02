From: Andreas Dilger <adilger@sun.com>
Subject: Re: large file system & high object count testing
Date: Wed, 02 Sep 2009 03:15:40 -0600
Message-ID: <20090902091540.GR4197@webber.adilger.int>
References: <4A9BFB88.5030409@redhat.com> <4A9C0220.1040503@redhat.com>
 <20090831205608.GE4197@webber.adilger.int> <4A9C3A7B.3050302@redhat.com>
 <150c16850908311425vbc1c0a1if2a7d8ed56f650f5@mail.gmail.com>
 <20090831231331.GJ4197@webber.adilger.int>
 <150c16850908311637t18683386j66bcebd06fe05e9b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org,
	"Ted Ts'o" <tytso@thunk.org>
To: Justin Maggard <jmaggard10@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:63352 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbZIBJPk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Sep 2009 05:15:40 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n829FVBA019176
	for <linux-ext4@vger.kernel.org>; Wed, 2 Sep 2009 02:15:31 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KPC00M006XJNU00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Wed,
 02 Sep 2009 02:15:31 -0700 (PDT)
In-reply-to: <150c16850908311637t18683386j66bcebd06fe05e9b@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 31, 2009  16:37 -0700, Justin Maggard wrote:
> On Mon, Aug 31, 2009 at 4:13 PM, Andreas Dilger<adilger@sun.com> wrot=
e:
> > Justin, could you please replicate this corruption, collecting some
> > additional information before & after. =A0My recollection is that t=
he
> > corruption appears in the first few groups, so 64kB should be plent=
y
> > to capture the group descriptor tables (where the checksum is kept)=
=2E
> >
> > - mke2fs
> > - dd if=3D/dev/XXX bs=3D4k count=3D16 | gzip -9 > /tmp/gdt-new.gz
> > - mkdir ...
> > - sync
> > - dd if=3D/dev/XXX bs=3D4k count=3D16 | gzip -9 > /tmp/gdt-mkdir.gz
> > - umount
> > - dd if=3D/dev/XXX bs=3D4k count=3D16 | gzip -9 > /tmp/gdt-umount.g=
z
> > - e2fsck
> > - dd if=3D/dev/XXX bs=3D4k count=3D16 | gzip -9 > /tmp/gdt-e2fsck.g=
z
> >
>=20
> No problem.  I just sent you an email with those four attached.  If
> anyone would like me to upload them somewhere else, just let me know.

Comparing the GDT dumps you gave makes it fairly clear what is wrong:

--- gdt-umount.od       2009-09-02 02:54:40.148704651 -0600
+++ gdt-e2fsck.od       2009-09-02 02:54:54.809699151 -0600
 001000 00000ee5 00000ef5 00000f05 07f568f0
 001010 00040002 00000000 00000000 339107f5
 001020 00000000 00000000 00000000 00000000
-*
+001030 00000000 00000000 00000000 000007fe

It seems that e2fsck isn't keeping one of the reserved fields zero,
so this is confusing the checksum.

truct ext4_group_desc
{
:
:
/*30*/  __le16  bg_used_dirs_count_hi;  /* Directories count MSB */
        __le16  bg_itable_unused_hi;    /* Unused inodes count MSB */
        __u32   bg_reserved2[3];
}

The bg_reserved[2] field is being changed incorrectly.

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
