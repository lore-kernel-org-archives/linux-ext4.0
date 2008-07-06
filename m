From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] ext4: fix build failure if DX_DEBUG
Date: Sun, 6 Jul 2008 00:07:51 -0400
Message-ID: <20080706040751.GA21990@mit.edu>
References: <484F9030.2020800@cn.fujitsu.com> <484FF75B.8090403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Li Zefan <lizf@cn.fujitsu.com>, Mingming Cao <cmm@us.ibm.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:37727 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808AbYGFEIQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Jul 2008 00:08:16 -0400
Content-Disposition: inline
In-Reply-To: <484FF75B.8090403@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 11, 2008 at 11:03:39AM -0500, Eric Sandeen wrote:
> Li Zefan wrote:
> > I got build failure when I turned on DX_DEBUG.
> >=20
> > fs/ext4/namei.c: In function =E2=80=98dx_show_leaf=E2=80=99:
> > fs/ext4/namei.c:291: error: implicit declaration of function =E2=80=
=98ext4_next_entry=E2=80=99
> > fs/ext4/namei.c:291: warning: assignment makes pointer from integer=
 without a cast
> >=20
> > Move the definition of ext4_next_entry() upwards just as ext3 code.
> >=20
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>=20
> Thanks,  I added this to the bugfix portion of the ext4 patch queue.

But you forgot to edit the series file.  :-)=20

I've fixed in the patch queue, and it will be in the 2.6.26-rc9-ext4-1
patch drop.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
