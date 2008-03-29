From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: all that __KERNEL__ checking in <linux/ext*.h> files
Date: Sat, 29 Mar 2008 19:19:14 -0400 (EDT)
Message-ID: <alpine.LFD.1.00.0803291917010.7878@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:42903 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYC2XTU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 29 Mar 2008 19:19:20 -0400
Received: from cpe00142a336e11-cm001ac318e826.cpe.net.cable.rogers.com ([72.140.150.221] helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1JfkKV-0001Yd-Dz
	for linux-ext4@vger.kernel.org; Sat, 29 Mar 2008 19:19:19 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  there's a pile of __KERNEL__ preprocessor testing in the ext[234].h
files in include/linux, but only ext2_fs.h is being exported to
userspace.  given the amount of checking, i'm reluctant to just toss
it all since it might be there for future considerations or something.

  is there a reason for it?

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
