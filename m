From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Mon, 3 Mar 2008 00:50:07 +0100 (CET)
Message-ID: <alpine.DEB.1.00.0803030041460.5974@sheep.housecafe.de>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071217171100.GA7070@thunk.org> <20080211045107.GB25089@mit.edu> <20080219050945.GU25098@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns2.g-housing.de ([81.169.133.75]:37275 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756229AbYCCAeW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 2 Mar 2008 19:34:22 -0500
In-Reply-To: <20080219050945.GU25098@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

FYI,

today I really had to use e2fsck from your e2fsprogs.git "pu" tree.
After upgrading to 2.6.25-rc3, I noticed that one (raid0-)device has
not been mounted, syslog told me:

  EXT4-fs: md4: not marked OK to use with test code.

First I thought there is something wrong with the fs, so I ran it:

http://nerdbynature.de/bits/2.6.25-rc3/e2fsck_md4.log

...and when I could not mount the device afterwards, I stumpbled upon
http://fedoraproject.org/wiki/FedoraExt4, giving the exact commands which 
made my filesystem usable again :)

Thanks,
Christian.
-- 
BOFH excuse #415:

Maintenance window broken
