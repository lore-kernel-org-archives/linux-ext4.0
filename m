From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] clear extents flag on inodes created in ext4_mknod
Date: Tue, 19 Feb 2008 10:54:26 -0600
Message-ID: <47BB09C2.8080709@redhat.com>
References: <47B9F1F1.30604@redhat.com> <47BB0658.90204@redhat.com> <20080219164944.GB7177@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965AbYBSQ6b (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Feb 2008 11:58:31 -0500
In-Reply-To: <20080219164944.GB7177@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Tue, Feb 19, 2008 at 10:39:52AM -0600, Eric Sandeen wrote:
>> Eric Sandeen wrote:
>>> e2fsck doesn't expect to find char, block, fifo, or socket
>>> files with the extent flag set, so clear that in ext4_mknod.
>>>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>> ---
>>>
>>> Index: linux-2.6.24/fs/ext4/namei.c
>>> ===================================================================
>>> --- linux-2.6.24.orig/fs/ext4/namei.c
>>> +++ linux-2.6.24/fs/ext4/namei.c
>>> @@ -1766,6 +1766,7 @@ retry:
>>>  #ifdef CONFIG_EXT4DEV_FS_XATTR
>>>  		inode->i_op = &ext4_special_inode_operations;
>>>  #endif
>>> +		EXT4_I(inode)->i_flags &= ~EXT4_EXTENTS_FL;
>>>  		err = ext4_add_nondir(handle, dentry, inode);
>>>  	}
>>>  	ext4_journal_stop(handle);
>> now that I think about it; perhaps it would be better to put this logic
>> into ext4_new_inode, rather than setting it by default and clearing it
>> here... that way new_inode() has all the logic about whether or not a
>> particular type of file is in extents format.
>>
> 
> How about enabling it only for directory and regular files rather than
> enabling it globally and then disabling the flag for  symlink and device
> files ?

I think that makes sense.

-Eric
