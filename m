From: Josh Hunt <johunt@akamai.com>
Subject: ext4_da_update_reserve_space warning fix not in stable
Date: Wed, 7 Jan 2015 12:12:59 -0600
Message-ID: <54AD772B.2050003@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
To: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>, <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from prod-mail-xrelay08.akamai.com ([96.6.114.112]:52902 "EHLO
	prod-mail-xrelay08.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754144AbbAGSUD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Jan 2015 13:20:03 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We are hitting the following warning in the field pretty frequently on 
the latest 3.10 stable kernel:
[11708.763067] WARNING: at fs/ext4/inode.c:363 
ext4_da_update_reserve_space+0x261/0x280 [ext4]()

The issue was resolved via "ext4: fix warning in 
ext4_da_update_reserve_space()" (7d7345322d60ed), but the fix was not 
submitted as a stable update for 3.10. I was wondering if there's a 
reason why this was not done, or if it was just overlooked?

The patch appears to have a dependency on "quota: provide interface for 
readding allocated space into reserved space" (1c8924eb106c1ac), so I 
think both would need to be submitted if you feel it's possible.

Thanks
Josh
