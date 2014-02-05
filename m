From: Ahmed Tamrawi <ahmedtamrawi@gmail.com>
Subject: mutex_unlock is missed in function (swap_inode_boot_loader) in file (linux-3.13/fs/ext4/ioctl.c)
Date: Wed, 5 Feb 2014 13:39:06 -0600
Message-ID: <CAFZT-j+KqKfx5sEr3G9JbesUNgp60vi9Zn_tT=78S-WrVmmxKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ve0-f171.google.com ([209.85.128.171]:45867 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaBETjH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Feb 2014 14:39:07 -0500
Received: by mail-ve0-f171.google.com with SMTP id pa12so695059veb.2
        for <linux-ext4@vger.kernel.org>; Wed, 05 Feb 2014 11:39:07 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi there!

Bug Report Filed: https://bugzilla.kernel.org/show_bug.cgi?id=70091
Linux Version [3.13]
Configuration: Default configuration for x86


In function (swap_inode_boot_loader) in file (linux-3.13/fs/ext4/ioctl.c):

The structures: (inode->i_mutex) and (inode_bl->i_mutex) gets
successfully locked at line (133) by (lock_two_nondirectories(inode,
inode_bl), but both are not unlocked when the function returns after
line (147), however they got unlocked only at line (208) by
(unlock_two_nondirectories(inode, inode_bl)).

A possible solution is to call (unlock_two_nondirectories(inode,
inode_bl)) before line (147).


Thanks,
Ahmed
