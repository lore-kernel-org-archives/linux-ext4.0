From: Robert Yang <liezhi.yang@windriver.com>
Subject: e2fsprogs/debugfs/write: Input/output error when file size is zero
Date: Wed, 24 Jul 2013 16:59:10 +0800
Message-ID: <51EF975E.2090700@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
	Darren Hart <dvhart@linux.intel.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:51548 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab3GXI7e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Jul 2013 04:59:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hello experts,

I met a "Input/output error" problem when used debugfs' command "write"
to copy a zero size file to ext4 fs, here are the steps to reproduce the
problem:

$ dd if=/dev/zero of=test.img count=1M bs=1k
$ mkfs.ext4 -F test.img
$ touch emptyfile
$ debugfs -R "write emptyfile emptyfile" -w test.img
$ mkdir mnt
$ mount test.img mnt/
$ ls mnt/emptyfile
ls: cannot access mnt/emptyfile: Input/output error

The degbufs is from the up-to-date git repo, the ext2 and ext3 work well,
I think that it is caused by the EXT4_EXTENTS_FL, it works well if we
turn off the EXT4_EXTENTS_FL when the file size is zero, but this is not
a correct fix, would you please give me some instructions so that I can
fix it?

-- 
Thanks

Robert
