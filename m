From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH -V2 5/5] ext4: Fix the race between read_inode_bitmap
	and ext4_new_inode
Date: Sun, 23 Nov 2008 14:26:11 -0500
Message-ID: <20081123192611.GF26473@mit.edu>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:34913 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752229AbYKWT2S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Nov 2008 14:28:18 -0500
Content-Disposition: inline
In-Reply-To: <1227285875-18011-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It's a lot easier to review patches if you explain why new functions
(such as ext4_claim_inode(), in this case) are required, and to add a
comment at the beginning of the new function explaining what it does,
what its return code it needs, whether it needs to be called with any
locks held, whether it exits with locks taken or released, etc.

Thanks,

      	    	       	     	  	      - Ted
