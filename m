From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Oops with ext4 from 2.6.27-rc3
Date: Thu, 14 Aug 2008 07:58:23 -0700
Message-ID: <1218725903.6749.3.camel@mingming-laptop>
References: <47983.10.5.1.205.1218652098.squirrel@webmail.lugor.de>
	 <1218672653.6456.14.camel@mingming-laptop> <20080814015113.GA8078@mit.edu>
	 <200808140859.03171.mail@eworm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Christian Hesse <mail@eworm.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51895 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbYHNO6p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Aug 2008 10:58:45 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7EEwYnF012144
	for <linux-ext4@vger.kernel.org>; Thu, 14 Aug 2008 10:58:34 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7EEwQa9219126
	for <linux-ext4@vger.kernel.org>; Thu, 14 Aug 2008 10:58:26 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7EEwPHN018380
	for <linux-ext4@vger.kernel.org>; Thu, 14 Aug 2008 10:58:26 -0400
In-Reply-To: <200808140859.03171.mail@eworm.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-14=E5=9B=9B=E7=9A=84 08:59 +0200=EF=BC=8CChristian He=
sse=E5=86=99=E9=81=93=EF=BC=9A
> On Thursday 14 August 2008, Theodore Tso wrote:
> > On Wed, Aug 13, 2008 at 05:10:53PM -0700, Mingming Cao wrote:
> > > I could reproduce it.
> > >
> > > This patch works for me on top of Ted's change.  Christian, could=
 you
> > > try it?
> >
> > Thanks, mingming!  Looks good and I've added it to the patch queue.
>=20
> 08:58:16 eworm@io:~$ uptime
>  08:58:18 up 37 min,  2 users,  load average: 3.57, 2.36, 1.12
>=20
> This is *a lot* longer than the system survived without the patches. =
I hope it=20
> is fixed now. Ted and Mingming, thanks a lot!
>=20
> A short side note... I get warnings when compiling the new code:
>=20
> fs/ext4/inode.c: In function 'ext4_da_release_space':
> fs/ext4/inode.c:1581: warning: format '%d' expects type 'int', but ar=
gument 2=20
> has type 'long unsigned int'
> fs/ext4/inode.c:1581: warning: format '%lu' expects type 'long unsign=
ed int',=20
> but argument 3 has type 'int'

Thanks to all for quick verification of the fix.

Here is the fix for the compile warning . This compile warning fix has
be fold to the parent patch in ext4 patch queue :
fix-delalloc-release-block-reservation-for-truncate

http://repo.or.cz/w/ext4-patch-queue.git


Thanks,
Ming,ming

Index: linux-2.6.27-rc3/fs/ext4/inode.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.27-rc3.orig/fs/ext4/inode.c	2008-08-14 07:49:14.000000000=
 -0700
+++ linux-2.6.27-rc3/fs/ext4/inode.c	2008-08-14 07:49:45.000000000 -070=
0
@@ -1576,7 +1576,7 @@ static void ext4_da_release_space(struct
 		 */
 		printk(KERN_INFO "ext4 delalloc try to release %d reserved"
 			    "blocks for inode %lu, but there is no reserved"
-			    "data blocks\n", inode->i_ino, to_free);
+			    "data blocks\n", to_free, inode->i_ino);
 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 		return;
 	}




--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
