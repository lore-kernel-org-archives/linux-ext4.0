From: Robert Yang <liezhi.yang@windriver.com>
Subject: Re: [RFC 00/10] e2fsprogs/mke2fs: add an option: -d root-directory
Date: Mon, 2 Sep 2013 14:46:33 +0800
Message-ID: <52243449.1070203@windriver.com>
References: <1377667560-20089-1-git-send-email-liezhi.yang@windriver.com> <20130901032654.GA21899@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
To: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>,
	<dvhart@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:36336 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab3IBGrM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Sep 2013 02:47:12 -0400
In-Reply-To: <20130901032654.GA21899@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 09/01/2013 11:26 AM, Zheng Liu wrote:
> Hi Robert,
>
> On Wed, Aug 28, 2013 at 01:25:50PM +0800, Robert Yang wrote:
>> This option is used for adding the files from the root-directory to the
>> filesystem, it is similiar to genext2fs, but genext2fs doesn't fully
>> support ext4.
>>
>> * Questions
>>    - Is such an option acceptable ?
>>
>>    - Most of the code have been in debugfs/debugfs.c already, I moved them to
>>      misc/util.c and modified them to let both mke2fs and debugfs can use them,
>>      maybe we should put these code in another separate file ?
>>
>>    - Where can I get the up-to-date development git repo, please? I think that
>>      there would be conflicts with the dev git repo, I'd like to rebase it if I
>>      can get the repo, currently, I'm using this one:
>>
>>      http://git.kernel.org/cgit/fs/ext2/e2fsprogs.git
>>
>> * The size impact on misc/mke2fs:
>>     1,677,297 -> 1,728,110 (non stripped, about 50K increases)
>>     316,968 -> 325,160 (stripped, 8K increases)
>>
>> Please feel free to give your comments.
>
> If I understand correctly, after applied this patch set, we can copy
> some files from a directory that is indicated by '-d' option when we
> create a new ext4 file system.  My concern is why we need to add this
> option?  Without this option I can use 'mkfs.ext4 ${DEV}', 'mount ${DEV}
> ${MNT}' and 'cp ${SRC} ${MNT}' to do the same thing.  I am not
> convinced.  Could you please describe more details for this patch set?
>

Hi Zheng,

Yes, you are right, we can run mkfs/mount/cp to do the same thing,
but the problem is that the "mount" command requires the root privilege,
but we may not have it when we are working on a sever (the mkfs doesn't
need the root privilege), for example

$ dd if=/dev/zero of=test.img count=0 bs=1k seek=2M
$ mke2fs -t ext4 -F test.img -d <root-dir>

Will create an ext4 image with the files copied without the root privilege.

// Robert

> Regards,
>                                                  - Zheng
>
>>
>> // Robert
>>
>> Robert Yang (10):
>>    mke2fs.c: add an option: -d root-directory
>>    misc/util.c: implement populate_fs()
>>    misc/util.c: create special file
>>    misc/util.c: create symlink
>>    misc/util.c: copy regular file
>>    misc/util.c: create directory
>>    misc/util.c: set more information for inode
>>    misc/util.c: handle hardlinks
>>    mke2fs.8.in: update the manual for the -d option
>>    debugfs: use the functions in misc/util.c
>>
>>   debugfs/Makefile.in |   7 +-
>>   debugfs/debugfs.c   | 251 ++-----------------------
>>   debugfs/debugfs.h   |   1 +
>>   misc/mke2fs.8.in    |   7 +
>>   misc/mke2fs.c       |  39 +++-
>>   misc/util.c         | 519 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   misc/util.h         |  32 ++++
>>   7 files changed, 614 insertions(+), 242 deletions(-)
>>
>> --
>> 1.8.1.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
