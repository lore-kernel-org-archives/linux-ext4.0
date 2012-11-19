From: "George Spelvin" <linux@horizon.com>
Subject: Re: Issue with bad file system
Date: 19 Nov 2012 01:30:04 -0500
Message-ID: <20121119063004.4845.qmail@science.horizon.com>
Cc: linux@horizon.com, linux-ext4@vger.kernel.org
To: dreusser@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:56783 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752893Ab2KSGaG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2012 01:30:06 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm sorry about your problems, but... a little more information
please?

Mount is very explicitly telling you that there's probably more
information in the kernel logs.  It even gives the command to see it.
WHY DIDN'T YOU INCLUDE IT?  <snark>Was it perhaps too subtle a hint?</snark>

What kernel version are you running?  If it's a distribution kernel,
what kernel?  What architecture?

What does e2fsck say about the file system?
What does dumpe4fs -h /dev/md0 show?


The one odd thing I can see is that md devices *are* usually listed in
/proc/partitions, but it's not showing up in yours.

The output of "cat /proc/mdstat" would also be useful.
