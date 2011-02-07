From: Javi <javier.cabezas@gmail.com>
Subject: Heavy disk I/O on temporary mmap'ed files (ext4)
Date: Mon, 7 Feb 2011 01:41:01 -0600
Message-ID: <AANLkTikKWibkcV+ErcBe=C0oT3cyWH_2rfE9uv3qxsSN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45539 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab1BGHlV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Feb 2011 02:41:21 -0500
Received: by vws16 with SMTP id 16so2729829vws.19
        for <linux-ext4@vger.kernel.org>; Sun, 06 Feb 2011 23:41:21 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I am developing a software based DSM. In order to avoid concurrent
updates on a memory page that is being updated by the runtime I am
using a shadow mapping to perform the updates. This mappings are
created by opening a file, unlinking it and mmap-ing on the file
descriptor. Everything is working but I am experiencing heavy disk I/O
during execution on a machine with a single ext4 file system. Other
machines that use ext3 partitions don't exhibit this behavior (there
is no disk I/O at all). This machine is using the kernel version
2.6.35-25-generic.

The exact steps performed to create the mappings are:

    // Create the file
    snprintf(tmp, FILENAME_MAX, "/tmp/testXXXXXX");
    int fd = mkstemp(tmp);
    if(fd < 0) return NULL;
    unlink(tmp);

    if(ftruncate(fd, count) < 0) {
        close(fd);
        return NULL;
    }
    ...

    // Create a mapping
    addr = mmap(NULL, count, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);


Does ext4 write to mmap'ed files although they don't have a name in
the file system? Am I doing anything wrong?

Thanks,
  Javi
