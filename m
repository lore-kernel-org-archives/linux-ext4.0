From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: inode version updates
Date: Thu, 14 Jun 2007 10:11:32 -0700
Message-ID: <467176C4.5000404@us.ibm.com>
References: <20070614095359.GJ5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:60601 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbXFNRWK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jun 2007 13:22:10 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5EHM6KJ028066
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jun 2007 13:22:06 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5EHGGJC229124
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jun 2007 11:22:06 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5EHBiBh006801
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jun 2007 11:11:46 -0600
In-Reply-To: <20070614095359.GJ5181@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> Mingming Cao <cmm@us.ibm.com> writes:
> 
>>I took out the i_version code from Kalpak's
>>ext4_expand_inode_extra_isize.patch. 
>>
>>http://repo.or.cz/w/ext4-patch-queue.git?a=blob;f=ext4_i_version_hi_2.patch;h=4519dd6540a78cadd235dad68248456d59c3384c;hb=8b956b5c5ccc3731f23fbce8d036b21f378fbdec
>>
>>Added Jean noel's inode version VFS patch and Ext4 patches. Now the full
>>inode version patch series can be found at ext4 patch queue:
>>
>># inode verion patch series
>># inode versioning is needed for NFSv4
>>
>># vfs changes, 64 bit inode->i_version
>>i_version_update_vfs.patch
> 
> 
> Looking through this, I don't understand why there are i_version updates
> in the VFS?  The comments here imply that this is only for filesystems
> which will never be mounted (e.g. pipefs).  Having i_version updates there
> is confusing and I don't think it helps anyone.
> 
> 
>># ext4 inode version update
>>i_version_update_ext4.patch
>>--- linux-2.6.22-rc4.orig/fs/ext4/super.c       2007-06-13 17:19:11.000000000 -0700
>>+++ linux-2.6.22-rc4/fs/ext4/super.c    2007-06-13 17:24:45.000000000 -0700
>>@@ -2846,8 +2846,8 @@ out:
>>               i_size_write(inode, off+len-towrite);
>>               EXT4_I(inode)->i_disksize = inode->i_size;
>>       }
>>-       inode->i_version++;
>>       inode->i_mtime = inode->i_ctime = CURRENT_TIME;
>>+       inode->i_version = 1;
>>       ext4_mark_inode_dirty(handle, inode);
>>       mutex_unlock(&inode->i_mutex);
>>       return len - towrite;
> 
> 
> The change from "i_version++" to "i_version = 1" in ext4_update_quota()
> is confusing.  Why was this change made?  If there is a good reason why
> the inode version stays at 1 for the quota file, maybe it deserves
> a comment explaining it.
> 

I agree with both of your comments.

Mingming
