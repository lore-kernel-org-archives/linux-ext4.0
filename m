From: =?windows-1252?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
Subject: Re: ext4 lazytime: ctime of some files changed
Date: Wed, 20 May 2015 10:48:37 +0200
Message-ID: <555C4A65.5030100@web.de>
References: <55531AE3.7030704@web.de> <mivtkj$fhi$1@ger.gmane.org> <20150514222044.GA3901@thunk.org> <55560D42.2060402@web.de> <20150515231107.GF3901@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43619 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbbETKuJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 May 2015 06:50:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1Yv1Zd-00039K-Hj
	for linux-ext4@vger.kernel.org; Wed, 20 May 2015 12:50:05 +0200
Received: from p5b0a06df.dip0.t-ipconnect.de ([91.10.6.223])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 20 May 2015 12:50:05 +0200
Received: from jvpeetz by p5b0a06df.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 20 May 2015 12:50:05 +0200
In-Reply-To: <20150515231107.GF3901@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Theodore Ts'o wrote on 05/16/2015 01:11:
> On Fri, May 15, 2015 at 05:14:10PM +0200, J=F6rg-Volker Peetz wrote:
>> running nearly two hours without any file timestamp related anomalie=
s while
>> doing some file activity and a sync from time to time :-)
>> Thanks for caring.
>=20
> Many thanks for the bug report!   :-)
>=20
>      	    	    	- Ted

after a few days of running the patch, I seem to have again two files w=
ith
changed mtime without touching them (only reading by rsync).

I took a look into the file fs/ext4/inode.c and saw this code in functi=
on
__ext4_get_inode_loc(struct inode *inode,
				struct ext4_iloc *iloc, int in_mem)
:

		if (in_mem) {
			struct buffer_head *bitmap_bh;
			int i, start;

			start =3D inode_offset & ~(inodes_per_block - 1);

			/* Is the inode bitmap in cache? */
			bitmap_bh =3D sb_getblk(sb, ext4_inode_bitmap(sb, gdp));

I'm not sure, if this is relevant, but just for curiosity, why does "st=
art" here
not need a "+ 1"?
--=20
Regards,
J=F6rg.


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
