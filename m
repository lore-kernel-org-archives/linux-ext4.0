From: Maxim Patlasov <maxim.patlasov@gmail.com>
Subject: Re: [PATCH] ext4: ext4_free_blocks() fix
Date: Fri, 10 Jun 2011 14:17:30 +0400
Message-ID: <BANLkTinZ5Lw0R9Nf1Un_gEA8DZqo7y15TA@mail.gmail.com>
References: <1307700474-25743-1-git-send-email-maxim.patlasov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64718 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab1FJKRb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jun 2011 06:17:31 -0400
In-Reply-To: <1307700474-25743-1-git-send-email-maxim.patlasov@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I apologise for flooding, patch description in former email was for
slightly different kernel version. Correct description is below:

Existent implementation of ext4_free_blocks() always calls dquot_free_b=
lock
This looks quite sensible in the most cases: blocks to be freed are ass=
ociated
with inode and were accounted in quota and i_blocks some time ago.

However, there is a case when blocks to free were not accounted by the =
time
calling ext4_free_blocks() yet:

1. delalloc is on, write_begin pre-allocated some space in quota
2. write-back happens, ext4 allocates some blocks in ext4_ext_map_block=
s()
3. then ext4_ext_map_blocks() gets an error (e.g.  ENOSPC) from
   ext4_ext_insert_extent() and calls ext4_free_blocks().

In this scenario, ext4_free_blocks() calls dquot_free_block() who, in t=
urn,
decrements i_blocks for blocks which were not accounted yet (due to del=
alloc)
After clean umount, e2fsck reports something like:

> Inode 21, i_blocks is 5080, should be 5128.  Fix<y>?
because i_blocks was erroneously decremented as explained above.

The patch fixes the problem by passing EXT4_FREE_BLOCKS_SKIP_QUPD flag =
to
ext4_free_blocks(). This flag forces ext4_free_blocks() to skip
dquot_free_block() call.

Signed-off-by: Maxim Patlasov <maxim.patlasov@gmail.com>

On Fri, Jun 10, 2011 at 2:07 PM, Maxim Patlasov
<maxim.patlasov@gmail.com> wrote:
> Existent implementation of ext4_free_blocks() always calls vfs_dq_fre=
e_block
> This looks quite sensible in the most cases: blocks to be freed are a=
ssociated
> with inode and were accounted in quota and i_blocks some time ago.
>
> However, there is a case when blocks to free were not accounted by th=
e time
> calling ext4_free_blocks() yet:
>
> 1. delalloc is on, write_begin pre-allocated some space in quota
> 2. write-back happens, ext4 allocates some blocks in ext4_ext_get_blo=
cks()
> 3. then ext4_ext_get_blocks() gets an error (e.g. =A0ENOSPC) from
> =A0 ext4_ext_insert_extent() and calls ext4_free_blocks().
>
> In this scenario, ext4_free_blocks() calls vfs_dq_free_block() who, i=
n turn,
> decrements i_blocks for blocks which were not accounted yet (due to d=
elalloc)
> After clean umount, e2fsck reports something like:
>
>> Inode 21, i_blocks is 5080, should be 5128. =A0Fix<y>?
> because i_blocks was erroneously decremented as explained above.
>
> The patch fixes the problem by passing EXT4_FREE_BLOCKS_SKIP_QUPD fla=
g to
> ext4_free_blocks(). This flag forces ext4_free_blocks() to skip
> vfs_dq_free_block() call.
>
> Signed-off-by: Maxim Patlasov <maxim.patlasov@gmail.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
