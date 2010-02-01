From: "kyle" <kylewong@southa.com>
Subject: Re: need help with getting into a corrupted sub directory
Date: Mon, 1 Feb 2010 12:08:01 +0800
Message-ID: <00b601caa2f4$2564bf80$b902a8c0@kyle>
References: <004d01caa172$8d846c10$6401a8c0@kyle> <27FC5E2E-2F85-478A-95F2-1B9ED9D07690@sun.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>
To: "Andreas Dilger" <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.southa.com ([125.215.237.177]:45706 "HELO southa.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750863Ab0BAEOn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 31 Jan 2010 23:14:43 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>
> To get most of the data off the dying drive, use rsync -v, and create
> a list
> of files to exclude, when you detect they cause the drive to die.

I need to get files from 'public/EL/', however, 'public' cause the drive die
........

>
>
> debugfs is your friend.  It can open and list a directory by inode
> number, and dump the files to another filesystem.

Is it possible to get the inode number of 'public/EL' without hitting the
'public' which cause the drive die?

Kyle

