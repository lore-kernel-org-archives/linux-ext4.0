From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH -V2 5/5] ext4: Fix the race between read_inode_bitmap
 and ext4_new_inode
Date: Fri, 21 Nov 2008 11:30:26 -0600
Message-ID: <4926F032.3070304@redhat.com>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:36298 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858AbYKURav (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Nov 2008 12:30:51 -0500
In-Reply-To: <1227285875-18011-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> We need to make sure we update the inode bitmap and clear
> EXT4_BG_INODE_UNINIT flag with sb_bgl_lock held. We look
> at EXT4_BG_INODE_UNINIT and reinit the inode bitmap each
> time in ext4_read_inode_bitmap (introduced by
> c806e68f5647109350ec546fee5b526962970fd2 )

Same here as 3/5, if you can mention the failure modes this fixes,
that'd be great.

-Eric
