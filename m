From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: Problems with the max value for create directory
Date: Tue, 23 Dec 2008 13:02:25 +0900
Message-ID: <495062D1.6010805@jp.fujitsu.com>
References: <495054DE.9030405@cn.fujitsu.com>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49752 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbYLWECh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Dec 2008 23:02:37 -0500
Received: from mt1.gw.fujitsu.co.jp ([10.0.50.74])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id mBN42Xxb015441
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Tue, 23 Dec 2008 13:02:33 +0900
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 6DF8945DE4F
	for <linux-ext4@vger.kernel.org>; Tue, 23 Dec 2008 13:02:33 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 4C20045DD7A
	for <linux-ext4@vger.kernel.org>; Tue, 23 Dec 2008 13:02:33 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 31F5A1DB8013
	for <linux-ext4@vger.kernel.org>; Tue, 23 Dec 2008 13:02:33 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.249.87.104])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id E1A791DB8018
	for <linux-ext4@vger.kernel.org>; Tue, 23 Dec 2008 13:02:32 +0900 (JST)
In-Reply-To: <495054DE.9030405@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Zhang Xiliang wrote:
> Hi,
>=20
> I creat 65537 long directories and failed when the block size is 1024=
=2E
>=20
> # mkfs.ext4dev -b 1024 -I 256 /dev/hda3
> # tune2fs -E test_fs -O extents /dev/hda3
> # mount -t ext4dev /dev/hda3 /mnt
> # ./create_long_dirs 65537 /mnt
>=20
> The code of create_long_dirs.c:

ext4 filesystem cannot make over 65000 links toward a file.
(ext3 filesystem cannot make over 32000 links toward a file.)
This test makes over 65000 links toward /mnt-directory.
(Creating 65000 sub-directories makes 65000 links toward /mnt-directory=
=2E)

static int ext4_mkdir(struct inode *dir, struct dentry *dentry, int mod=
e)
{
          handle_t *handle;
          struct inode *inode;
          struct buffer_head *dir_block;
          struct ext4_dir_entry_2 *de;
          int err, retries =3D 0;

          if (EXT4_DIR_LINK_MAX(dir))
=E3=80=80=E3=80=80=E3=80=80=E3=80=80=E3=80=80^^^^^^^^^^^^^^^^^^^^^^^^^^=
^=E3=80=80=E3=80=80=E3=80=80=E3=80=80
                  return -EMLINK;

This limit is ext4's specification.

Regards,
Toshiyuki Okajima

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
