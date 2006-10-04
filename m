From: Eric Sandeen <esandeen@redhat.com>
Subject: different defaults in mke2fs.conf vs. the code itself?
Date: Wed, 04 Oct 2006 12:37:02 -0500
Message-ID: <4523F13E.5090309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:4240 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S964915AbWJDRhH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Oct 2006 13:37:07 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id k94Hb6pt012572
	for <linux-ext4@vger.kernel.org>; Wed, 4 Oct 2006 13:37:06 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id k94Hb579031309
	for <linux-ext4@vger.kernel.org>; Wed, 4 Oct 2006 13:37:05 -0400
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id k94Hb3T1031351
	for <linux-ext4@vger.kernel.org>; Wed, 4 Oct 2006 13:37:05 -0400
To: ext4 development <linux-ext4@vger.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

from mke2fs.conf in 1.39:

[defaults]
        base_features = sparse_super,filetype,resize_inode,dir_index
        blocksize = 4096

and yet (for example) in PRS():

        if (blocksize <= 0) {
                profile_get_integer(profile, "defaults", "blocksize", 0,
                                    1024, &use_bsize);
                profile_get_integer(profile, "fs_types", fs_type,
                                    "blocksize", use_bsize, &use_bsiz

So the code itself defaults to 1k blocks, but the shipped config file
defaults to 4k blocks?  We noticed this when mke2fs.conf went missing
from the install environment, and formatting large filesystems took a
-very- long time.

Shouldn't these match?  Or for that matter, why should the shipped
config file be either overriding or re-stating defaults in the code
itself?  Seems a bit strange to me.

-Eric
