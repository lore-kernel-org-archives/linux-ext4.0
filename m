From: Masanari Iida <standby24x7@gmail.com>
Subject: Re: Question about ext4 journal
Date: Sat, 24 Oct 2015 12:10:48 +0900
Message-ID: <CALLJCT2T9t9Qsn+6CPCJqd9HLTHn1ZHdOOM74+8X-LHvPuhqaw@mail.gmail.com>
References: <CALLJCT3fAapW4aCSNPekeB8wx6XOU4O_PKfvQ7VhY-t8hrPBnA@mail.gmail.com>
	<CAOQ4uxhFw5HCyVuYsKROKvMHJWBCEqZfBM8gtcV1bPQGFXT-hQ@mail.gmail.com>
	<CAOQ4uxh79509HYo=4N27FamLanh0sV9PqeQWWTk3HK526iTdHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:33400 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbbJXDKs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Oct 2015 23:10:48 -0400
Received: by igbkq10 with SMTP id kq10so45804256igb.0
        for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2015 20:10:48 -0700 (PDT)
In-Reply-To: <CAOQ4uxh79509HYo=4N27FamLanh0sV9PqeQWWTk3HK526iTdHA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 23, 2015 at 3:22 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Oct 23, 2015 at 7:04 AM, Masanari Iida <standby24x7@gmail.com> wrote:
>>
>> As I see the contents of journal entries in EXT4 using debugfs(8),
>> the journal entries are growing when creating or deleting the files.
>> I am curious to know what make the system to remove journal entries
>> while mounted the fs.
>
> it's called the orphan inode list.
> every deleted inode gets inserted into the list, then deleted, then
> removed from orphan inodes list.
> on mount, fs starts by "playing" the journal, then clearing the orphan
> inodes list
>
Hello Amir,   Ted,

My test case
(1)   Create a small file by vi.  (about 1000bytes)
(2)   Delete the file "rm -f"
===== within 1 min =====
(3)   Create a small file again with same file name as (1).
=====  12 hours of no operation ,  no umount, no mount, no fsck ======
(4)  Snapshot ( created by storage device )
===== some days ======
(5)  Run fsck the fs image and mount the fs

I understand that in step2,  when the file delete happen,
   inode gets insert into orphan list,
         delete the file data
             inode gets deleted from orphan list.

My wild guess is
file was created in inode #100 (for example),
it was deleted and inode #100 moved to orphan list.
The inode #100 was re-used in step 3.
snapshot taken.
Run fsck.   inode #100 was found in orphan list, so the file with same
inode was deleted during fsck.

Did we have such trouble during 2.6.32 time?

Regards,
Masanari
