From: Amir Goldstein <amir73il@gmail.com>
Subject: Fwd: Question about ext4 journal
Date: Fri, 23 Oct 2015 09:22:21 +0300
Message-ID: <CAOQ4uxh79509HYo=4N27FamLanh0sV9PqeQWWTk3HK526iTdHA@mail.gmail.com>
References: <CALLJCT3fAapW4aCSNPekeB8wx6XOU4O_PKfvQ7VhY-t8hrPBnA@mail.gmail.com>
	<CAOQ4uxhFw5HCyVuYsKROKvMHJWBCEqZfBM8gtcV1bPQGFXT-hQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 <linux-ext4@vger.kernel.org>
To: Masanari Iida <standby24x7@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:35812 "EHLO
	mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbbJWGWW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Oct 2015 02:22:22 -0400
Received: by lfbn126 with SMTP id n126so37927206lfb.2
        for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2015 23:22:21 -0700 (PDT)
In-Reply-To: <CAOQ4uxhFw5HCyVuYsKROKvMHJWBCEqZfBM8gtcV1bPQGFXT-hQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 23, 2015 at 7:04 AM, Masanari Iida <standby24x7@gmail.com> wrote:
>
> Hello Developer,


Hi Masanari,

>
> I have a question about ext4's internal.
>
> OS: RHEL6.2
> Filesystem EXT4
> mount option = ordered
>
> My understanding on ext4 with ordered mode,
> When a file is created,  data is written to FS block,
> At the same time,  metadata is stored into journal,
> and then meta data on journal is written to the inode block.
> What is the next?

there is also the metadata of the directory entry created for the new file
that gets journaled as well
>
>
> My question is
> Does the kernel remove the meta data on journal after each successful
>  transaction?

no. journal only logs transactions
>
>
> As I see the contents of journal entries in EXT4 using debugfs(8),
> the journal entries are growing when creating or deleting the files.
> I am curious to know what make the system to remove journal entries
> while mounted the fs.

it's called the orphan inode list.
every deleted inode gets inserted into the list, then deleted, then
removed from orphan inodes list.
on mount, fs starts by "playing" the journal, then clearing the orphan
inodes list

>
> Background of the question.
> I have encountered a case that when I delete and create some files,
> journal entry for deleting the file exist
> But journal entry for creating the file was not exist.
> FYI, the file itself exist when I see it by using debugfs.
>
> I created snapshot of the filesystem and  run fsck on copy image.
> Then the file was _removed_ by fsck operation.

fsck starts by "playing" the journal. then I think it will ask about
clearing the orphan inode list. can't remember.

>
> This is why I want to know how journal on EXT4 were controlled.
>
> Thanks
> Masanari
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
