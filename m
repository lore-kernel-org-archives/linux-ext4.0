From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [Ext4 Secure Delete 7/7v4] ext4/jbd2: Secure Delete: Secure delete
 journal blocks
Date: Fri, 07 Oct 2011 13:14:26 -0700
Message-ID: <4E8F5DA2.7060608@linux.vnet.ibm.com>
References: <1317971465-8517-1-git-send-email-achender@linux.vnet.ibm.com> <1317971465-8517-8-git-send-email-achender@linux.vnet.ibm.com> <20111007183531.GI12447@tux1.beaverton.ibm.com> <4E8F58FF.7020401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: djwong@us.ibm.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4E8F58FF.7020401@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/07/2011 12:54 PM, Eric Sandeen wrote:
> On 10/7/11 1:35 PM, Darrick J. Wong wrote:
>> On Fri, Oct 07, 2011 at 12:11:05AM -0700, Allison Henderson wrote:
>>> This patch modifies both ext4 and jbd2 such that the journal
>>> blocks which may contain file data, are securely deleted
>>> after the files data blocks are deleted.
>>>
>>> Because old journal blocks may contain file data, we need
>>> a way to find those blocks again when it comes time to secure
>>> delete the file.  This patch adds a new list to the journal
>>> structure to keep track of which vfs blocks the journal blocks
>>> contain.
>>>
>>> After a truncate or a punch hole operation has completed, a
>>> new function ext4_secure_delete_jblks is called that flushes
>>> the journal, and then searches the list for any journal blocks
>>> that were used to journal the blocks that were just removed.
>>> The found journal blocks are then secure deleted.
>
> And what about directory data?  Those would appear to remain in the
> journal at least...  And xattrs?
>
> #!/bin/bash
>
> rm -f testsecdel
> truncate --size 256m  testsecdel
> mkfs.ext4 -F testsecdel&>/dev/null
> mount -o loop testsecdel mnt/
> echo securedata>  mnt/securefilename
> setfattr -n user.securexattrname -v securexattrvalue mnt/securefilename
> LONGATTR=`for I in 1 2 3 4 5 6 7 8 9 0; do echo -n veryveryveryveryveryveryverylongsecurexattrvalue; done`
> setfattr -n user.longsecurexattrname -v $LONGATTR mnt/securefilename
> sync
>
> rm -f mnt/securefilename
> umount mnt
> strings testsecdel
>
> yields:
>
> /mnt/test2/mnt
> lost+found
> securexattrname
> Ylongsecurexattrname
> mselinux
> veryveryveryveryveryveryverylongsecurexattrvalueveryveryveryveryveryveryverylongsecurexattrvalueveryveryveryveryveryveryverylongsecurexattrvalueveryveryveryveryveryveryverylongsecurexattrvalueveryveryveryveryveryveryverylongsecurexattrvalueveryveryveryveryveryveryverylongsecurexattrvalueveryveryveryveryveryveryverylongsecurexattrvalueveryveryveryveryveryveryverylongsecurexattrvalueveryveryveryveryveryveryverylongsecurexattrvalueveryveryveryveryveryveryverylongsecurexattrvaluesecurexattrvalueunconfined_u:object_r:file_t:s0
> lost+found
> securefilename
> /mnt/test2/mnt
>
> (this was with ext4.ko hacked to always enable secure delete)
>
> -Eric

alrighty, I will need to figure out how to get those out of there too. 
I will add this to my test case.  Thx!

