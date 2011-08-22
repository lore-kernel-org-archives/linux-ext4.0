From: Ted Ts'o <tytso@mit.edu>
Subject: Re: e2p_blocks_count () vs. ext2fs_blocks_count ()
Date: Mon, 22 Aug 2011 12:33:29 -0400
Message-ID: <20110822163329.GC3671@thunk.org>
References: <864o1at9eo.fsf@gray.siamics.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Ivan Shmakov <oneingray@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58105 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781Ab1HVQda (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Aug 2011 12:33:30 -0400
Content-Disposition: inline
In-Reply-To: <864o1at9eo.fsf@gray.siamics.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 22, 2011 at 10:25:19AM +0700, Ivan Shmakov wrote:
> 	Apparently, e2p_blocks_count (), a =E2=80=98static=E2=80=99 function=
 in
> 	lib/e2p/ls.c, duplicates the public ext2fs_blocks_count () one
> 	(lib/ext2fs/blknum.c) as of d4c0d8e5.  The same holds for
> 	e2p_r_blocks_count () and e2p_free_blocks_count ().
>=20
> 	The code is, as it seems, exactly the same.
>=20
> 	I wonder, isn't there a problem?

That's deliberate; the goal was to make libe2p not dependent on
libext2fs, so that programs such as lsattr don't need to pull in
libext2fs.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
