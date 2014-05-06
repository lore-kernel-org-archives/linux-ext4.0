From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: Re: Why does not freeblocks number change after deleting a big file?
Date: Tue, 6 May 2014 13:57:48 +0400
Message-ID: <20140506095748.GD23108@azat>
References: <536857BC.3010002@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Younger Liu <younger.liucn@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:35558 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934608AbaEFJ57 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 May 2014 05:57:59 -0400
Received: by mail-lb0-f170.google.com with SMTP id w7so1868608lbi.15
        for <linux-ext4@vger.kernel.org>; Tue, 06 May 2014 02:57:57 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <536857BC.3010002@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 06, 2014 at 11:32:12AM +0800, Younger Liu wrote:
> Hi:
>   Analyze ext4 filesystem with "debugfs -R "stats" <device>",
> Why does not free blocks number change after deleting a big file?
>=20
> The big file:
> # stat test
>   file=EF=BC=9A"test"
>   size=EF=BC=9A290554084       blocks=EF=BC=9A567496     IO block=EF=BC=
=9A4096
>=20
> before deleting the file "test":
> # debugfs -R "stats" /dev/sdb
> ...
> Inode count:              243593216
> Block count:              1948728320
> Reserved block count:     97436416
> Free blocks:              406830314
> Free inodes:              151667854
> ...
>=20
> deleting the file "test"
> # debugfs -R "stats" /dev/sdb
> ...
> Inode count:              243593216
> Block count:              1948728320
> Reserved block count:     97436416
> Free blocks:              406830314
> Free inodes:              151667854

Hi,

Seems that you are trying to do this on a mounted partition, and the
super block are not dumped to disk after every write/flush.

You could use statfs(2) instead of debugfs/stats command, or "mount -o
remount /dev/sdb_X_" and after debugfs, this _must_ work only in case
you don't have journal.

=46or more information you could look into ext4_commit_super().

> ...
>=20
>      Younger
>      thx.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Respectfully
Azat Khuzhin
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
