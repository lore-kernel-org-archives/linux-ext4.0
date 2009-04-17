From: Jeremy Sanders <jss@ast.cam.ac.uk>
Subject: fsck.ext4: Group descriptors look bad... trying backup blocks...
Date: Fri, 17 Apr 2009 12:03:33 +0100
Message-ID: <gs9nm5$8m1$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:38495 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760355AbZDQLFF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Apr 2009 07:05:05 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1LulsU-0006ei-QY
	for linux-ext4@vger.kernel.org; Fri, 17 Apr 2009 11:05:02 +0000
Received: from xpc17.ast.cam.ac.uk ([131.111.69.96])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 17 Apr 2009 11:05:02 +0000
Received: from jss by xpc17.ast.cam.ac.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 17 Apr 2009 11:05:02 +0000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi - I'm trying out ext4 on a large 8.2 TB software raid device (md). On 
rebooting (cleanly unmounting), I tried an fsck on the device. I get the 
following:

[root@xback2 ~]# fsck /dev/md0
fsck 1.41.4 (27-Jan-2009)
e2fsck 1.41.4 (27-Jan-2009)
fsck.ext4: Group descriptors look bad... trying backup blocks...
Group descriptor 0 checksum is invalid.  Fix<y>?

It then finds lots of bad group descriptors.

This is Fedora 10, 2.6.27.21-170.2.56.fc10.x86_64 and 
e2fsprogs-1.41.4-4.fc10.x86_64.

Jeremy

-- 
Jeremy Sanders <jss@ast.cam.ac.uk>   http://www-xray.ast.cam.ac.uk/~jss/
X-Ray Group, Institute of Astronomy, University of Cambridge, UK.
Public Key Server PGP Key ID: E1AAE053


