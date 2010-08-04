From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: [PATCH 14/38] fallthru: ext2 fallthru support
Date: Wed, 4 Aug 2010 18:48:31 -0400
Message-ID: <20100804224831.GB29353@shell>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-15-git-send-email-vaurora@redhat.com> <E1OgfCU-0000ko-Lu@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="zYM0uCDKw75PZbzx"
Cc: viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu, linux-ext4@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585Ab0HDWsq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Aug 2010 18:48:46 -0400
Content-Disposition: inline
In-Reply-To: <E1OgfCU-0000ko-Lu@pomaz-ex.szeredi.hu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 04, 2010 at 04:44:10PM +0200, Miklos Szeredi wrote:
> On Tue, 15 Jun 2010, Valerie Aurora wrote:
> > Add support for fallthru directory entries to ext2.
> 
> If a previously used ext2 filesystem with is mounted again then
> fallthroughs don't appear to work as expected.  Stat returns ENOENT
> for these entries.
> 
> Can't see anything obviously wrong with the code.

Hm, I wrote one test case for this that worked (attached).  Can you
give me more details on your test case?  Thanks,

-VAL

--zYM0uCDKw75PZbzx
Content-Type: application/x-sh
Content-Disposition: attachment; filename="ext2_remount_fallthrus.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0A=0Aecho -n "Check if ext2 fallthrus still fall through after =
a umount/remount... "=0A=0Amount -o ro,loop ./img/ro ./mnt/union=0A=0Add if=
=3D/dev/zero of=3D./img/rw bs=3D4096 seek=3D255 count=3D1 >/dev/null 2>&1=
=0A/sbin/mkfs.ext2 -F -O whiteout,fallthru ./img/rw >/dev/null 2>&1=0Amount=
 -o loop,union ./img/rw ./mnt/union/=0A=0A# Create some fallthrus=0Als ./mn=
t/union/ >/dev/null=0A=0A# See if we can lookup through a fallthru=0Astat .=
/mnt/union/ro_file >/dev/null=0A=0Aif [ "$?" !=3D "0" ]; then=0A    echo "L=
ookup of fallthru failed!"=0A    exit 1=0Afi=0A=0A# Mount it somewhere else=
 and make sure we haven't copied up the file=0Aumount ./mnt/union=0Amount -=
o loop ./img/rw ./mnt/scratch=0A=0Astat ./mnt/scratch/ro_file >/dev/null 2>=
&1=0A=0Aif [ "$?" =3D "0" ]; then=0A    echo "Test won't work, stat copied =
up the file instead of making a fallthru!"=0A    exit 1=0Afi=0A=0A# Unmount=
 it, remount it as a union, see if fallthru still works=0Aumount ./mnt/scra=
tch=0Amount -o loop,union ./img/rw ./mnt/union/=0A=0Astat ./mnt/union/ro_fi=
le >/dev/null=0A=0Aif [ "$?" !=3D "0" ]; then=0A    echo "Lookup of fallthr=
u after umount/mount failed!"=0A    exit 1=0Afi=0A=0Aumount ./mnt/union=0Ai=
f [ "$?" !=3D "0" ]; then=0A    echo "umount failed!"=0A    exit 1=0Afi=0Au=
mount ./mnt/union=0Aif [ "$?" !=3D "0" ]; then=0A    echo "umount failed!"=
=0A    exit 1=0Afi=0A=0Aexit 0=0A
--zYM0uCDKw75PZbzx--
