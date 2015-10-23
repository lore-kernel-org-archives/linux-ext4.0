From: Masanari Iida <standby24x7@gmail.com>
Subject: Question about ext4 journal
Date: Fri, 23 Oct 2015 13:04:54 +0900
Message-ID: <CALLJCT3fAapW4aCSNPekeB8wx6XOU4O_PKfvQ7VhY-t8hrPBnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:34676 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbbJWEEz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Oct 2015 00:04:55 -0400
Received: by igbni9 with SMTP id ni9so27399958igb.1
        for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2015 21:04:54 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Developer,
I have a question about ext4's internal.

OS: RHEL6.2
Filesystem EXT4
mount option = ordered

My understanding on ext4 with ordered mode,
When a file is created,  data is written to FS block,
At the same time,  metadata is stored into journal,
and then meta data on journal is written to the inode block.
What is the next?

My question is
Does the kernel remove the meta data on journal after each successful
 transaction?

As I see the contents of journal entries in EXT4 using debugfs(8),
the journal entries are growing when creating or deleting the files.
I am curious to know what make the system to remove journal entries
while mounted the fs.

Background of the question.
I have encountered a case that when I delete and create some files,
journal entry for deleting the file exist
But journal entry for creating the file was not exist.
FYI, the file itself exist when I see it by using debugfs.

I created snapshot of the filesystem and  run fsck on copy image.
Then the file was _removed_ by fsck operation.
This is why I want to know how journal on EXT4 were controlled.

Thanks
Masanari
