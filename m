From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] Add flag to files with blocks intentionally past EOF
Date: Thu, 21 Jan 2010 17:32:22 -0700
Message-ID: <22655F73-6EB0-40AC-9D51-794F6764CF67@sun.com>
References: <4B5627EF.3080804@redhat.com> <87tyuhdu6q.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:38292 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab0AVAcY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jan 2010 19:32:24 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o0M0WNoo022480
	for <linux-ext4@vger.kernel.org>; Thu, 21 Jan 2010 16:32:24 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KWM00L00HA5KG00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Thu,
 21 Jan 2010 16:32:23 -0800 (PST)
In-reply-to: <87tyuhdu6q.fsf@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-01-20, at 02:03, Aneesh Kumar K. V wrote:
>> @@ -4741,8 +4743,8 @@ void ext4_get_inode_flags(struct  
>> ext4_inode_info *ei)
>> {
>> 	unsigned int flags = ei->vfs_inode.i_flags;
>>
>> -	ei->i_flags &= ~(EXT4_SYNC_FL|EXT4_APPEND_FL|
>> -			EXT4_IMMUTABLE_FL|EXT4_NOATIME_FL|EXT4_DIRSYNC_FL);
>> +	ei->i_flags &= ~(EXT4_SYNC_FL|EXT4_APPEND_FL|EXT4_IMMUTABLE_FL|
>> +
>> EXT4_NOATIME_FL|EXT4_DIRSYNC_FL|EXT4_EOFBLOCKS_FL);
>
>
> Do we really need to allow the get and set of this flag. IMHO a  
> truncate
> should be the only API and the flag should be remove implicitly for  
> that.

Since this flag is set on disk in the inode flags, it makes sense to  
allow clearing it via "chattr", just like "chattr +e" will remap a  
file to extent format.  The risk with setting it via truncate() is  
that this is racy with some other process writing to the file.  If we  
allow setting it via "chattr" this can be done in a non-racy manner,  
by locking the inode and dropping only the blocks beyond EOF.

>> @@ -92,6 +92,16 @@ long ext4_ioctl(struct file *filp, unsigned int  
>> cmd, unsigned long arg)
>> 			flags &= ~EXT4_EXTENTS_FL;
>> 		}
>>
>> +		if (flags & EXT4_EOFBLOCKS_FL) {
>> +			/* we don't support adding EOFBLOCKS flag */
>> +			if (!(oldflags & EXT4_EOFBLOCKS_FL)) {
>> +				err = -EOPNOTSUPP;
>> +				goto flags_out;
>> +			}
>> +		} else if (oldflags & EXT4_EOFBLOCKS_FL)
>> +			/* free the space reserved with fallocate KEEPSIZE */
>> +			vmtruncate(inode, inode->i_size);
>> +
>> 		handle = ext4_journal_start(inode, 1);
>> 		if (IS_ERR(handle)) {
>> 			err = PTR_ERR(handle);
>
> If we remove ext4_ioctl support i guess that patch can become much
> simpler.


Sure it will be simpler, but less useful.  The point of exposing this  
flag via lsattr is to allow userspace to determine which files are  
holding blocks beyond EOF, so that if the filesystem is getting too  
full it is possible to run e.g. "lsattr -R" and find files with this  
EOF attribute and truncate them.  Without keeping at least the  
EOFBLOCKS flag in USER_VISIBLE this is impossible.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

