From: Marcel van Beurden <marcel_linux-ext4@marsnix.nl>
Subject: Shrinking ext3 partition takes long and high CPU usage
Date: Fri, 19 Oct 2012 11:34:26 +0200
Message-ID: <50811EA2.6030603@marsnix.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3658 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab2JSJl4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Oct 2012 05:41:56 -0400
Received: from squeeze.netwerk (mrcl.xs4all.nl [83.163.124.123])
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id q9J9YUfM087692
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 19 Oct 2012 11:34:32 +0200 (CEST)
	(envelope-from marcel_linux-ext4@marsnix.nl)
Received: from [188.202.202.42] (helo=[192.168.20.45])
	by squeeze.netwerk with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <marcel_linux-ext4@marsnix.nl>)
	id 1TP8yM-0005fW-Kv
	for linux-ext4@vger.kernel.org; Fri, 19 Oct 2012 11:34:30 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I'm in the process of shrinking a 900 GB ext3 partition on a USB2 
connected disk using Gparted (0.5.1-1ubuntu3). The whole thing has been 
running for 2 days now and I'm curious whether it will ever finish. 
Right now the resize2fs (sub)process is using 99% of one 3.2GHz Xeon 
core (totalling up to 32 hours of CPU time so far).

Is resize2fs being stuck and hanging forever, or is it just taking a lot 
of time? I wouldn't expect resizing to be so CPU intensive.

Is there any way to check whether it is still doing anything and to 
estimate when it will be done?
How corrupt will be filesystem be when I press ctrl-C?

Version of resize2fs is: 1.41.11 (14-Mar-2010)
Version of linux kernel:  2.6.32-40-generic-pae

Regards,
Marcel

