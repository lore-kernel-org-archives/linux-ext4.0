From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Still about ext2/ext3 mount options while using ext4.ko driver
Date: Mon, 9 Dec 2013 19:25:31 -0200
Message-ID: <20131209212531.GB4296@orion.maiolino.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab3LIVZg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Dec 2013 16:25:36 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rB9LPaHF027342
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 9 Dec 2013 16:25:36 -0500
Received: from orion.maiolino.org (ovpn-113-22.phx2.redhat.com [10.3.113.22])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id rB9LPWum012861
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 9 Dec 2013 16:25:35 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi guys,

Ted released some months ago a patch to deny some options to be used by ext4.ko
driver while mounting an ext2/3 filesystem.

But, there are still some mount options that IMHO needs a review of what should
and shouldn't be allowed while using ext4 to mount ex2/3 filesystems.

These are the options:

inode_readahead_blks=32 # ext2/3 might get some benefits from it

stripe=4 	 # Feasible to all extX IMHO

max_batch_time=5 #I'm not sure ir this has any gain for ext2 and if it might
		  work well with ext3, any comments?

min_batch_time=5 #same as above

journal_ioprio=5 #doesn't make sense for ext2, but might be useful for ext3 FS?!

auto_da_alloc    #ext4 only

noauto_da_alloc  #same as above

discard		 #ex2 shouldn't be allowed to use it ?!

nodiscard	 #same as above

block_validity   #ext4 and debugging purposes only, should be off for ext2/3 too

noblock_validity #same as above

i_version  # I believe this is only valid for Ext4 

journal=11 #doesn't make sense for ext2

barrier=1 #doesn't make sense for ext2

barrier #doesn't make sense for ext2

nobarrier #doesn't make sense for ext2

commit=5  #doesn't make sense for ext2

abort  #call ext4_abort(), devel usage only, and it fails to put ext2 FS on RO,
       if this should be kept enabled, I can look why ext2 keep RW after its use


Let me know what you guys think.

Cheers

-- 
Carlos
