From: Theodore Ts'o <tytso@mit.edu>
Subject: [STABLE CHERRYPICK] ext4: avoid modifying checksum fields directly
 during checksum verification
Date: Mon, 5 Sep 2016 22:29:55 -0400
Message-ID: <20160906022955.qopdwuznvtqlwofq@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        =?iso-8859-1?B?VPZy9ms=?= Edwin <edwin@etorok.net>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46528 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755342AbcIFCbF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 5 Sep 2016 22:31:05 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, please cherry pick the following commit into the stable kernels.
The commit landed in 4.8-rc1.  It wasn't marked with a cc:
stable@kernel.org, but it should be backported since it affecting a
number of users who are trying to use ext4's metadata checksum
feature.

Thanks!!

commit b47820edd1634dc1208f9212b7ecfb4230610a23
Author: Daeho Jeong <daeho.jeong@samsung.com>
Date:   Sun Jul 3 17:51:39 2016 -0400

    ext4: avoid modifying checksum fields directly during checksum verification
    
    We temporally change checksum fields in buffers of some types of
    metadata into '0' for verifying the checksum values. By doing this
    without locking the buffer, some metadata's checksums, which are
    being committed or written back to the storage, could be damaged.
    In our test, several metadata blocks were found with damaged metadata
    checksum value during recovery process. When we only verify the
    checksum value, we have to avoid modifying checksum fields directly.
    
    Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
    Signed-off-by: Youngjin Gil <youngjin.gil@samsung.com>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>
    Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

						- Ted
						
