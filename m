From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 0/6] inode version updated patches
Date: Thu, 14 Jun 2007 13:48:59 -0700
Message-ID: <1181854139.3883.7.camel@dyn9047017103.beaverton.ibm.com>
References: <1181836571.7779.42.camel@garfield>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>,
	Jean noel Cordenner <jean-noel.cordenner@bull.net>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:51248 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbXFNUtJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jun 2007 16:49:09 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l5EKiRad001383
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jun 2007 16:44:27 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5EKn1NA244900
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jun 2007 14:49:01 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5EKn1d6027872
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jun 2007 14:49:01 -0600
In-Reply-To: <1181836571.7779.42.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-06-14 at 21:26 +0530, Kalpak Shah wrote:
> Hi,
> 
> I have updated the inode version patches and below are the details:
> 
> 64-bit-i_version.patch which only replaces the 32-bit i_version field in
> the generic inode with a 64-bit i_version field. The VFS-level updates
> of the inode version are still in the i_version_update_vfs.patch and
> this patch has been moved to the bottom of the patch series.
> 
> ext4_i_version_hi_2.patch was still using ei->i_fs_version instead of
> inode->i_version. I have corrected this patch.
> 
> Also there were whitespace problems in i_version_hi.patch.
> 
> I am also attaching a ext4_no_version.patch which adds a "noversion"
> mount option to disable inode version updates.
> 
> I am not sure why i_version needs to be updated in VFS since it is being
> updated in ext4_mark_iloc_dirty().
> 

Yes I think we can remove the inode version update in VFS patch. So I am
going to drop the patch 5/6.  Jean Noel, if you disagree, please let me
know.

> Well, these are lots of small patches and I am sending them separately
> so that they can be applied and commented upon easily.
> 

Thanks, I will update the patch queue with your patch series.

Mingming
> Thanks,
> Kalpak.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
