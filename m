From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 1/7] ext4: Introduce le32_t and le16_t
Date: Tue, 25 Sep 2007 04:01:01 -0600
Message-ID: <20070925100101.GC6143@schatzie.adilger.int>
References: <11907110323296-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <46F8D0DA.7090500@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, cmm@us.ibm.com
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:39777 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbXIYKAj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2007 06:00:39 -0400
Content-Disposition: inline
In-Reply-To: <46F8D0DA.7090500@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 25, 2007  14:41 +0530, Aneesh Kumar K.V wrote:
> The patches are on top of patch queue. I haven't touched
> the uid and gid of ext4_inode. Do you think i should
> change that too ?

You can add a Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
to those patches.  As I suspected there were a number of bugs hiding
in there.  I would also change the uid and gid fields, even if we
don't suspect any problems now.

> 7/7 is not the part of the series. But it is important.
> Should i send it as a separate patch for the 2.6.24 ?

Probably yes.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
