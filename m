From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
Subject: Kernel 3.7.0: bad header/extent
Date: Sat, 15 Dec 2012 18:44:26 -0200
Message-ID: <kainf9$btc$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43719 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab2LOUtv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Dec 2012 15:49:51 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1TjygN-0003ar-OI
	for linux-ext4@vger.kernel.org; Sat, 15 Dec 2012 21:50:03 +0100
Received: from 187.37.53.245 ([187.37.53.245])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 15 Dec 2012 21:50:03 +0100
Received: from fragabr by 187.37.53.245 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 15 Dec 2012 21:50:03 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

	After upgrading from kernel 3.6.0 to 3.7.0 (x86-64) I got this:

Dec 15 18:38:28 tux kernel: EXT4-fs error (device sda2): 
ext4_ext_check_inode:462: inode #9311628: comm less: bad header/extent:
invalid extent entries - magic f30a, entries 1, max 4(4), depth 0(0)

	So I tried to run e2fsck and it "fixed" inode 9311628. Running 
e2fsck again doesn't detect any errors, but the problem remains.

	The file I can't access is /usr/include/dlfcn.h (I was trying to compile openssh).

	Anyway, any hints how can I fix it?

	Thanks.

	Ps: if you need more information, just ask.

-- 
Linux 3.7.0: Terrified Chipmunk
http://www.youtube.com/DanielFragaBR
http://www.libertarios.org.br


