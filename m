From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: XFS Add Punch Hole Testing to FSX
Date: Mon, 02 May 2011 12:16:12 -0700
Message-ID: <4DBF02FC.9080608@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53900 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab1EBTQg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 May 2011 15:16:36 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This is the fsx test I have been using to develop punch hole for ext4. 
There have been some requests to see it, so I will send it to both 
linux-fsdevl and the ext4 mailing list.

Ext4 punch hole is done through fallocate, so the patch adds the punch 
hole flag to fallocate test.  Initially I had trouble enabling the 
existing fallocate tests until I made a fix to the Makefile.  It looks 
like it should be checking for HAVE_FALLOCATE equal to "yes" instead of 
"true"?  Im not sure if that was a bug or if there was something else I 
was supposed to do to configure it correctly, so feed back is 
appreciated :)  Thanks all!

Allison Henderson
