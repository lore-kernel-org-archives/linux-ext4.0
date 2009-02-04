From: Jimmy Rentz <jedynamic@bellsouth.net>
Subject: ext4 - error with root drive mount
Date: Tue, 3 Feb 2009 19:15:31 -0500
Message-ID: <20090203191531.0dfe27a1@amd64linuxmsi.rentzhouse.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmailhost05.isp.att.net ([207.115.11.55]:47450 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbZBDAPi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Feb 2009 19:15:38 -0500
Received: from amd64linuxmsi.rentzhouse.lan (amd64linuxmsi.rentzhouse.lan [192.168.0.56])
	(authenticated bits=0)
	by jb17bsome.dyndns.org (8.14.3/8.14.3) with ESMTP id n140FWuq021396
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 3 Feb 2009 19:15:33 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,
	I am unable to mount my ext4 root drive. 

	I get this error:
	EXT4-fs: ext4_check_descriptors: Block bitmap for group 2688
	not in group (block 4205711663)!<3>EXT4-fs: group descriptors
	corrupted!

	I had a similar error some time ago, but I thought it was power
	related.  I fixed the problem by running a fcsk.  
	I have since purchased a ups so I can at least rule that out.
	Also, after I fixed the error I never saw any ata errors or
	kernel oops in dmesg.

	I am running Fedora 10 with kernel
	2.6.27.12-170.2.5.fc10.x86_64.
	Root drive is on a lvm. 
	The physical disk is a 1.5 T.B Seagate (non-affected bad
	firmware drive).

	Any tips to debug this?

Jimmy Rentz
