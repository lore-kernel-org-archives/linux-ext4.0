From: "LIOU Payphone" <lioupayphone@gmail.com>
Subject: a potential deadlock?
Date: Fri, 26 Oct 2007 14:52:29 +0800
Message-ID: <002701c8179c$cc3a02b0$64ae0810$@com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.189]:49251 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbXJZGwu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Oct 2007 02:52:50 -0400
Received: by rv-out-0910.google.com with SMTP id k20so705385rvb
        for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 23:52:48 -0700 (PDT)
Content-Language: zh-cn
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi All

Here is a question to be confirmed.

In ext3_ioctl() with "cmd == EXT3_IOC_SETFLAGS", we firstly lock
"inode->i_mutex", start a handle with 1 journal-block by calling
ext3_journal_start(). In ext3_new_blocks(), say QUOTA was enabled with vfsv0
format, we will call the function "DQUOT_ALLOC_BLOCK()". The handle in
ext3_new_blocks()  was started by high-level functions, and
DQUOT_ALLOC_BLOCK() will finally calles ext3_quota_write() in which it try
to lock the "i_mutex" of the inode of a quota-file. 

At it happens, when we want to modify the inodes of quota-files via
ext3_ioctl(cmd = EXT3_IOC_SETFLAGS) (say process-A), another guy try to
execute ext3_quota_write() by calling DQUOT_ALLOC_BLOCK() (say process-B). I
guess a potential deadlock between process-A and process-B would happen in
such a executing sequence:

(1) process-B got many journal-blocks, then came into ext3_new_blocks(),
hung up
(2) process-A locked i_mutex of the inode of a quota-file, then try to
starts a handle. Unfortunately, there are no enough journal-blocks left for
process-A.
(3) process-B awakened, and came into DQUOT_ALLOC_BLOCK(), finally came into
the function ext3_quota_write() who also wants to lock the i_mutex of the
inode of a quota-file. But the i_mutex was locked by process-A. so process-B
has no choice but to wait.
(4) if the ext3-filesystem was  too busy to release jounal-blocks for
process-A, or a unexpected incident happened. Both  the two situations would
result in no journal-blocks for any other processes. Apparently, process-A
have to wait for available journal-blocks. so process-A was hung-up with
i_mutex of the inode of a quota-file locked.
(5) process-B was blocked by the "inode->i_mutex" subsequently.

a deadlock happened?

is such a suppose reasonable?

Payphone
