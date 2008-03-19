From: Solofo.Ramangalahy@bull.net
Subject: Re: [2.6.25-rc5-ext4-36c86] attempt to access beyond end of device
Date: Wed, 19 Mar 2008 12:56:45 +0100
Message-ID: <18400.65405.751244.152577@frecb006361.adech.frec.bull.fr>
References: <18399.36935.640758.796880@frecb006361.adech.frec.bull.fr>
	<20080319113500.GI2971@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:44237 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765613AbYCSUQg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Mar 2008 16:16:36 -0400
In-Reply-To: <20080319113500.GI2971@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,

Andreas Dilger writes:
 > You should print out the page->mapping->host->i_ino in this message
 > and then you can possibly examine the filesystem to see if it is
 > a corrupt block allocation, or possibly random garbage in the block.

Will do thanks.

 > Hmm, is this filesystem formatted with 64BIT?

I'm using: 
mke2fs 1.40.8 (13-Mar-2008)
        Using EXT2FS Library version 1.40.8
(the one from debian unstable)
and format like this:
/sbin/mkfs.ext3 -E test_fs /dev/sdb

Just want to note (because of current vger problems) that Dmitri
confirmed the symptom (with fsstress+fallocate patch) and offered an
analysis.

-- 
solofo
