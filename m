From: =?windows-1252?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
Subject: Re: [PATCH] ext4: fix fencepost error in lazytime optimization
Date: Fri, 03 Jul 2015 14:35:41 +0200
Message-ID: <mn5vit$6bh$1@ger.gmane.org>
References: <1435808288-20665-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48126 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817AbbGCMf7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jul 2015 08:35:59 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1ZB0C9-0005mC-BI
	for linux-ext4@vger.kernel.org; Fri, 03 Jul 2015 14:35:53 +0200
Received: from p4fdf09f2.dip0.t-ipconnect.de ([79.223.9.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 03 Jul 2015 14:35:53 +0200
Received: from jvpeetz by p4fdf09f2.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 03 Jul 2015 14:35:53 +0200
In-Reply-To: <1435808288-20665-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote on 07/02/2015 05:38:
> Commit 8f4d8558391: "ext4: fix lazytime optimization" was not a
> complete fix.  In the case where the inode number is a multiple of 16=
,
> and we could still end up updating an inode with dirty timestamps
> written to the wrong inode on disk.  Oops.
>=20
<snip>
> -	ino =3D (orig_ino & ~(inodes_per_block - 1)) + 1;
> +	ino =3D ((orig_ino - 1) & ~(inodes_per_block - 1)) + 1;

Maybe, a comment stating what should be accomplished here would help?
--=20
Regards,
J=F6rg.


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
