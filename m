From: Curt Wohlgemuth <curtw@google.com>
Subject: Question on fallocate/ftruncate sequence
Date: Mon, 20 Jul 2009 09:36:33 -0700
Message-ID: <6601abe90907200936w61ebda92reae368a2b9efac66@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:5161 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbZGTQgj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Jul 2009 12:36:39 -0400
Received: from wpaz37.hot.corp.google.com (wpaz37.hot.corp.google.com [172.24.198.101])
	by smtp-out.google.com with ESMTP id n6KGaa3U031676
	for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2009 17:36:36 +0100
Received: from pzk31 (pzk31.prod.google.com [10.243.19.159])
	by wpaz37.hot.corp.google.com with ESMTP id n6KGaX8n032227
	for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2009 09:36:34 -0700
Received: by pzk31 with SMTP id 31so1807565pzk.3
        for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2009 09:36:33 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We've recently seen some interesting behavior with ftruncate()
following a fallocate() call on ext4, and would like to know if this
is intended or not.

The sequence used from user space:

fd = open()
fallocate(fd, FALLOC_FL_KEEP_SIZE, 8MB)
write(fd, buf, 64KB)
ftruncate(fd, 64KB)
close(fd)

Since inode_setattr() only does something if the input size is not the
same as inode->i_size, the ftruncate() call above does nothing; no
blocks from the fallocate() are freed up.

Yes, removing the KEEP_SIZE flag gets the behavior I'm expecting, but
KEEP_SIZE is quite convenient in recovering from errors.

I would have thought that ftruncate() would alter i_disksize even if
this value is different from i_size.

Any comments?  I looked at other Linux file systems, and none that I
saw that support fallocate() have this issue.

Thanks,
Curt
