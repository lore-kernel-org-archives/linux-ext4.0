From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Restoring filenames from partly damaged ext4-filesystem
Date: Fri, 10 Feb 2012 16:32:37 -0500
Message-ID: <20120210213237.GF5381@thunk.org>
References: <1328804993.34330.YahooMailNeo@web132403.mail.ird.yahoo.com>
 <B43723CA-78A5-416D-B44F-3018CE981211@mit.edu>
 <1328899012.92220.YahooMailNeo@web132404.mail.ird.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"debian-user@lists.debian.org" <debian-user@lists.debian.org>
To: Rudolf Zran <rudolfzran@yahoo.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55947 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab2BJVcj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Feb 2012 16:32:39 -0500
Content-Disposition: inline
In-Reply-To: <1328899012.92220.YahooMailNeo@web132404.mail.ird.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 10, 2012 at 06:36:52PM +0000, Rudolf Zran wrote:
> >> * "fsck.ext4 -b $SBOK -B 4096 -v -y /dev/loop0" recoveres after a =
long time.
> >> =C2=A0 Filesystem is mountable. Root is empty besides lost+found f=
older, which
> >> =C2=A0 contains about 300GB mostly useless data: Millions of files=
 with wrong
> >> =C2=A0 permissions, useless names and some random content.
>=20
> > I'd do this by making a copy of the file system first, of course=E2=
=80=A6.

I would have expected at least some subdirectories from your directory
hierarcy that contained useful content.

Just to set expectations, things that you might do that tried to look
for directory blocks, etc., *might* give you more useful filenames as
opposed to random inode numbers in lost+found, but it's unlikely to
recover any more *files*.  It sounds most of your files were located
in part of the inode table that got smashed, and so short of looking
at each data block to find useful bits, I doubt spending a lot of time
on trying to use or create more recovery tools based on file system
metadata is likely to result in more data getting recovered.

	    	      	     	     - Ted

P.S.  e2fsck -n by definition opens the block device read-only, so
it's not at all surprising you couldn't mount it after e2fsck -n; it
wouldn't have changed anything.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
