Return-Path: <SRS0=njA7=PY=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:14146 "EHLO smtp6-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729732AbfAPVeZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 16 Jan 2019 16:34:25 -0500
Received: from localhost.localdomain (unknown [88.185.151.243])
        by smtp6-g21.free.fr (Postfix) with ESMTPS id 2A37B7802FE
        for <linux-ext4@vger.kernel.org>; Wed, 16 Jan 2019 22:34:24 +0100 (CET)
Date: Wed, 16 Jan 2019 22:34:23 +0100
From: Etienne Buira <etienne.buira@free.fr>
To: linux-ext4@vger.kernel.org
Subject: ext4fs block role, debugfs testb and icheck mismatch
Message-ID: <20190116213423.GA20263@Z926fQmE5jqhFMgp6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

For the background: i've hit defect sectors (on part of md array), and i
want to rewrite those sectors to force hdd reallocation, so i need to
figure out what they are used for.

Unrolling the layers under fs, i'm interested in a 4K blocks range that
starts at 2035, here starts the trouble:
debugfs 1.43.9 (8-Feb-2018)
debugfs:  testb 2035
Block 2035 marked in use
debugfs:  icheck 2035
Block   Inode number
2035    <block not found>

>From this result, i tried to figure out if this block were used for fs
internal structures.
Using dumpe2fs, i see that this block belongs to group 0, and falls
beyond fs structures (last block for inode table is reported as 1568).
Block 2035 is not reported as free blocks.

Running forced (fs was marked clean) RO check with e2fsck (on mounted
filesystem) did not report block 2035 in block bitmap differences.

Oh, and yes, unmounting the filesystem would be a costy operation, so
better if avoided (that's why i ran e2fsck RO, and only looked for
results about the block of interest).

So, how can i know how this (these, actually) block is used?

Regards.

PS: I'm not subscribed to the list, so please CC me.
