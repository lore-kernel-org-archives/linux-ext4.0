From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: Bad performance results with the latest git patches
Date: Mon, 10 Sep 2007 13:39:40 +0200
Message-ID: <46E52CFC.7080900@bull.net>
References: <46E1430F.3050702@bull.net> <20070907213716.GH5377@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:53145 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207AbXIJLj3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Sep 2007 07:39:29 -0400
In-Reply-To: <20070907213716.GH5377@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> The problem was in the recently-added "extent sanity checks", and has
> also been fixed:
>=20
> Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
> Signed-off-by: Alex Tomas <alex@clusterfs.com>
> Signed-off-by: Johann Lombardi <johann@clusterfs.com>
>=20
> diff -u linux-2.6.18.8/fs/ext3/extents.c linux-2.6.18.8/fs/ext3/exten=
ts.c
> --- linux-2.6.18.8/fs/ext3/extents.c	2007-06-20 18:54:00.000000000 +0=
200
> +++ linux-2.6.18.8/fs/ext3/extents.c	2007-06-20 18:54:00.000000000 +0=
200
> @@ -1069,7 +1069,7 @@ ext3_ext_search_right(struct inode *inode,
>  		if (bh =3D=3D NULL)
>  			return -EIO;
>  		eh =3D ext_block_hdr(bh);
> -		if (ext3_ext_check_header(inode, eh, depth)) {
> +		if (ext3_ext_check_header(inode, eh, path->p_depth - depth)) {
>  			brelse(bh);
>  			return -EIO;
>  		}
>=20
Thanks Andreas, I confirm this patch fixes the problem.
   Val=E9rie
