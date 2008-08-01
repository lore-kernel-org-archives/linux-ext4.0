From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH v3]Ext4: journal credits reservation fixes for DIO,
	fallocate and delalloc writepages
Date: Fri, 01 Aug 2008 11:08:13 -0700
Message-ID: <1217614093.12413.21.camel@mingming-laptop>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker>
	 <1216774311.6505.4.camel@mingming-laptop>
	 <20080723074226.GA15091@skywalker>
	 <1217032947.6394.2.camel@mingming-laptop>
	 <1217383118.27664.14.camel@mingming-laptop>
	 <1217417361.3373.15.camel@localhost>
	 <1217527631.6317.6.camel@mingming-laptop>  <20080801054932.GF8736@mit.edu>
	 <1217587902.3280.10.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	Shehjar Tikoo <shehjart@cse.unsw.edu.au>,
	linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@sun.com>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52509 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbYHASI0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Aug 2008 14:08:26 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m71IAj0r018473
	for <linux-ext4@vger.kernel.org>; Fri, 1 Aug 2008 14:10:45 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m71I8DTg188968
	for <linux-ext4@vger.kernel.org>; Fri, 1 Aug 2008 14:08:13 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m71I8CKT010858
	for <linux-ext4@vger.kernel.org>; Fri, 1 Aug 2008 14:08:13 -0400
In-Reply-To: <1217587902.3280.10.camel@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-01=E4=BA=94=E7=9A=84 12:51 +0200=EF=BC=8CFr=C3=A9d=C3=
=A9ric Boh=C3=A9=E5=86=99=E9=81=93=EF=BC=9A

> Thanks Ted. With this patch, I don't have a crash anymore, but I have
> some messages :
>=20
> EXT4 Inode eedb4228: orphan list check failed!

> Pid: 7092, comm: bonnie++ Not tainted 2.6.27-rc1 #6
>  [<f8b719ee>] ext4_destroy_inode+0x5e/0x70 [ext4dev]
>  [<c018f820>] destroy_inode+0x20/0x40
>  [<c018f4a4>] iput+0x44/0x50
>  [<c0186271>] do_unlinkat+0xd1/0x150
>  [<c017cdd6>] vfs_write+0x106/0x140
>  [<c02aa7b0>] tty_write+0x0/0x1e0
>  [<c017d2d1>] sys_write+0x41/0x70
>  [<c0102fc9>] sysenter_do_call+0x12/0x25


The warining is inode is not removed from orphan list at the time
destroy_inode(). I suspect there is failure returned from
ext4_delete_inode()->ext4_orphan_del(), but not sure how Ted's change
triggered this. Still looking.

Mingming

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
