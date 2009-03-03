From: Jan Engelhardt <jengelh@medozas.de>
Subject: mkfs.ext4: high default -i value undocumented
Date: Wed, 4 Mar 2009 00:12:50 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903040007470.12969@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kzak@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43486 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbZCCXMx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Mar 2009 18:12:53 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,


Creating an ext4 filesystem on a 4 GB image file (to be loop-mounted 
later) gives me 256K inodes. Choosing -i 4096 instead gives 1M, which 
would mean the default for -i is 16384. Besides me finding 16384 a 
little unreasonable (XFS offers 2M inodes by default), the big 
point is that the mke2fs manpage (belonging to util-linux, hence Cc) 
does not mention this 16384 default.
Hope this can be addressed.

# rpm -q e2fsprogs util-linux
e2fsprogs-1.41.4-2.2
util-linux-2.14.2-2.2

Jan
