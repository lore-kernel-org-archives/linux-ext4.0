From: Andrey Sidorov <qrxd43@motorola.com>
Subject: mke2fs with bigalloc is too slow
Date: Wed, 13 Mar 2013 20:04:57 +0400
Message-ID: <CAA0+VHz9+LpS9jGbTEE_OE9kvgdXDqj3qMQQV5kTTJ12WDxMPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:38246 "EHLO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932656Ab3CMQE7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Mar 2013 12:04:59 -0400
Received: from DE01MGRG01.AM.MOT-MOBILITY.COM ([10.176.130.20])
	by DE01MGRG01.AM.MOT-MOBILITY.COM (8.14.3/8.14.3) with ESMTP id r2DG7qHR009757
	for <linux-ext4@vger.kernel.org>; Wed, 13 Mar 2013 12:07:52 -0400 (EDT)
Received: from mail-ie0-f179.google.com (mail-ie0-f179.google.com [209.85.223.179])
	by DE01MGRG01.AM.MOT-MOBILITY.COM (8.14.3/8.14.3) with ESMTP id r2DG7TTI009346
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 13 Mar 2013 12:07:52 -0400 (EDT)
Received: by mail-ie0-f179.google.com with SMTP id k11so1645801iea.38
        for <linux-ext4@vger.kernel.org>; Wed, 13 Mar 2013 09:04:57 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

It takes 29 seconds to format 1TB partition as ext4 with 256k cluster
size on MIPS. e2fsprogs version is 1.42.7.
The most time consumer is ext2fs_convert_subcluster_bitmap which folds
30M into 500K walking through block bitmap bit by bit. Afair, it takes
less time on x86 since there are asm bit ops for x86, but mips uses
generic ones.
Of course this folding can be optimized so that it tests series of
bits by byte, short or int and does less shifts and other address
arithmetic in between, but I don't expect that to improve time
dramatically.

First thing I did is allocated per-cluster bitmap instead of per-block
bitmap in ext2fs_initialize so that conversion doesn't occur. That
dropped mke2fs time from 29s to 2.5s. e2fsck -f found this fresh fs as
a good one and mounting/writing/reading/unmounting also went good. Of
course groups are allocated at different offsets and about 60M of
usable space are lost if compared to 'slow' formatting. That's fine,
we can live with that.
Are there any long-term consequences that I've missed? Are there any
reasons for using block bitmap instead of cluster bitmap except for
meta-data space efficiency?

As a long term solution I see following options:

1) Continue using block bitmap as base but allocate mirror cluster
bitmap and replay all base block bitmap allocations to it as soon as
they happen. This will increase memory usage by block/cluster ratio,
e.g. 1.6% in case of 4k blocks / 256k clusters.

2) Use cluster bitmap as base and use small sub-cluster bitmaps for
tracking blocks inside allocated clusters (some sort of search tree).
This will reduce allocated memory significantly in case of high
cluster/block ratio .

3) Variation of (2). Allocate cluster bitmap as base. Allocate block
bitmap via mmap as a mirror, but don't commit all the memory by
memset. This is simpler than (2) since there is no search structure
and at the same time memory is not over-allocated.

Please let me know your thoughts. Thanks!

Regards,
Andrey.
