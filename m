From: Robert Yang <liezhi.yang@windriver.com>
Subject: Re: [PATCH V4 00/11] 2fsprogs/mke2fs: add an option: -d root-directory
Date: Thu, 6 Mar 2014 17:39:56 +0800
Message-ID: <5318426C.50105@windriver.com>
References: <1393661175-459-1-git-send-email-liezhi.yang@windriver.com> <CF3D6C67.74AD8%dvhart@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>
To: Darren Hart <dvhart@linux.intel.com>, <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:38191 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbaCFJkB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Mar 2014 04:40:01 -0500
In-Reply-To: <CF3D6C67.74AD8%dvhart@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 03/06/2014 04:21 PM, Darren Hart wrote:
> On 3/1/14, 0:06, "Robert Yang" <liezhi.yang@windriver.com> wrote:
>
>> * Changes of V4:
>>   - Rebase to the up to date master branch
>>   - Fix the skip of socket file (break -> continue)
>
> Robert,
>
> Thanks for taking the time to rebase these again. I don't have anything to
> add to my existing Reviewed-by's. We'd love to see this merged as we're
> currently having to work around issues with gen2extfs in the Yocto Project
> and we'd prefer to use upstream e2fsprogs/mke2fs. I think Robert has
> addressed all the issues that have been raised.
>

Yes, I think so, and we have used the "mke2fs -d" option in WR Linux for
more than half a year, didn't meet any obvious errors.

// Robert

> Are there any additional concerns?
>
> Thanks everyone for your time in reviewing,
>
> Darren
>
>>
>> * Changes of V3:
>>   - __FUNCTION__ -> __func__
>>   - Rebase to the up to date master branch
>>
>> * Changes of V2:
>>   - Add the "-d" option when the code is ready rather than add it in the
>>     first commit.
>>   - Remove "name = name"
>>   - func_name -> __FUNCTION__
>>   - The size impact on mke2fs:
>>     a) Not stripped:
>>        1,837,440 -> 1,903,522 (64K increased)
>>     b) Stripped:
>>        329,464 -> 321,272 (8K increased)
>>     No impact on tune2fs
>>
>> * Changes from the RFC patches:
>>   - Move the common code of debugfs and mke2fs to misc/create_inode.c to
>>     avoid bloating the tune2fs binary
>>   - Fix the error of "make check"
>>   - Rebase to the up to date master branch
>>
>> // Robert
>>
>> Robert Yang (11):
>>   mke2fs: add the ability to copy files from a given directory
>>   misc/create_inode.c: copy files recursively
>>   misc/create_inode.c: create special file
>>   misc/create_inode.c: create symlink
>>   misc/create_inode.c: copy regular file
>>   misc/create_inode.c: create directory
>>   misc/create_inode.c: set owner/mode/time for the inode
>>   mke2fs.c: add an option: -d root-directory
>>   misc/create_inode.c: handle hardlinks
>>   debugfs: use the functions in misc/create_inode.c
>>   mke2fs.8.in: update the manual for the -d option
>>
>> debugfs/Makefile.in |   17 +-
>> debugfs/debugfs.c   |  305 ++-------------------------
>> debugfs/debugfs.h   |    1 +
>> misc/Makefile.in    |   13 +-
>> misc/create_inode.c |  574
>> +++++++++++++++++++++++++++++++++++++++++++++++++++
>> misc/create_inode.h |   35 ++++
>> misc/mke2fs.8.in    |    7 +
>> misc/mke2fs.c       |   43 +++-
>> 8 files changed, 690 insertions(+), 305 deletions(-)
>> create mode 100644 misc/create_inode.c
>> create mode 100644 misc/create_inode.h
>>
>> --
>> 1.7.10.4
>>
>>
>
>
