From: Konstantin Chistyakov <Konstantin.Chistyakov@paragon-software.com>
Subject: [PATCH] libext2fs: don't flush to device opened in read-only mode
Date: Mon, 22 May 2017 09:48:00 +0000
Message-ID: <118AAB5F26BFB34DB5CDA7DA33334DB9B5FF41@vmsk-exch-01.paragon-software.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relaymsk-01.paragon-software.com ([91.226.210.14]:57085 "EHLO
        relaymsk-01.paragon-software.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757877AbdEVJsC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 22 May 2017 05:48:02 -0400
Received: from msk.paragon-software.com (vmsk-exch-01.paragon-software.com [172.30.30.80])
        by relaymsk-01.paragon-software.com (Postfix) with ESMTPS id 9933341EC3
        for <linux-ext4@vger.kernel.org>; Mon, 22 May 2017 12:47:59 +0300 (MSK)
Content-Language: ru-RU
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Konstantin Chistyakov <Konstantin.Chistyakov@Paragon-software.com>
Date: Tue, 19 May 2017 09:23:29 -0600
Subject: [PATCH] libext2fs: don't flush to device opened in read-only mode

From: Konstantin Chistyakov <Konstantin.Chistyakov@Paragon-software.com>

If the e2fsck is called with both -f -n options, the checking completing wi=
th a flushing error (retcode 8).

Catch error from the unix_flush() fsync(data->dev) when data->dev is opened=
 in read-only mode:

...
e2fsck -n -f /dev/sdd1
e2fsck 1.43.4 (31-Jan-2017)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Error flushing writes to storage device: Permission denied

---
lib/ext2fs/unix_io.c | 2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

(limited to 'lib/ext2fs/unix_io.c')

diff -up lib/ext2fs/unix_io.c{.orig,}
--- lib/ext2fs/unix_io.c.orig=9A=9A=9A=9A=9A=9A=9A 2017-05-19 14:32:12.5504=
14900 +0300
+++ lib/ext2fs/unix_io.c=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A 2017-05-19 =
14:33:48.520878000 +0300
@@ -1030,7 +1030,7 @@ static errcode_t unix_flush(io_channel channel)
#ifndef NO_IO_CACHE
=9A	retval =3D flush_cached_blocks(channel, data, 0);
#endif
-	if (!retval && fsync(data->dev) !=3D 0)
+	if (!retval && (data->flags & IO_FLAG_RW) && fsync(data->dev) !=3D 0)
=9A		return errno;
=9A	return retval;
}
