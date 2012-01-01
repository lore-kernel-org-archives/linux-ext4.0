From: Thomas Lindroth <thomas.lindroth@gmail.com>
Subject: e4defrag modifies folder's mtime.
Date: Sun, 01 Jan 2012 21:12:36 +0100
Message-ID: <4F00BE34.1080006@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36552 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752940Ab2AAUMj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jan 2012 15:12:39 -0500
Received: by lahd3 with SMTP id d3so3313961lah.19
        for <linux-ext4@vger.kernel.org>; Sun, 01 Jan 2012 12:12:38 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I ran e4defrag from e2fsprogs-1.42 on a file system and a lot of folders 
had their mtime updated as a result. This confuses both my backup 
program and myself. I guess the folder timestamps change because the 
temporary donor file is created in the same directory as the original 
file. XFS's defrag program put the donor files in a temporary folder in 
the root of the file system. Maybe e4defrag could do the same.

/Thomas Lindroth
