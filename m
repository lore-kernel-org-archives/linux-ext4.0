From: Jan Engelhardt <jengelh@medozas.de>
Subject: ext4: odd values for mkfs.ext4 -i
Date: Wed, 4 Mar 2009 00:07:17 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903040001120.12969@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36053 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbZCCXHU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Mar 2009 18:07:20 -0500
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id 3955E40036D6
	for <linux-ext4@vger.kernel.org>; Wed,  4 Mar 2009 00:07:17 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,



Is it ok that e2fsprogs-1.41.4 allows odd values for -i, such as
in `mkfs.ext4 -i 2047`? If inodes were arranged every 2047 bytes, they 
would not be aligned, which would mean one extra sector would have to be 
read every now and then, does not it?
Should odd values be rejected?

[BTW: this mailing list address should be mentioned at 
e2fsprogs.sf.net]


Jan
