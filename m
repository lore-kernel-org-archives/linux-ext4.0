From: Autif Khan <autif.mlist@gmail.com>
Subject: Re: Filesystem state: clean with errors - what errors?
Date: Tue, 4 Jun 2013 08:39:12 -0400
Message-ID: <CADzUK1JyZA=2+yn7K30K5te-cZTiS0RY9L8YYKn+Dr1JxhHOtQ@mail.gmail.com>
References: <CADzUK1K08XjYuz_Mrv6sF8e7-M9ToStfjN7e7s3v+2q9wX+-xQ@mail.gmail.com>
	<51ACEAEF.6040109@redhat.com>
	<CADzUK1KXvQbb+jUK=JpYLXD1S+-dCLnYRU8Dc+mPDf3b4ipU8A@mail.gmail.com>
	<51ACEFA8.8000907@redhat.com>
	<CADzUK1JvWW=YkS2e1gZM=Zt3SDKbhLhqH0_i_UnVLhBY51r2Nw@mail.gmail.com>
	<51ACF922.2050306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:49052 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab3FDMjO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Jun 2013 08:39:14 -0400
Received: by mail-lb0-f179.google.com with SMTP id w20so581225lbh.24
        for <linux-ext4@vger.kernel.org>; Tue, 04 Jun 2013 05:39:12 -0700 (PDT)
In-Reply-To: <51ACF922.2050306@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 3, 2013 at 4:14 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 6/3/13 3:07 PM, Autif Khan wrote:
>> On Mon, Jun 3, 2013 at 3:34 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>>> On 6/3/13 2:29 PM, Autif Khan wrote:
>>>> On Mon, Jun 3, 2013 at 3:13 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>>>>> On 6/3/13 1:45 PM, Autif Khan wrote:
>>>>>> Executing dumpe2fs -h on one of the partitions says
>>>>>>
>>>>>> ...
>>>>>> Filesystem features:      has_journal ext_attr resize_inode dir_index
>>>>>> filetype extent flex_bg sparse_super large_file huge_file uninit_bg
>>>>>> dir_nlink extra_isize
>>>>>> Filesystem flags:         signed_directory_hash
>>>>>> Default mount options:    user_xattr acl
>>>>>> Filesystem state:         clean with errors
>>>>>> ...
>>>>>>
>>>>>> How can I find out what the errors are - the details of the errors.
>>>>>
>>>>> "clean" means the log has been replayed (log is not dirty)
>>>>> "with errors" means that it encountered concistency errors at runtime
>>>>>
>>>>> run e2fsck -f on it to see what it finds (or e2fsck -fn if you want a no-op
>>>>> dry run)
>>>>
>>>> --- spin ---
>>>>
>>>> ubuntu@mac0013950af6fb:~$ sudo fsck -V -n -f /dev/sda5
>>>> fsck from util-linux 2.20.1
>>>> [/sbin/fsck.ext4 (1) -- /koko] fsck.ext4 -n -f /dev/sda5
>>>> e2fsck 1.42 (29-Nov-2011)
>>>> Warning!  /dev/sda5 is mounted.
>>>
>>> Surprising that it didn't find errors since you ran it on a mounted fs!
>>>
>>> That's also an older e2fsck, so I suppose it's possible that it missed
>>> something.
>>>
>>>> Pass 1: Checking inodes, blocks, and sizes
>>>> Pass 2: Checking directory structure
>>>> Pass 3: Checking directory connectivity
>>>> Pass 4: Checking reference counts
>>>> Pass 5: Checking group summary information
>>>> /dev/sda5: 24770/262144 files (0.1% non-contiguous), 328031/1048576 blocks
>>>> ubuntu@mac0013950af6fb:~$
>>>>
>>>> I am not sure I see any errors. Is there an error here?
>>>
>>> No, that didn't report any errors.
>>>
>>> If you unmount it and do it w/o -n, it should clear the error state.
>>> Perhaps it encountered an error for a file that got subsequently deleted,
>>> or something - not sure.
>>>
>>
>> That is true - we are able to fix this - almost trivially - the
>> problem is that we are causing this frequently (sometimes always) with
>> inexpensive SSDs. I am sure you have seen my other email:
>> http://marc.info/?l=linux-ext4&m=137028288823079&w=2
>>
>> I assume that there is no other tool that I can use - (short of a hex
>> dump of the 4.0G partition using dd) - to further debug this. Is
>> there?
>
> "with errors" is printed when the fs state has EXT2_ERROR_FS set.
>
> Looking at the system logs would be a start - when the filesystem was set
> into error state, the kernel should have logged that fact, along with
> why it did so... you could go from there.
>
> Also, kernels since 2.6.36 save more info:
>

We are at 3.2.33, so we should be good.

However, I do not see "with errors" in either dmesg or /var/log/syslog.

Is there a kernel config that needs to be set to enable EXT2/3/4 logging?
