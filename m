From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 fs errors - immediately reboot needed ?
Date: Mon, 19 Nov 2012 14:31:34 -0500
Message-ID: <20121119193134.GA30091@thunk.org>
References: <50AA7E55.2090707@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33613 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438Ab2KSTbh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2012 14:31:37 -0500
Content-Disposition: inline
In-Reply-To: <50AA7E55.2090707@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 19, 2012 at 07:45:41PM +0100, Toralf F=F6rster wrote:
> /me wonders, whether the following messages should force me to *immed=
iately*
> reboot the system of whether I should schedule a reboot in the near f=
uture :

In general, if you're not sure, the answer is yes....

> 2012-11-19T19:37:20.188+01:00 n22 kernel: EXT4-fs error (device sdb3)=
 in ext4_new_inode:933: IO failure

This means that you have some kind of hardware or media error,
probably in an inode bitmap block.  There are some planned patches to
try to isolate out failures when reading from a block or inode bitmap,
but they aren't yet in mainline yet.

> 2012-11-19T19:44:33.734+01:00 n22 kernel: EXT4-fs error (device sdb3)=
: mb_free_blocks:1300: group 424, block 13916749:freeing already freed =
block (bit 23117)

This means you have a corrupted block bitmap block.  When deleting a
file, we found that some data blocks that should have been marked as
in use, were marked as freed.  That's actually not dangerous, but it's
likely that if you have this problem, that you might have the reverse,
which is a data block which should be marked as in use, but was marked
as freed.  The reason why is dangerous is because ext4 might decide to
allocate a block which is still in use, which would lead to data loss
when that block is reused.

Some future patches might make it safe(r) to continue after seeing
this error (by preventing any allocations from that block group), but
even then, you're probably going to be better off forcing an fsck run
as soon as possible.  For now, I would strongly recommend it.

Regards,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
