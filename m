From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: 2.6.20 ext3 rename() returns success but doesn't unlink the source
Date: Fri, 23 Mar 2007 17:45:16 -0600
Message-ID: <20070323234516.GH5967@schatzie.adilger.int>
References: <1174670127.10004.14.camel@hurina> <460453B3.2020304@yahoo.fr> <1174691913.10004.71.camel@hurina>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Guillaume Chazarain <guichaz@yahoo.fr>, linux-ext4@vger.kernel.org
To: Timo Sirainen <tss@iki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:46371 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbXCWXpS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Mar 2007 19:45:18 -0400
Content-Disposition: inline
In-Reply-To: <1174691913.10004.71.camel@hurina>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mar 24, 2007  01:18 +0200, Timo Sirainen wrote:
> On Fri, 2007-03-23 at 23:24 +0100, Guillaume Chazarain wrote:
> > Timo Sirainen a =E9crit :
> >=20
> > > 	rename("/mnt/Maildir/.Trash/new/1174635781.P25986Q0M341350.hurin=
a",
> > > 	       "/mnt/Maildir/.Trash/cur/1174635781.P25986Q0M341350.hurin=
a:2,");
> >=20
> > $ ls -li /mnt/Maildir/.Trash/new/1174635781.P25986Q0M341350.hurina =
/mnt/Maildir/.Trash/cur/1174635781.P25986Q0M341350.hurina:2,
> > 122481 -rw------- 2 1000 1000 3091 Mar 23 08:43 /mnt/Maildir/.Trash=
/cur/1174635781.P25986Q0M341350.hurina:2,
> > 122481 -rw------- 2 1000 1000 3091 Mar 23 08:43 /mnt/Maildir/.Trash=
/new/1174635781.P25986Q0M341350.hurina
> >=20
> > All your files in the list are hard linked.
> > http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;=
a=3Dblob;f=3Dfs/namei.c;h=3Dee60cc4d3453209723d6f70982e7083d7cb39477;hb=
=3DHEAD#l2447
> > seems to handle your case as you see it:
> > if (old_dentry->d_inode =3D=3D new_dentry->d_inode)
> > 	return 0;
>=20
> Hmm. Oh. So this is this intentional? First I ever heard of it, and a=
lso
> goes against my logic. I'll go complain to man pages people then. Thi=
s
> will make my error handling difficult..

Yes, it is a very counter-intuitive requirement in the POSIX spec.  The
GNU user tools do what is expected (unlink the source file).

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
