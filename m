From: Yafang Shao <laoar.shao@gmail.com>
Subject: help about ext3 read-only issue on ext3(2.6.16.30)
Date: Sat, 1 Dec 2012 22:22:13 +0800
Message-ID: <CALOAHbDC8jguV7GeSuN01UWBk+74wVHho8Fe9HLan06FZSpw0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: wuqixuan@huawei.com, lizefan@huawei.com, wuqixuan@gmail.com
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62991 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab2LAOWO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Dec 2012 09:22:14 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

We have many x86 boards, and we've been using 2.6.16.60 for a long
time. Before time we occasionally found ext3 was switched to read-only
while services were running, and we took it for granted it must be
some hardware problems.
    But recently this issue happens frequently, both in old boards and
new boards. We've analyzed logs, and in one board we did find
exceptional reboot (but ext3 error happened 9 days after), and in
another board we found mptbase recovery routine, but in all other
boards there's no suspicious output at all.
    The only change with the system is some application updates, and
apps now put more IO burden on disks.
    The error always happened in ext3_readdir, like this:

 EXT3-fs error (device sda7): ext3_readdir: bad entry in directory
#6685458: rec_len is smaller than minimal - offset=3860, inode=0,
rec_len=0, name_len=0

Aborting journal on device sda7.

EXT3-fs error (device sda7) in start_transaction: Readonly filesystem

Aborting journal on device sda7.

ext3_abort called.

EXT3-fs error (device sda7): ext3_journal_start_sb: Detected aborted journal

Remounting filesystem read-only

__journal_remove_journal_head: freeing b_committed_data



We highly doubt it's hardware failures with this frequency in mind, so
we're wondering regarding to this issue if there's some ext3 bug-fix
having merged into mainline but not in our old kernel?

if hardware problem cause it, what's exactly are these hardware problems?



Thanks & Regards!
