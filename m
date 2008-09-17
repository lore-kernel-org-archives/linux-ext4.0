From: "Rohit Sharma" <imreckless@gmail.com>
Subject: Reading inode..
Date: Wed, 17 Sep 2008 19:37:06 +0530
Message-ID: <2d08ef090809170707x1564f440k7f69c92eac04b9e7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Kernelnewbies <kernelnewbies@nl.linux.org>
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:51744 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbYIQOHI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Sep 2008 10:07:08 -0400
Received: by gxk9 with SMTP id 9so29574234gxk.13
        for <linux-ext4@vger.kernel.org>; Wed, 17 Sep 2008 07:07:06 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I want to read ext2 inode.

Its just like i have a inode no. say 1900..
so from the block group we can read the group descriptor and from there we
can identify the first block no. of the inode table.
So we can read the required inode no.i.e. 1900 from this inode table.
I found that there are 8176 inodes per block group using tune2fs utility,
so if i am interested in reading 8177th inode then i have to move on
to next block groups inode table.

I just want to verify if i am correct on this.
