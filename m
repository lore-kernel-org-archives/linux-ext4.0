From: Phillip Susi <psusi@ubuntu.com>
Subject: What is e2initrd_helper?
Date: Wed, 11 Apr 2012 11:46:08 -0400
Message-ID: <4F85A740.9080906@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:28819 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab2DKPqK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Apr 2012 11:46:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I came across this program in e2fsprogs and it doesn't seem to have a 
man page.  What is its purpose?  Looking at the code, it appears to 
extract the fs type listed in the /etc/fstab of the root fs before it is 
mounted, but why?

