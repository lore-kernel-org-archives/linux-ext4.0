From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: benchmark results
Date: Tue, 29 Dec 2009 12:27:44 +0100
Message-ID: <20091229122744.40a4b707@galadriel.home>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net,
	ext-users <ext3-users@redhat.com>, linux-nilfs@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Le Thu, 24 Dec 2009 02:31:10 -0800 (PST) vous =E9criviez:

>     - btrfs, ext4 are the overall winners
>     - xfs to, but creating/deleting many files was *very* slow

xfs is slow at file creation/deletion if you mount it with barriers on
standard disk drives (not so with hardware RAID controllers).

--=20
-----------------------------------------------------------------------=
-
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
-----------------------------------------------------------------------=
-
--
To unsubscribe from this list: send the line "unsubscribe reiserfs-deve=
l" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
