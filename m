From: Ivan Shmakov <ivan@gray.siamics.net>
Subject: e2dis example usage pattern
Date: Thu, 18 Aug 2011 11:25:17 +0700
Message-ID: <868vqrxs5u.fsf_-_@gray.siamics.net>
References: <86aab94mfg.fsf@gray.siamics.net>
	<20110817183101.GC6901@thunk.org> <86mxf7yirb.fsf@gray.siamics.net>
	<20110817220953.GD6901@thunk.org>
	<CADxeRw=pV_6Ey0hQhK2dUkbQMnJwhb+NM4TMxECkZGuuqptrOA@mail.gmail.com>
Reply-To: Ivan Shmakov <oneingray@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: debian-devel@lists.debian.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:51814 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750Ab1HREZi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Aug 2011 00:25:38 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1QtuAh-0003bz-0N
	for linux-ext4@vger.kernel.org; Thu, 18 Aug 2011 06:25:35 +0200
Received: from gray.am-1.org ([188.120.231.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 18 Aug 2011 06:25:34 +0200
Received: from oneingray by gray.am-1.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 18 Aug 2011 06:25:34 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> Steven Liu <lingjiujianke@gmail.com> writes:
>>>>> 2011/8/18 Ted Ts'o <tytso@mit.edu>:
>>>>> On Thu, Aug 18, 2011 at 01:50:48AM +0700, Ivan Shmakov wrote:

	(Crossposting to debian-devel@, as there may be interested
	parties there as well.)

[=E2=80=A6]

 >>> The code I've posted earlier is used in my e2dis [1=E2=80=933] pro=
ject.

 >>> [1] http://article.gmane.org/gmane.linux.debian.devel.general/1644=
88
 >>> [2] http://article.gmane.org/gmane.comp.file-systems.ext4/27269
 >>> [3] https://gitorious.org/e2dis/

[=E2=80=A6]

 > Do you want use mkfs.ext2 to make a small ext2 image file and write
 > the image to mmc or some devices?

 > when you write it to block device, the tool can modify the sb info
 > about the file system size?

[=E2=80=A6]

 > Is this?

	For that purpose, I'd probably use resize2fs(8).

	However, my intent is different.  Namely, my aim is to provide a
	Jigdo-like [4] tool for Ext2+ FS, to be used to reduce the
	burden to store and distribute Ext2+ FS images over the
	Internet.

	The example use for the tool would be as follows:

	=E2=80=A2 one prepares a Debian GNU/Linux =E2=80=9CLive=E2=80=9D image=
 (to be written to
	  a removable USB Flash medium, or used in =E2=80=9Cvirtualized=E2=80=9D
	  environments);

	=E2=80=A2 the typical size of such an image is 1 GiB; it's cumbersome =
to
	  host, especially if one considers hosting an image for each
	  architecture (say, IA-32, AMD64, and ARM), suite (say, Debian
	  stable, testing and unstable) and variant (say, Gnome, KDE,
	  LXDE; thus totalling to 27 images);

	=E2=80=A2 however, most of the files on such images would bytewise mat=
ch
	  those in the .deb packages, which are universally available;

	=E2=80=A2 therefore, one prepares a /mapping/ of the Ext2+ FS image
	  locations to the files contained within the .deb packages;

	=E2=80=A2 this mapping, along with a compressed data of the parts of t=
he
	  image for which no corresponding file is known (free blocks,
	  FS service areas, files generated at the installation time,
	  etc.) is hosted on an HTTP server for distribution;

	=E2=80=A2 anyone interested in such an image downloads the mapping, th=
e
	  compressed =E2=80=9Cdry remainder=E2=80=9D of the image, and starts =
the image
	  download and reassembly software (yet to be developed);

	=E2=80=A2 this software downloads the necessary .deb files off the
	  nearby Debian mirror, extracts the files therein, and uses
	  them to =E2=80=9Cfill the gaps=E2=80=9D within the dry remainder;

	=E2=80=A2 this results in an exact (bytewise) copy of the image
	  processed earlier with e2dis.

	In addition to Jigdo, the operation of the suite is not unlike
	that of the software supporting Metalink [5=E2=80=937].

[4] http://atterer.org/jigdo/
[5] http://en.wikipedia.org/wiki/Metalink
[6] http://www.metalinker.org/
[7] http://www.rfc-editor.org/rfc/rfc5854.txt

--=20
=46SF associate member #7257	Coming soon: Software Freedom Day
http://mail.sf-day.org/lists/listinfo/ planning-ru (ru), sfd-discuss (e=
n)

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
