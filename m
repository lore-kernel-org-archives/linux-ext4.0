From: =?Big5?B?p7qsZr+r?= <solarispika@gmail.com>
Subject: Question on delalloc
Date: Tue, 4 Jun 2013 03:00:29 +0800
Message-ID: <CAJ1XODTmBmdOu+EL8OZy8ZRU4DbT7F179U7BrNDrQJQGtYQuWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:51413 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757223Ab3FCTAa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Jun 2013 15:00:30 -0400
Received: by mail-ob0-f177.google.com with SMTP id ta17so7972126obb.36
        for <linux-ext4@vger.kernel.org>; Mon, 03 Jun 2013 12:00:29 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi everybody,

I am new to ext4 and doing research on Android with ext4 as file
system. These days, I have a question on ext4's delayed allocation
against ext4_sync_file.
I have learned that delalloc won't guarantee file data's integrity on
power failure, since those delayed allocated buffer heads won't be
handled by jbd2. In order to protect data, user programs need to fsync
those files to be secured.
But I have no idea on how ext4_sync_file would write those delalloc'd
data down to disk.
This is how I traced it.
In ext4_sync_file, I split it into roughly three parts where I think
possible to do IOs:
1. filemap_write_and_wait_range
2. ext4_flush_completed_IO
3. ext4_force_commit or jbd2_log_start_commit

Since we know that jbd2 don't play with those delalloc'd data, part 3
can be excluded.
Also after I traced into filemap_write_and_wait_range, I found it
eventually calls ext4_writepage to do the most part of work, which in
its comment says "We don't do any block allocation in this function."
And it will redirty page and do nothing whenever it find those pages
have delay or unwritten buffer heads.
Last, I found ext4_flush_completed_IO won't do anything for most of
the time list_empty(&ei->i_completed_io_list) holds.

So, can anyone kindly shed any light on my question, or point out my mistakes?

thanks,

Sung Po-Han
