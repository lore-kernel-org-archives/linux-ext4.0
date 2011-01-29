From: Stuart Pook <slp4725@pook.it>
Subject: Re: error ext4_mb_generate_buddy:726 & add_dirent_to_buf:1272 after
 online resize
Date: Sat, 29 Jan 2011 23:15:56 +0100
Message-ID: <4D44919C.6010404@pook.it>
References: <S1752440Ab1APNtL/20110116134911Z+826@vger.kernel.org> <4D32FACD.7020907@pook.it> <4D3300A5.1090300@pook.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:59976 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab1A2WQH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Jan 2011 17:16:07 -0500
Received: from shiva (unknown [88.171.134.228])
	by smtp6-g21.free.fr (Postfix) with ESMTP id BC2BB8226C
	for <linux-ext4@vger.kernel.org>; Sat, 29 Jan 2011 23:15:59 +0100 (CET)
In-Reply-To: <4D3300A5.1090300@pook.it>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I am getting these message about once a day. Each message arrives 24 hours amd a few minuted after the last message, wierd.  Inode 262145 is a directory that I created just after the online resize of the filesystem.

I have emptied the directory. Should I remove it? Or should I rebuild the filesystem?

Thanks for any advice

:; zgrep 'EXT4-fs.*error' /var/log/syslog*
/var/log/syslog:Jan 29 17:57:21 kooka kernel: : [1125159.904008] EXT4-fs (dm-28): error count: 11
/var/log/syslog:Jan 29 17:57:21 kooka kernel: : [1125159.904014] EXT4-fs (dm-28): initial error at 1295177566: ext4_mb_generate_buddy:726
/var/log/syslog:Jan 29 17:57:21 kooka kernel: : [1125159.904017] EXT4-fs (dm-28): last error at 1295177566: add_dirent_to_buf:1272: inode 262145: block 1048578
/var/log/syslog.1:Jan 28 17:55:34 kooka kernel: : [1038652.384009] EXT4-fs (dm-28): error count: 11
/var/log/syslog.1:Jan 28 17:55:34 kooka kernel: : [1038652.384015] EXT4-fs (dm-28): initial error at 1295177566: ext4_mb_generate_buddy:726
/var/log/syslog.1:Jan 28 17:55:34 kooka kernel: : [1038652.384018] EXT4-fs (dm-28): last error at 1295177566: add_dirent_to_buf:1272: inode 262145: block 1048578
/var/log/syslog.2.gz:Jan 27 17:53:46 kooka kernel: : [952144.864006] EXT4-fs (dm-28): error count: 11
/var/log/syslog.2.gz:Jan 27 17:53:46 kooka kernel: : [952144.864012] EXT4-fs (dm-28): initial error at 1295177566: ext4_mb_generate_buddy:726
/var/log/syslog.2.gz:Jan 27 17:53:46 kooka kernel: : [952144.864015] EXT4-fs (dm-28): last error at 1295177566: add_dirent_to_buf:1272: inode 262145: block 1048578
/var/log/syslog.3.gz:Jan 26 17:51:59 kooka kernel: : [865637.344007] EXT4-fs (dm-28): error count: 11
/var/log/syslog.3.gz:Jan 26 17:51:59 kooka kernel: : [865637.344013] EXT4-fs (dm-28): initial error at 1295177566: ext4_mb_generate_buddy:726
/var/log/syslog.3.gz:Jan 26 17:51:59 kooka kernel: : [865637.344017] EXT4-fs (dm-28): last error at 1295177566: add_dirent_to_buf:1272: inode 262145: block 1048578
/var/log/syslog.4.gz:Jan 25 17:50:11 kooka kernel: : [779129.824008] EXT4-fs (dm-28): error count: 11
/var/log/syslog.4.gz:Jan 25 17:50:11 kooka kernel: : [779129.824014] EXT4-fs (dm-28): initial error at 1295177566: ext4_mb_generate_buddy:726
/var/log/syslog.4.gz:Jan 25 17:50:11 kooka kernel: : [779129.824018] EXT4-fs (dm-28): last error at 1295177566: add_dirent_to_buf:1272: inode 262145: block 1048578
/var/log/syslog.5.gz:Jan 24 17:48:24 kooka kernel: : [692622.304007] EXT4-fs (dm-28): error count: 11
/var/log/syslog.5.gz:Jan 24 17:48:24 kooka kernel: : [692622.304013] EXT4-fs (dm-28): initial error at 1295177566: ext4_mb_generate_buddy:726
/var/log/syslog.5.gz:Jan 24 17:48:24 kooka kernel: : [692622.304017] EXT4-fs (dm-28): last error at 1295177566: add_dirent_to_buf:1272: inode 262145: block 1048578
/var/log/syslog.6.gz:Jan 23 17:46:36 kooka kernel: : [606114.784006] EXT4-fs (dm-28): error count: 11
/var/log/syslog.6.gz:Jan 23 17:46:36 kooka kernel: : [606114.784012] EXT4-fs (dm-28): initial error at 1295177566: ext4_mb_generate_buddy:726
/var/log/syslog.6.gz:Jan 23 17:46:36 kooka kernel: : [606114.784015] EXT4-fs (dm-28): last error at 1295177566: add_dirent_to_buf:1272: inode 262145: block 1048578
/var/log/syslog.7.gz:Jan 22 17:44:49 kooka kernel: : [519607.264009] EXT4-fs (dm-28): error count: 11
/var/log/syslog.7.gz:Jan 22 17:44:49 kooka kernel: : [519607.264015] EXT4-fs (dm-28): initial error at 1295177566: ext4_mb_generate_buddy:726
/var/log/syslog.7.gz:Jan 22 17:44:49 kooka kernel: : [519607.264018] EXT4-fs (dm-28): last error at 1295177566: add_dirent_to_buf:1272: inode 262145: block 1048578
