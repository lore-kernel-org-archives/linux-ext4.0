From: Guillaume Chazarain <guichaz@yahoo.fr>
Subject: Re: 2.6.20 ext3 rename() returns success but doesn't unlink the source
Date: Fri, 23 Mar 2007 23:24:51 +0100
Message-ID: <460453B3.2020304@yahoo.fr>
References: <1174670127.10004.14.camel@hurina>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Timo Sirainen <tss@iki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sophia.inria.fr ([138.96.64.20]:41032 "EHLO sophia.inria.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbXCWXwr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Mar 2007 19:52:47 -0400
In-Reply-To: <1174670127.10004.14.camel@hurina>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Timo Sirainen a =E9crit :

> 	rename("/mnt/Maildir/.Trash/new/1174635781.P25986Q0M341350.hurina",
> 	       "/mnt/Maildir/.Trash/cur/1174635781.P25986Q0M341350.hurina:2,=
");

$ ls -li /mnt/Maildir/.Trash/new/1174635781.P25986Q0M341350.hurina /mnt=
/Maildir/.Trash/cur/1174635781.P25986Q0M341350.hurina:2,
122481 -rw------- 2 1000 1000 3091 Mar 23 08:43 /mnt/Maildir/.Trash/cur=
/1174635781.P25986Q0M341350.hurina:2,
122481 -rw------- 2 1000 1000 3091 Mar 23 08:43 /mnt/Maildir/.Trash/new=
/1174635781.P25986Q0M341350.hurina

All your files in the list are hard linked.
http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
blob;f=3Dfs/namei.c;h=3Dee60cc4d3453209723d6f70982e7083d7cb39477;hb=3DH=
EAD#l2447
seems to handle your case as you see it:
if (old_dentry->d_inode =3D=3D new_dentry->d_inode)
	return 0;

Regards.

--=20
Guillaume
