From: Yang Bai <hamo.by@gmail.com>
Subject: Question about doing umount when disk fails
Date: Thu, 11 Oct 2012 15:13:26 +0800
Message-ID: <CAO_0yfMrsKxu2mT+XnpoUqTeRba+dO=Ex40doyXhXVqegR7eeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: fengguang.wu@intel.com, viro@zeniv.linux.org.uk, tytso@mit.edu,
	adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34299 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab2JKHNs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Oct 2012 03:13:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

HI all,

We found a problem when umount an ext4 partition, if at the same time,
disk fails, the umount process will stay at uninterrupt sleep status
and flush thread will be blocked.

As I know, when doing umount, the filesystem will sync all changes in
memory back to disk through SYNC IO, if the disk fails, the io request
can not finish.

My question is: Could the sync operation notice the IO errors on disk
and cancel itself. So the flush thread will not be blocked and umount
process will exit with an error code.

This may also affect the process of write back, so I add fengguang and viro.

Thanks very much,
Yang
