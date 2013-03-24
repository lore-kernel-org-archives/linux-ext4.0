From: Subranshu Patel <spatel.ml@gmail.com>
Subject: Type of filesystem block
Date: Sun, 24 Mar 2013 22:05:12 +0530
Message-ID: <CAEUQcegWM0d3tmpNXVmeOSKAJUPzthk8uH96XMN+Ax_5ex5H5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qe0-f50.google.com ([209.85.128.50]:55760 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab3CXQt1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Mar 2013 12:49:27 -0400
Received: by mail-qe0-f50.google.com with SMTP id k5so2991012qej.37
        for <linux-ext4@vger.kernel.org>; Sun, 24 Mar 2013 09:49:25 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Query related to finding the block usage information of metadata
blocks in ext4 filesystem.

Using debugfs testb command I can check whether a particular
filesystem block is used or not.
# debugfs -R "testb 171428" /dev/sdd4
debugfs 1.41.12 (17-May-2010)
Block 171428 marked in use

Also its icheck command prints the inode associated, if any, with a
filesystem block.
# debugfs -R "icheck 171428" /dev/sdd4
debugfs 1.41.12 (17-May-2010)
Block     Inode number
171428    65152
But I don=E2=80=99t find any  debugfs command which can show similar bl=
ock
usage information about metadata blocks, whether it is a superblock,
or inode bitmap block or block group descriptor, etc.
Is there any way to extract the usage information of metadata blocks
in ext4 filesystem ?
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
