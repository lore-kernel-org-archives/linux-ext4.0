From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: use vmtruncate() instead of ext4_truncate() in ext4_setattr()
Date: Tue, 17 May 2011 23:35:41 -0600
Message-ID: <1C66CCCC-A62E-4277-B3CB-0C82DD6940BA@dilger.ca>
References: <20110517225926.8B4A94225B@ruihe.smo.corp.google.com> <4DD33AA9.9060104@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Jiaying Zhang <jiayingz@google.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:45896 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab1ERFfm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 May 2011 01:35:42 -0400
In-Reply-To: <4DD33AA9.9060104@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 17, 2011, at 21:19, Eric Sandeen wrote:
> On 5/17/11 5:59 PM, Jiaying Zhang wrote:
>> There is a bug in commit c8d46e41 "ext4: Add flag to files with blocks
>> intentionally past EOF" that if we fallocate a file with FALLOC_FL_KEEP_SIZE
>> flag and then ftruncate the file to a size larger than the file's i_size,
>> any allocated but unwritten blocks will be freed but the file size is set
>> to the size that ftruncate specifies.
>> 
>> Here is a simple test to reproduce the problem:
>> 1. fallocate a 12k size file with KEEP_SIZE flag
>> 2. write the first 4k
>> 3. ftruncate the file to 8k
>> Then 'ls -l' shows that the i_size of the file becomes 8k but debugfs
>> shows the file has only the first written block left.
> 
> To be honest I'm not 100% certain what the fiesystem -should- do in this case.

I think it makes sense from a usage POV to discard the blocks after EOF when a truncate is being done.  For something like a PVR that is recording a show, but doesn't know the exact total size, it makes sense to fallocate() some estimated amount of space, and then when the show is finished recording it uses ftruncate() of the current size to drop the fallocated space.

> If I go through that same sequence on xfs, I get 4k written / 8k unwritten:
> 
> # xfs_bmap -vp testfile
> testfile:
> EXT: FILE-OFFSET      BLOCK-RANGE            AG AG-OFFSET              TOTAL FLAGS
> 0: [0..7]:          2648750760..2648750767  3 (356066400..356066407)     8 00000
> 1: [8..23]:         2648750768..2648750783  3 (356066408..356066423)    16 10000
> 
> size 8k:
> # ls -l testfile
> -rw-r--r-- 1 root root 8192 May 17 22:33 testfile
> 
> and diskspace used 12k:
> # du -hc testfile
> 12K	testfile
> 12K	total
> 
> I think this is a different result from ext4, either with or without your patch.
> 
> On ext4 I get size 8k, but only the first 4k mapped, as you say.
> 
> I don't recall when truncate is supposed to free fallocated blocks, and from what point?
> 
> -Eric
> 
>> Below is the proposed patch to fix the bug:
>> 
>> ext4: use vmtruncate() instead of ext4_truncate() in ext4_setattr().
>> 
>> Change ext4_setattr() to use vmtruncate(inode, attr->ia_size) instead
>> of ext4_truncate(inode) when it needs to truncate an inode so that
>> if the inode has EXT4_EOFBLOCKS_FL flag set and we are trying to truncate
>> to a size larger than the inode's i_size, we will only truncate the blocks
>> beyond the specified truncate size instead of all of blocks beyond i_size.
>> 
>> Signed-off-by: Jiaying Zhang <jiayingz@google.com>
>> 
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 3424e82..3bfad57 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -5347,8 +5347,11 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>> 			}
>> 		}
>> 		/* ext4_truncate will clear the flag */
>> -		if ((ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS)))
>> -			ext4_truncate(inode);
>> +		if ((ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS))) {
>> +			rc = vmtruncate(inode, attr->ia_size);
>> +			if (rc)
>> +				goto err_out;
>> +		}
>> 	}
>> 
>> 	if ((attr->ia_valid & ATTR_SIZE) &&
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





