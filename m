From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH v3]Ext4: journal credits reservation fixes for DIO,
	fallocate and delalloc writepages
Date: Fri, 01 Aug 2008 11:03:15 -0700
Message-ID: <1217613795.12413.15.camel@mingming-laptop>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker>
	 <1216774311.6505.4.camel@mingming-laptop>
	 <20080723074226.GA15091@skywalker>
	 <1217032947.6394.2.camel@mingming-laptop>
	 <1217383118.27664.14.camel@mingming-laptop>
	 <1217417361.3373.15.camel@localhost>
	 <1217527631.6317.6.camel@mingming-laptop>  <20080801054932.GF8736@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>,
	Shehjar Tikoo <shehjart@cse.unsw.edu.au>,
	linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@sun.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:55191 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbYHASDR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Aug 2008 14:03:17 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m71I3GmF008101
	for <linux-ext4@vger.kernel.org>; Fri, 1 Aug 2008 14:03:16 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m71I3G9H035724
	for <linux-ext4@vger.kernel.org>; Fri, 1 Aug 2008 14:03:16 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m71I3Fce026990
	for <linux-ext4@vger.kernel.org>; Fri, 1 Aug 2008 14:03:16 -0400
In-Reply-To: <20080801054932.GF8736@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Ted, thanks for going through this,

=E5=9C=A8 2008-08-01=E4=BA=94=E7=9A=84 01:49 -0400=EF=BC=8CTheodore Tso=
=E5=86=99=E9=81=93=EF=BC=9A

>     ext4: Fix lack of credits BUG() when deleting a badly fragmented =
inode
>    =20
>     The extents codepath for ext4_truncate() requests journal transac=
tion
>     credits in very small chunks, requesting only what is needed.  Th=
is
>     means there may not be enough credits left on the transaction han=
dle
>     after ext4_truncate() returns and then when ext4_delete_inode() t=
ries
>     finish up its work, it may not have enough transaction credits,
>     causing a BUG() oops in the jbd2 core.

But, ext4_delete_inode()'s transaction and ext4_truncate()'s transactio=
n
are different,  ext4_truncate() transaction is nested inside
ext4_delete_inode.

Inside ext4_delete_inode, the transaction is to log the changes in
ext4_orhan_del() and  ext4_free_inode(). If I get right,
ext4_orhan_del() need credit to modify superblock and inode block,
ext4_free_inode() needs credit for modifying quota,xattr and inode
bitmap, group descriptor, superblock, and inode block.=20

Currently ext4_delete_inode() uses blocks_for_truncate(inode) to
calculate credits, by the time ext4_delete_inode() is called, i_blocks
seems to 0 (I need to double check this). So the credits is just
EXT4_DATA_TRANS_BLOCKS, which take care of the credits for inode,
superblock, xattr and quota, but missing is inode bitmap...I will doubl=
e
check before I post a patch...



>    =20
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c7fb647..6d27e78 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -215,6 +215,18 @@ void ext4_delete_inode (struct inode * inode)
>  	inode->i_size =3D 0;
>  	if (inode->i_blocks)
>  		ext4_truncate(inode);
> +
> +	/*
> +	 * ext4_ext_truncate() doesn't reserve any slop when it
> +	 * restarts journal transactions; therefore there may not be
> +	 * enough credits left in the handle to remove the inode from
> +	 * the orphan list and set the dtime field.
> +	 */
> +	if (ext4_ext_journal_restart(handle, 3)) {
> +		ext4_journal_stop(handle);
> +		goto no_delete;
> +	}
> +
>  	/*
>  	 * Kill off the orphan record which ext4_truncate created.
>  	 * AKPM: I think this can be inside the above `if'.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
