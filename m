From: Theodore Tso <tytso@mit.edu>
Subject: Re: Severe data corruption with ext4
Date: Mon, 23 Mar 2009 11:08:04 -0400
Message-ID: <20090323150804.GG13368@mit.edu>
References: <20090320030121.1fa8e6d3.akpm@linux-foundation.org> <b2080d80903220626s5fffdbf3i907cb4b215670ce6@mail.gmail.com> <b2080d80903200244u7fbcc150g6724a84c9b3b2054@mail.gmail.com> <20090323020522.GF29466@mit.edu> <b2080d80903230210w60d48530n9b98fdf71cf6fd18@mail.gmail.com> <20090323121709.GD13368@mit.edu> <b2080d80903230720m16af65c4t992b9cc34c44b914@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Richard =?iso-8859-1?Q?H=F6chenberger?= <richard@r-selected.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33498 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755868AbZCWPIJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Mar 2009 11:08:09 -0400
Content-Disposition: inline
In-Reply-To: <b2080d80903230720m16af65c4t992b9cc34c44b914@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 23, 2009 at 03:20:03PM +0100, Richard H=F6chenberger wrote:
> Hi Ted, I just compiled and installed 2.6.29-rc8 vanilla. Before
> running it, I booted from a live CD and fsck'd all my file systems to
> get them into a consistent, clean state.
>=20
> Now, after booting 2.6.29-rc8 and writing stuff to dm-14 (/usr), I ag=
ain get:
>=20
> ----------
> Mar 23 15:01:02 bakunin kernel: __find_get_block_slow() failed.
> block=3D135274289954816, b_blocknr=3D0
> Mar 23 15:01:02 bakunin kernel: b_state=3D0x00310021, b_size=3D4096
> Mar 23 15:01:02 bakunin kernel: device blocksize: 4096
> Mar 23 15:01:02 bakunin kernel: __find_get_block_slow() failed.
> block=3D135274289954816, b_blocknr=3D0
> Mar 23 15:01:02 bakunin kernel: b_state=3D0x00310021, b_size=3D4096
> Mar 23 15:01:02 bakunin kernel: device blocksize: 4096
> Mar 23 15:01:02 bakunin kernel: grow_buffers: requested out-of-range
> block 135274289954816 for device dm-14
> Mar 23 15:01:02 bakunin kernel: EXT4-fs error (device dm-14):
> ext4_xattr_delete_inode: inode 4501: block 135274289954816 read error
> ----------

Hmm, so the block number is: 7B0800000000 that indicats that
i_file_acl is 0, but the bits in i_file_acl_high are set.  E2fsck
doesn't currently detect and fix this case --- which is a bug in
e2fsck that I'll fix --- but it begs the question how the
i_file_acl_high could have gotten set in the first place.

Was this a freshly created ext4 filesystem, or one that was converted
from ext3?

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
