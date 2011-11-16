From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2undo: cast dptr to blk64_t to retrieve block number
Date: Wed, 16 Nov 2011 17:34:33 -0600
Message-ID: <4EC44889.7050307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962Ab1KPXee (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Nov 2011 18:34:34 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAGNYYEk031894
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 16 Nov 2011 18:34:34 -0500
Received: from Liberator-563.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id pAGNYXWQ003423
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 16 Nov 2011 18:34:34 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A 32-bit s390 build was failing on a 64-bit s390x host, when
make check failed e2undo tests, like this:

md5sum before mke2fs 922c8a591c882dbdd1a381d18547cfd5
using mke2fs to test e2undo
Overwriting existing filesystem; this can be undone using the command:
    e2undo /tmp/mke2fs-tmp.EM9XjmTA81.e2undo /tmp/tmp.EM9XjmTA81

md5sum after mke2fs cbf32fb6c3db45280ad013f42ac294f1
Replayed transaction of size 32768 at location 0
Replayed transaction of size 32768 at location 0
Replayed transaction of size 32768 at location 0
Replayed transaction of size 32768 at location 0
Replayed transaction of size 0 at location 0
md5sum after e2undo 31b4e14307c5b7ccce5b8d300c2ad5f1

Note the "at location 0" for the block number.

A proper cast in e2undo.c fixes this up.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

We should have a bingo game for the rest of the unsigned longs that
are surely lurking around ;)

diff --git a/misc/e2undo.c b/misc/e2undo.c
index f97ddc2..b1cb750 100644
--- a/misc/e2undo.c
+++ b/misc/e2undo.c
@@ -206,7 +206,7 @@ int main(int argc, char *argv[])
 				_("Failed tdb_fetch %s\n"), tdb_errorstr(tdb));
 			exit(1);
 		}
-		blk_num = *(unsigned long *)key.dptr;
+		blk_num = *(blk64_t *)key.dptr;
 		printf(_("Replayed transaction of size %zd at location %llu\n"),
 							data.dsize, blk_num);
 		retval = io_channel_write_blk64(channel, blk_num,


