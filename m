From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] resize2fs vs. large inodes, take 2
Date: Mon, 03 Mar 2008 16:18:51 -0600
Message-ID: <47CC794B.7030400@redhat.com>
References: <47CC622F.8030900@redhat.com> <20080303220552.GS3616@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759834AbYCCWSy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Mar 2008 17:18:54 -0500
In-Reply-To: <20080303220552.GS3616@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:

>> ===================================================================
>> --- e2fsprogs-1.40.7.orig/resize/resize2fs.c
>> +++ e2fsprogs-1.40.7/resize/resize2fs.c
>> @@ -1168,11 +1168,12 @@ static errcode_t inode_scan_and_fix(ext2
>>  	 * elsewhere in the inode table
>>  	 */
>>  	while (1) {
>> -		retval = ext2fs_get_next_inode(scan, &ino, &inode);
>> +		retval = ext2fs_get_next_inode_full(scan, &ino, buf, inode_size);
>>  		if (retval) goto errout;
>>  		if (!ino)
>>  			break;
>>  
>> +		memcpy(&inode, buf, sizeof(struct ext2_inode));
> 
> Should this be using "sizeof(struct ext2_inode)" or should it be using
> "sb->s_inode_size" instead (extracted from the right struct of course)?

well, let's see... I think we read "inode_size" in get_next_inode_full,
which is s_inode_size, into buf, which was allocated to size
inode_size/s_inode_size.

But "inode" is just a plain ol' little inode.  I think really this
"inode" is just for convenience for accessing the normal inode fields....

But I now that I try livecd-creator with this patch, even on 128-byte
inodes, the fscks it runs is finding trouble post-resize (this despite
all the regression test passing...)  *sigh* I think I'd better sit on
this problem for a while longer before I send the next patch :)

Ted, pls ignore this for now...

-Eric
