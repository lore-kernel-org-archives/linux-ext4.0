From: Anton Andreev <fn30762@fmi.uni-sofia.bg>
Subject: 64 bit support for ext4 problem
Date: Tue, 31 Jul 2007 10:34:51 +0300
Message-ID: <46AEE61B.5000207@fmi.uni-sofia.bg>
Reply-To: anton.andreev@fmi.uni-sofia.bg
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.fmi.uni-sofia.bg ([62.44.101.3]:1069 "EHLO
	smtp.fmi.uni-sofia.bg" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbXGaIGB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2007 04:06:01 -0400
Received: from [127.0.0.1] ([62.44.101.106])
	by smtp.fmi.uni-sofia.bg (Kerio MailServer 6.4.1)
	for linux-ext4@vger.kernel.org;
	Tue, 31 Jul 2007 10:34:37 +0300
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

I want to try my ext4 to be 64 bit.

I could not patch e2fsprogs-1.39 
<http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.39.tar.gz> 
with 
http://www.bullopensource.org/ext4/patches/ext4-e2fsprogs-1.39.patch.tar 
. I would appreciate if someone tell me exactly how to do that.

Does the newest version of e2fsprogs 
<http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.39.tar.gz> 
supports the features in the patch?

Thanks!

Anton
