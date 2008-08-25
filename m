From: Andreas Dilger <adilger@sun.com>
Subject: FIEMAP patches
Date: Mon, 25 Aug 2008 14:22:50 -0600
Message-ID: <20080825202250.GY3392@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Mark Fasheh <mfasheh@suse.com>, Eric Sandeen <esandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:62814 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbYHYUXK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Aug 2008 16:23:10 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m7PKN5JW022854
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 13:23:05 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K6600K01B57P300@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 25 Aug 2008 13:23:05 -0700 (PDT)
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I read through the entire previous FIEMAP thread (phew!) and it boils
down mostly to:

s/FIEMAP_FLAG_NO_DIRECT/FIEMAP_FLAG_NO_BYPASS/

> * FIEMAP_EXTENT_UNWRITTEN                                                    
> Unwritten extent - the extent is allocated but it's data has not been        
> initialized.  This indicates the extent's data will be all zero.             
                                                                               
This should say "will be all zero if read through the filesystem              
but the contents are undefined if read directly from the device."

There was also an update to the ext4 patch from Kalpak for handling
EA-in-inode at the same time as an external inode.

Eric, Mark,
could one of you please just submit the patches to Andrew for inclusion.
I think there was plenty of debate already, with very little significant
benefit except suggesting different names for some of the flags.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

