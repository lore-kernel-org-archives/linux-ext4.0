From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: add checksum calculation when clearing UNINIT
	flag
Date: Fri, 7 Nov 2008 19:57:18 +0530
Message-ID: <20081107142718.GL25194@skywalker>
References: <1226053376.3542.8.camel@frecb007923.frec.bull.fr> <20081107135222.GB9543@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:49409 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbYKGO1a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2008 09:27:30 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id mA7EQhYv003405
	for <linux-ext4@vger.kernel.org>; Sat, 8 Nov 2008 01:26:43 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA7ERXgV4173850
	for <linux-ext4@vger.kernel.org>; Sat, 8 Nov 2008 01:27:33 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mA7ERSFm022955
	for <linux-ext4@vger.kernel.org>; Sat, 8 Nov 2008 01:27:28 +1100
Content-Disposition: inline
In-Reply-To: <20081107135222.GB9543@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2008 at 08:52:22AM -0500, Theodore Tso wrote:
> On Fri, Nov 07, 2008 at 11:22:56AM +0100, Fr=E9d=E9ric Boh=E9 wrote:
> > From: Frederic Bohe <frederic.bohe@bull.net>
> >=20
> > Block group's checksum need to be re-calculated during the
> > initialization of an UNINIT'd group. This fix a race when several
> > threads try to allocate a new inode in an UNINIT'd group.
>=20
> This patch looks sane, and so I'll accept it, but there's a higher
> order hiding here ---- why are we initializing the block bitmap in
> ext4_new_inode()?  Sure, *most* of the time where we create a new
> inode, we'll be needing to allocate a new block, but sometimes we
> won't (i.e., when creating a symlink, device file, socket, or a
> zero-length regular file). =20

Because when we clear the uninitt_bg flag the kernel expect the block=20
bitmap to be correctly indicate blocks containing block
bitmap and inode bitmap as used. If mke2fs didn't do that we would
need to do the same when we remove the uninit_bg flag.


-aneesh
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
