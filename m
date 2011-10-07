From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [Ext4 Secure Delete 7/7v4] ext4/jbd2: Secure Delete: Secure delete
 journal blocks
Date: Fri, 07 Oct 2011 14:54:39 -0500
Message-ID: <4E8F58FF.7020401@redhat.com>
References: <1317971465-8517-1-git-send-email-achender@linux.vnet.ibm.com> <1317971465-8517-8-git-send-email-achender@linux.vnet.ibm.com> <20111007183531.GI12447@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081Ab1JGTyr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Oct 2011 15:54:47 -0400
In-Reply-To: <20111007183531.GI12447@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/7/11 1:35 PM, Darrick J. Wong wrote:
> On Fri, Oct 07, 2011 at 12:11:05AM -0700, Allison Henderson wrote:
>> This patch modifies both ext4 and jbd2 such that the journal
>> blocks which may contain file data, are securely deleted
>> after the files data blocks are deleted.
>>
>> Because old journal blocks may contain file data, we need
>> a way to find those blocks again when it comes time to secure
>> delete the file.  This patch adds a new list to the journal
>> structure to keep track of which vfs blocks the journal blocks
>> contain.
>>
>> After a truncate or a punch hole operation has completed, a
>> new function ext4_secure_delete_jblks is called that flushes
>> the journal, and then searches the list for any journal blocks
>> that were used to journal the blocks that were just removed.
>> The found journal blocks are then secure deleted.

And what about directory data?  Those would appear to remain in the
journal at least...  And xattrs?

#!/bin/bash

rm -f testsecdel
truncate --size 256m  testsecdel
mkfs.ext4 -F testsecdel &>/dev/null
mount -o loop testsecdel mnt/
echo securedata > mnt/securefilename
setfattr -n user.securexattrname -v securexattrvalue mnt/securefilename 
LONGATTR=`for I in 1 2 3 4 5 6 7 8 9 0; do echo -n veryveryveryveryveryveryverylongsecurexattrvalue; done`
setfattr -n user.longsecurexattrname -v $LONGATTR mnt/securefilename 
sync

rm -f mnt/securefilename
umount mnt
strings testsecdel 

yields:

/mnt/test2/mnt
lost+found
securexattrname
Ylongsecurexattrname
mselinux
veryveryveryveryveryveryverylongsecurexattrvalueveryveryveryveryveryveryverylongsecurexattrvalueveryveryveryveryveryveryverylongsecurexattrvalueveryveryveryveryveryveryverylongsecurexattrvalueveryveryveryveryveryveryverylongsecurexattrvalueveryveryveryveryveryveryverylongsecurexattrvalueveryveryveryveryveryveryverylongsecurexattrvalueveryveryveryveryveryveryverylongsecurexattrvalueveryveryveryveryveryveryverylongsecurexattrvalueveryveryveryveryveryveryverylongsecurexattrvaluesecurexattrvalueunconfined_u:object_r:file_t:s0
lost+found
securefilename
/mnt/test2/mnt

(this was with ext4.ko hacked to always enable secure delete)

-Eric
