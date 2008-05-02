From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC PATCH] ext4: Group meta-data blocks together.
Date: Fri, 02 May 2008 10:49:01 -0700
Message-ID: <20080502174901.GC2950@webber.adilger.int>
References: <1209466647-26681-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:58373 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764755AbYEBRtM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 May 2008 13:49:12 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m42Hn8ee023221
	for <linux-ext4@vger.kernel.org>; Fri, 2 May 2008 10:49:09 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K0900J015BDT900@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 02 May 2008 10:49:08 -0700 (PDT)
In-reply-to: <1209466647-26681-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 29, 2008  16:27 +0530, Aneesh Kumar K.V wrote:
> I haven't yet tested this. Let me know what you think.
> 
> -aneesh
> 
> This adds a per inode meta-block prealloc space from which
> meta-data block requests are served. This help in making
> sure meta-data block are closer. This is needed to speedup
> unlink of the file. Any new prealloc space is allocated near
> the goal block specified. The goal block is the last block
> allocated for the file. So we don't keep the data-block and
> meta-data block far apart.

Does this code use the mballoc "group allocator" mechanism that it
already uses for small files?  It would be convenient to re-use
this code by creating a "metadata allocation group" instead of creating
another mechanism to aggregate small IO allocations.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

