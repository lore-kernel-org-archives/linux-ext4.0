From: Asdo <asdo@shiftmail.org>
Subject: Filesystem freeze vs blockdevice snapshot
Date: Fri, 13 Jan 2012 16:30:53 +0100
Message-ID: <4F104E2D.3080105@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: Asdo <asdo@shiftmail.org>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blade3.isti.cnr.it ([194.119.192.19]:3305 "EHLO
	blade3.isti.cnr.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab2AMUAM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jan 2012 15:00:12 -0500
Received: from [192.168.1.112] ([155.253.6.254])
 by mx.isti.cnr.it (PMDF V6.6 #31988)
 with ESMTPSA id <01OAQUA5UHXQGH34JO@mx.isti.cnr.it> for
 linux-ext4@vger.kernel.org; Fri, 13 Jan 2012 16:30:37 +0100 (MET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello all,
please excuse the silly question...

What is the benefit of performing an ext4 fs freeze before taking a 
snapshot of the underlying block device with LVM2 ?

Is the freeze step useful or I can go with the snapshot directly?

And/or is there another use case for the freeze?

Thank you
