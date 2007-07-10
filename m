From: coly li <colyli@gmail.com>
Subject: Re: block groups with no inode tables
Date: Wed, 11 Jul 2007 01:30:05 +0800
Message-ID: <1184088605.17636.1.camel@colyt43.site>
References: <20070710121221.5478a1e3@rx8>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.183]:59531 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301AbXGJRde (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Jul 2007 13:33:34 -0400
Received: by ik-out-1112.google.com with SMTP id b32so944057ika
        for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 10:33:33 -0700 (PDT)
In-Reply-To: <20070710121221.5478a1e3@rx8>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi, once we decide to do this, how about storing inode inside the
directory ?

IMHO, the latter one is more attractive :-)

Coly

=E5=9C=A8 2007-07-10=E4=BA=8C=E7=9A=84 12:12 -0500=EF=BC=8CJose R. Sant=
os=E5=86=99=E9=81=93=EF=BC=9A
> Hi folks,
>=20
> As I play with the allocation of the metadata for the FLEX_BG feature=
,
> it seems that we could benefit from having block groups with no inode
> tables.  Right now we allocate one inode table per bg base on the
> inode_blocks_per_group.  For FLEX_BG though, it would make more sense
> to have a larger inode tables that fully use the inode bitmap allocat=
ed
> on the first few block groups.  Once we reach the number of inode per
> FLEX_BG, then the remaining block groups could then have no inode
> tables defined.
>=20
> The idea here is that we better utilize the inode bitmaps and reduce =
the
> number of inode tables to improve mkfs/fsck times. We could also
> support expansion of inode since we have block groups that have empty
> entries in the block group descriptors and as long as we can find
> enough empty blocks for the inode table expanding the number of inode=
s
> should be relatively easy.
>=20
> Don't know if ext4 currently supports this.  Any thoughts?
>=20
> -JRS
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
