From: shweta saxena <shweta0232@gmail.com>
Subject: Storing inode block device information in struct sb_info
Date: Tue, 13 Sep 2011 20:26:13 -0400
Message-ID: <CAL==pd23yRnG8B-5bhr2bChPBvPLsrmQ9EkjC8FfANYxttCdzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40844 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab1INA0O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Sep 2011 20:26:14 -0400
Received: by eyx24 with SMTP id 24so726599eyx.19
        for <linux-ext4@vger.kernel.org>; Tue, 13 Sep 2011 17:26:13 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

 I am trying to separate metadata from data and mount it seperately on
a block device.I have an idea abt how to separate it ,  a) Parsing a
new inode device mount point b) Storing inode block device information
in struct sb_info

I had some doubts and confusions related to storing the inode block
device information in struct ext4_sb_info.
I am not sure about how to go about doing it. I guess that it can be
done by mounting the block device in the VFS first and then storing it
in struct ext4_sb_info in ext4.h header file.

Any help would be really appreciated.
