From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] mke2fs: document bigalloc and cluster-size
Date: Tue, 15 Jan 2013 14:12:54 -0500
Message-ID: <20130115191254.GD17719@thunk.org>
References: <1358068095-9034-1-git-send-email-wenqing.lz@taobao.com>
 <1358068095-9034-3-git-send-email-wenqing.lz@taobao.com>
 <20130115031006.GB31857@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43552 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755589Ab3AOTM5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jan 2013 14:12:57 -0500
Content-Disposition: inline
In-Reply-To: <20130115031006.GB31857@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 14, 2013 at 10:10:06PM -0500, Theodore Ts'o wrote:
> On Sun, Jan 13, 2013 at 05:08:15PM +0800, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> >=20
> > Bigalloc feature has been used for a long time, but the documentati=
on in mke2fs
> > is still missing.  So add it.
> >=20
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
>=20
> Applied (with some changes to improve the english/wording).

BTW, I used the following modified text:

                   bigalloc
                          This  feature  enables clustered allocation, =
so that
                          the unit of allocation is a power of two  num=
ber  of
                          blocks.   That  is,  each bit in the what had=
 tradi=E2=80=90
                          tionally been known as the block  allocation =
 bitmap
                          now  indicates  whether  a cluster is in use =
or not,
                          where a cluster is by default composed of 16 =
blocks.
                          This  feature  can  decrease the time spent o=
n doing
                          block allocation and brings  smaller  fragmen=
tation,
                          especially  for large files.  The size can be=
 speci=E2=80=90
                          fied using the -C option.

                          Warning: The bigalloc feature is still under =
 devel=E2=80=90
                          opment,  and  may  not  be fully supported wi=
th your
                          kernel or may have various bugs.  Please see =
the web
                          page  http://ext4.wiki.kernel.org/index.php/B=
igalloc
                          for details.

And I populated the page on the ext4 wiki so that when we finally fix
the delalloc/bigalloc problem, we can update the ext4 wiki to reflect
this.

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
