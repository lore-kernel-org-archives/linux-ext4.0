From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: backup of the last group'descriptor when it is the 1st group of a meta_bg
Date: Tue, 27 Mar 2012 22:47:34 +0800
Message-ID: <CAGBYx2bbucN5MN0MfRXK3=x74mY3-+foGuQc2Gd4oQzJAzPVKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62859 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab2C0Orh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Mar 2012 10:47:37 -0400
Received: by yenl12 with SMTP id l12so4675313yen.19
        for <linux-ext4@vger.kernel.org>; Tue, 27 Mar 2012 07:47:37 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted, Andreas and List,

As Andreas pointed out last year, if the last group is the 1st group
in a meta bg, then its group desc has no backup.
With meta_bg resizing inode is useless,  I had a thought that we store
a backup group descriptor of the last group in the resizing inode=EF=BC=
=9F
What's your opinions?

Yongqiang.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
