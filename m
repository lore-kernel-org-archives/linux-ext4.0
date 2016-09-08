From: =?UTF-8?B?VMO2csO2ayBFZHdpbg==?= <edwin@etorok.net>
Subject: Fwd: [STABLE CHERRYPICK] ext4: avoid modifying checksum fields
 directly during checksum verification
Date: Thu, 8 Sep 2016 10:21:34 +0300
Message-ID: <40811621-e317-fecc-8052-56b88fd5ce35@etorok.net>
References: <20160906022955.qopdwuznvtqlwofq@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: gregkh@linuxfoundation.org, stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.etorok.net ([62.210.252.135]:45104 "EHLO mail.etorok.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751420AbcIHHVj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 8 Sep 2016 03:21:39 -0400
In-Reply-To: <20160906022955.qopdwuznvtqlwofq@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Not sure if this was sent to the right place: stable@kernel.org doesn't seem to exist, I can't find this message in the ML archives, or the 4.7.3 changelog.
Could you please include this in 4.7.4, I've been waiting for this patch to get included ever since 4.7.1...


-------- Forwarded Message --------
Subject: [STABLE CHERRYPICK] ext4: avoid modifying checksum fields directly during checksum verification
Date: Mon, 5 Sep 2016 22:29:55 -0400
From: Theodore Ts'o <tytso@mit.edu>
To: stable@kernel.org
CC: linux-ext4@vger.kernel.org, Török Edwin <edwin@etorok.net>

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
						

