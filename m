From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: e2fsprogs-1.41.0 - error opening fs with badblocks.
Date: Tue, 2 Sep 2008 17:38:25 +0530
Message-ID: <ea11fea30809020508i6b6ad758x207959471e289a0a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.185]:18849 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbYIBMI1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Sep 2008 08:08:27 -0400
Received: by ti-out-0910.google.com with SMTP id b6so1375438tic.23
        for <linux-ext4@vger.kernel.org>; Tue, 02 Sep 2008 05:08:25 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I have created a test ext4 FS of 2.3GB. While running badblocks on it,
I get the below error.

/home/mkatiyar/e2fs-git/e2fsprogs_work/sbin> ./badblocks myfs
./badblocks: Value too large for defined data type while trying to open myfs

/home/mkatiyar/e2fs-git/e2fsprogs_work/sbin> ls -lh myfs
-rw-r--r-- 1 mkatiyar mkatiyar 2.3G 2008-09-02 10:13 myfs

This is due to open returning EOVERFLOW , but as per man page it
should happen if the size of the file cannot be represented correctly
in off_t which I don't think
is the case here.

I am on Ubuntu 8.04.

Thanks -
Manish
