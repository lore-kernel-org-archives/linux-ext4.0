From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] [EXT4] super.c: unused variable warning without
 CONFIG_QUOTA
Date: Mon, 23 Apr 2012 21:39:56 -0400
Message-ID: <20120424013956.GB18865@thunk.org>
References: <1335109852-17829-1-git-send-email-eldad@fogrefinery.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Eldad Zack <eldad@fogrefinery.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40966 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756150Ab2DXBj7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Apr 2012 21:39:59 -0400
Content-Disposition: inline
In-Reply-To: <1335109852-17829-1-git-send-email-eldad@fogrefinery.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 22, 2012 at 05:50:52PM +0200, Eldad Zack wrote:
> sb info is only checked with quota support.
>=20
> fs/ext4/super.c: In function =E2=80=98parse_options=E2=80=99:
> fs/ext4/super.c:1600:23: warning: unused variable =E2=80=98sbi=E2=80=99=
 [-Wunused-variable]
>=20
> Signed-off-by: Eldad Zack <eldad@fogrefinery.com>

Thanks, applied.

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
