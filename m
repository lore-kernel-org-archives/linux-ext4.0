From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext3/4: fix uninitialized bs in	ext3/4_xattr_set_handle()
Date: Tue, 13 May 2008 14:00:23 -0600
Message-ID: <20080513200023.GA31179@webber.adilger.int>
References: <4827B878.50903@oracle.com>
 <20080512170254.f79fe869.akpm@linux-foundation.org> <4828FD68.40608@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>,
	stable@kernel.org
To: Tiger Yang <tiger.yang@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:49202 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189AbYEMUAq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 May 2008 16:00:46 -0400
In-reply-to: <4828FD68.40608@oracle.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 13, 2008  10:31 +0800, Tiger Yang wrote:
> This situation only happens we format ext3/4 with inode size more than 128 
> and we have put xattr entries both in ibody and block.
> The consequences about this bug is we will lost the xattr block which 
> pointed by i_file_acl with all xattr entires in it. We will alloc a new 
> xattr block and put that large value entry in it. The old xattr block will 
> become orphan block.

Tiger, thanks for finding this bug, and the patch (which fixes the
problem in our testing).

Signed-off-by: Andreas Dilger <adilger@sun.com>

> Andrew Morton wrote:
>> On Mon, 12 May 2008 11:24:40 +0800
>> Tiger Yang <tiger.yang@oracle.com> wrote:
>>
>>   
>>> I met a bug when I try to replace a xattr entry in ibody with a big size 
>>> value. But in ibody there has no space for the new value. So it should 
>>> set new xattr entry in block and remove the old xattr entry in ibody.
>>>
>>> Best regards,
>>> tiger
>>>
>>>
>>> [xattr.patch  text/x-patch (1.3KB)]
>>> This fix the uninitialized bs when we try to replace a xattr entry in ibody with the new value which require more than free space.
>>>
>>> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
>>>
>>> diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
>>> index a6ea4d6..e1af9bd 100644
>>> --- a/fs/ext3/xattr.c
>>> +++ b/fs/ext3/xattr.c
>>> @@ -1000,6 +1000,11 @@ ext3_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
>>>  			i.value = NULL;
>>>  			error = ext3_xattr_block_set(handle, inode, &i, &bs);
>>>  		} else if (error == -ENOSPC) {
>>> +			if (EXT3_I(inode)->i_file_acl && !bs.s.base) {
>>> +				error = ext3_xattr_block_find(inode, &i, &bs);
>>> +				if (error)
>>> +					goto cleanup;
>>> +			}
>>>  			error = ext3_xattr_block_set(handle, inode, &i, &bs);
>>>  			if (error)
>>>  				goto cleanup;
>>>     
>>
>> That sounds fairly bad.
>>
>> What are the consequences of this bug, when someone hits it?

The EAs in the external block (except the one being added) are lost, and
some blocks (or shared EA block references) are leaked.  In most cases
this is not fatal, but for Lustre I developed a test case where this
causes the file data to be lost (because the file layout is stored in
the external block if it is too large to store in the inode).

>> It appears that we should backport this fix into 2.6.25.x (and perhaps
>> earlier).  What do you think?

Code inspection shows this bug goes back to when the fast EA-in-inode
support was added to the vanilla kernel, at least 2.6.12 (when Git
history begins).

Sadly, the bug was NOT in the original CFS EA-in-inode patches that we
made for kernels 2.6.5 (SLES 9) and 2.6.9 (RHEL 4) (and still use today)
that were in 2.6.11-rc1-mm1, but were added during the later rewrite of
this code.

I suspect the reasons this bug hasn't been reported even when large inodes
are enabled (which is the default for newer e2fsprogs) are:
- it uncommon to have multiple EAs on a file (usually SELinux is the
  only common one and it is relatively small)
- one of the EAs must already be too large to fit in the inode 
- increasing the size of any EA after it is created is rare

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

