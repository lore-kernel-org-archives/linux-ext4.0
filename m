From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] ext4: fix wrong m_len value after unwritten extent
 conversion (Re: [PATCH 5/5] ext4: invalidate...)
Date: Tue, 26 Feb 2013 22:23:42 +0800
Message-ID: <20130226142342.GA7888@gmail.com>
References: <1361808463-25471-1-git-send-email-dmonakhov@openvz.org>
 <1361808463-25471-5-git-send-email-dmonakhov@openvz.org>
 <87d2vowe4l.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	wenqing.lz@taobao.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:36441 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab3BZOIq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Feb 2013 09:08:46 -0500
Received: by mail-pb0-f48.google.com with SMTP id wy12so2374815pbc.35
        for <linux-ext4@vger.kernel.org>; Tue, 26 Feb 2013 06:08:46 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <87d2vowe4l.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Dmitry and Ted,

On Mon, Feb 25, 2013 at 08:29:46PM +0400, Dmitry Monakhov wrote:
[snip]
> One BIG note about this patch.
> It fix BUG_ON(bh->b_blocknr != pblock) in fs/ext4/inode.c:1452
> but 300'th xfstest(from my repo) still failed due to data corruption in
> verifier thread. 
> LOG:
> MOUNT_OPTIONS -- -o acl,user_xattr /dev/mapper/vzvg-scratch_dev
> /mnt_scratch
> 
> 300 33s ... [failed, exit status 1] - output mismatch (see 300.out.bad)
>     --- 300.out      2013-02-20 12:46:24.000000000 +0400
>     +++ 300.out.bad  2013-02-25 20:18:24.000000000 +0400
>     @@ -2,3 +2,5 @@
>      
>       Start defragment activity 
>      
>     +failed: '/usr/local/bin/fio /tmp/1665-300.fio'
>     +(see 300.full for details)
>      ...
>      (Run 'diff -u 300.out 300.out.bad' to see the entire diff)
> 
> #300.full
> crc32c: verify failed at file /mnt_scratch/test2 offset 16973824, length
>     65536
>        Expected CRC: d062565e
>        Received CRC: f2cd2028
>        received data dumped as test2.16973824.received
>        expected data dumped as test2.16973824.expected
> defrag-4k: Laying out IO file(s) (1 file(s) / 3400MB)
> donor-file-fuzzer: Laying out IO file(s) (1 file(s) / 3400MB)
> 
> #DIFF:
> --- /tmp/test2.16973824.expected        2013-02-25 20:23:04.000000000
>     +0400
> +++ /tmp/test2.16973824.received        2013-02-25 20:22:55.000000000
>     +0400
> @@ -254,3844 +254,6 @@
>  0000fd0 eb95 6201 89ec 151a bd72 9675 203c 0d80
>  0000fe0 b7ae b415 b8cc 0b2f b6f5 baab 9d0e 1741
>  0000ff0 f6de fbda d64b 1bd3 5edb 040c 7cdc 18e6
> -0001000 0bdb 5114 cd95 01eb 017b a435 d128 11af
> -0001010 202f 93c9 a80a 013e a405 c261 8b1c 0dab
> -0001020 b480 c649 1032 1b0a 3690 7e89 dee1 0ac7
> -0001030 26d2 9489 3c97 0bd8 24da 5f28 3d4e 066d
> -0001040 049b b978 7815 159c 8093 b4e1 b246 1c25
> .....
> -000ffc0 bbb1 fa68 5622 022d 9776 0174 2d90 1ecb
> -000ffd0 92ee b473 64f7 0bcb 725d 2d17 9265 0fff
> -000ffe0 6e4b ec74 5bc0 0618 0dc9 e669 953d 002f
> -000fff0 a1b9 35e8 ff73 17a5 9437 15e0 24fa 150a
> +0001000 0000 0000 0000 0000 0000 0000 0000 0000
> +*
>  0010000
> 
> It seems that we data was written to uninitialized extent, but
> unwritten->initialized extent conversion was missed somewhere.
> I have not fix for that issue yet.

I take a close look at this bug, and I found that a wrong 'map->m_len'
is returned from ext4_ext_map_blocks when we try to convert an unwritten
extent with EXT4_GET_BLOCKS_IO_CONVERT_EXT flag.  Here we always assume
that the return value of ext/ind_map_blocks() is equal to m_len.  But
here it breaks this assumption.  Let us consider what happens.

When we do a dio write for a extent-based file, we will preallocate an
unwritten extent for it.  After dio write has been done, we will convert
it in ext4_end_io callback.  We use ext4_convert_unwritten_extents to do
this conversion.  Then the codepath is like beblow:

ext4_convert_unwritten_extents()
  ->ext4_map_blocks()
    ->ext4_es_lookup_extent()
      [We can lookup an unwritten extent]
    ->ext4_ext_map_blocks()
      ->ext4_ext_handle_uninitialized_extents()
    ->ext4_es_insert_extent()
      [We update status tree, but the length of written extent is wrong.
       The length of written extent is greater than the length of we
       have converted]

The following case demonstrates what happens.

1. We do a dio write.  An unwritten extent will be preallocated.

status tree: [0, 23]:unwritten
extent tree: [0, 23]:unwritten

2. We try to convert an unwritten extent, e.g. [0, 15].  But due to this
bug we will update all unwritten extent in status tree.

status tree: [0, 23]:written
extent tree: [0, 15]:written, [16, 23]:unwritten

3. Then we try to convert the following unwritten extent, but we will
return directly in ext4_map_blocks because we lookup an written extent
from status tree, and that unwritten extent will never be converted.  At
the time if e4defrag is running, the status tree could be removed, and
we could read an unwritten extent.

Certainly this is only my *guess* because in my sandbox xfstests #300 and
#301 never fail.  I am not sure this patch could fix this regression.
*But* I am pretty sure it will cause some potential bugs if it hasn't been
fixed.  I paste the patch at the below, which has been tested by xfstests
plus Dmitry's #300 and #301 test case at the following configurations.

 * Ext4 4k block
 * Ext4 4k block w/dioread_nolock
 * EXt4 4k block w/bigalloc


Dmitry, I really appreciate if you could give this patch a try.  Hope it
can fix this regression.  Please let me know if there is any update.
Thank you very much.

Regards,
						- Zheng


Subject: [PATCH] ext4: fix wrong m_len value after unwritten extent conversion

From: Zheng Liu <wenqing.lz@taobao.com>

We always assume that the return value of ext4_ext_map_blocks is equal
to map->m_len but when we try to convert an unwritten extent 'm_len'
value will break this assumption.  It is harmless until we use status
tree as a extent cache because we need to update status tree according
to 'm_len' value.

Meanwhile this commit marks EXT4_MAP_MAPPED flag after unwritten extent
conversion.  It shouldn't cause a bug because we update status tree
according to checking EXT4_MAP_UNWRITTEN flag.  But it should be fixed.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 372b2cb..0793a13 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3626,6 +3626,10 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 						 path, map->m_len);
 		} else
 			err = ret;
+		map->m_flags |= EXT4_MAP_MAPPED;
+		if (allocated > map->m_len)
+			allocated = map->m_len;
+		map->m_len = allocated;
 		goto out2;
 	}
 	/* buffered IO case */
-- 
1.7.12.rc2.18.g61b472e

