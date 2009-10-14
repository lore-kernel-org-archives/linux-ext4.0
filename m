From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 2/2] ext4: update donor file's ctime/mtime
Date: Wed, 14 Oct 2009 11:10:57 -0700
Message-ID: <A1BDA448-5948-4D2E-B456-5AF6F87149DF@sun.com>
References: <4ACD9D04.40503@sx.jp.nec.com>
 <EE52B431-D993-47A3-B914-5FE2ACE953B8@sun.com> <4AD52E2E.80404@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:44815 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbZJNSLl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Oct 2009 14:11:41 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n9EIAwh2017186
	for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2009 11:10:59 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KRI00400NOXT500@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Wed,
 14 Oct 2009 11:10:58 -0700 (PDT)
In-reply-to: <4AD52E2E.80404@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 13-Oct-09, at 18:49, Kazuya Mio wrote:
> 2009/10/10 2:20, Andreas Dilger wrote::
>>
>> On 8-Oct-09, at 02:04, Kazuya Mio wrote:
>>
>>> EXT4_IOC_MOVE_EXT changes donor file data, but doesn't update
>>> ctime/mtime.  This patch fixes this problem.
>>
>> I would argue that just migrating the file data shouldn't update the
>> ctime/mtime.  Those are used to determine if the file has changed  
>> in some way, usually for the purpose of backup.  Migrating the data  
>> does not change anything from user-space POV and shouldn't force a  
>> new backup of the file.
>
> EXT4_IOC_MOVE_EXT always changes the original actual contents of  
> donor file
> if orig file and donor file aren't the same. It may be that some of
> user-space implementations hide such a changing. For example, e4defrag
> unlinks the donor file, and removes it by decreasing reference count  
> after
> calling EXT4_IOC_MOVE_EXT. But from the ioctl point of view,
> EXT4_IOC_MOVE_EXT doesn't know whether donor file will be removed or  
> not,
> so I think we should update ctime/mtime.

Maybe I am confused.  Is EXT4_IOC_MOVE_EXT used for file  
defragmentation?
I thought the goal of this ioctl was to copy the data from the donor  
inode
to the target inode (using a new allocation in the target inode), and  
then
once the whole donor file had been copied (defragmented) the target  
extents
replace the entire donor file's extents?

In this model it would be OK to change the mtime/ctime of the _target_  
file,
but when these extents move back to the donor file the mtime/ctime of  
the donor
file should not be changed, I think, so that it does not force a full  
backup.

If the caller has done something to change the actual data in the  
donor file
it can always use utimes() to update the ctime/mtime, but it is not  
possible
for userspace to revert the ctime after it has changed.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

