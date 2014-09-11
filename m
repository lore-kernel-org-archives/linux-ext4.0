From: TR Reardon <thomas_reardon@hotmail.com>
Subject: RE: possible different donor file naming in e4defrag
Date: Thu, 11 Sep 2014 15:48:02 -0400
Message-ID: <BAY179-W923915B59A3302CF7A1CB0FDCC0@phx.gbl>
References: <BLU436-SMTP2540BD5998FEB4A3695A2E4FDE90@phx.gbl>
 <20140815203909.GM2808@birch.djwong.org>
 <BAY179-W62818B481ECC21D8121A2FFDE90@phx.gbl>,<4DF4149D-9995-475D-B25E-DAE799DE6100@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bay004-omc3s1.hotmail.com ([65.54.190.139]:62915 "EHLO
	BAY004-OMC3S1.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbaIKTsD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Sep 2014 15:48:03 -0400
In-Reply-To: <4DF4149D-9995-475D-B25E-DAE799DE6100@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Picking this back up. =A0How would O_TMPFILE avoid races? =A0It definit=
ely avoids the unwanted mtime/atime update, but then the existing "<fil=
ename>.defrag" pseudo-lock file would no longer be available. =A0How co=
uld you use O_TMPFILE and still avoid multiple defrag? =A0If this isn't=
 possible, then resetting the parent times on unlink(tmpfile), as you s=
uggest, is the simplest way out of this.

+Reardon

> From: adilger@dilger.ca
> Subject: Re: possible different donor file naming in e4defrag
> Date: Fri, 15 Aug 2014 23:04:21 +0200
> To: thomas_reardon@hotmail.com
>
> The reason the donor file is created in the same directory as the sou=
rce is to try and keep the block allocation policy consistent with the =
original inode.
>
> You may not need a SIGINT handler, since the timestamp could be reset=
 as soon as the file is created and unlinked.
>
> It may also be possible to use O_TMPFILE on newer kernels to create t=
he donor file to avoid any races?
>
> Cheers, Andreas
>

 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
