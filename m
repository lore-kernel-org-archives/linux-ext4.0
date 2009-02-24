From: Andreas Friedrich Berendsen <afberendsen@gmail.com>
Subject: May I suggested an update for ext4.txt file?
Date: Wed, 25 Feb 2009 06:00:00 +1300
Message-ID: <1235494800.11758.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.191]:14125 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbZBXRAK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Feb 2009 12:00:10 -0500
Received: by ti-out-0910.google.com with SMTP id d10so2290604tib.23
        for <linux-ext4@vger.kernel.org>; Tue, 24 Feb 2009 09:00:06 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

kernel 2.6.28.7
efs2prog: 1.41.4

File Documentation/filesystems/ext4.txt states:

...
    Or to configure an existing ext3 filesystem to support extents:

        # tune2fs -O extents /dev/hda1
....


To convert from ext2 (a very old filesystem :) ) to ext4, it's necessary
to add more options. I'm not sure which one made the trick.

tune2fs -O
has_journal,dir_index,filetype,extent,flex_bg,sparse_super,large_file,huge_file,uninit_bg,dir_nlink,extra_isize 

Also, /etc/filesystems does not contain an entry for
ext4. /etc/efs2prog.conf is ok.

-- Berendsen


