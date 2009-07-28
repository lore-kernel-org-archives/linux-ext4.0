From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix build warning when EXT4FS_DEBUG is on
Date: Mon, 27 Jul 2009 21:47:26 -0400
Message-ID: <20090728014726.GB31679@mit.edu>
References: <1248024057-21418-1-git-send-email-bergwolf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38284 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbZG1Brb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Jul 2009 21:47:31 -0400
Content-Disposition: inline
In-Reply-To: <1248024057-21418-1-git-send-email-bergwolf@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 20, 2009 at 01:20:57AM +0800, Peng Tao wrote:
> When compiling with EXT4FS_DEBUG on, gcc will complain with following=
 warnings:
>=20
> linux-2.6/fs/ext4/ialloc.c: In function =E2=80=98ext4_count_free_inod=
es=E2=80=99:
> linux-2.6/fs/ext4/ialloc.c:1192: warning: format =E2=80=98%lu=E2=80=99=
 expects type
> =E2=80=98long unsigned int=E2=80=99, but argument 2 has type =E2=80=98=
ext4_group_t=E2=80=99
>=20
> So add a type cast to suppress it.=20
>=20
> Signed-off-by: Peng Tao <bergwolf@gmail.com>

Thanks, applied to the ext4 patch queue.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
