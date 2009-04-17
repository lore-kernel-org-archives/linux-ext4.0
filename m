From: Jeremy Sanders <jss@ast.cam.ac.uk>
Subject: Re: fsck.ext4: Group descriptors look bad... trying backup blocks...
Date: Fri, 17 Apr 2009 13:24:16 +0100
Message-ID: <gs9sdh$u9k$1@ger.gmane.org>
References: <gs9nm5$8m1$1@ger.gmane.org> <20090417115659.GB7117@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:60270 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756147AbZDQMYg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Apr 2009 08:24:36 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Lun7O-0001dq-I3
	for linux-ext4@vger.kernel.org; Fri, 17 Apr 2009 12:24:30 +0000
Received: from xpc17.ast.cam.ac.uk ([131.111.69.96])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 17 Apr 2009 12:24:30 +0000
Received: from jss by xpc17.ast.cam.ac.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 17 Apr 2009 12:24:30 +0000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:

> I see from the dumpe2fs that you sent it had only been in use for a
> week.  How were you using the filesystem?  Did you try using the
> online resize feature at any time?

I assume that this isn't enough to corrupt the filesystem?

[root@xback2 ~]# tune2fs -i -1 /dev/md0
tune2fs 1.41.4 (27-Jan-2009)
Setting interval between checks to 18446744073709465216 seconds

Jeremy

-- 
Jeremy Sanders <jss@ast.cam.ac.uk>   http://www-xray.ast.cam.ac.uk/~jss/
X-Ray Group, Institute of Astronomy, University of Cambridge, UK.
Public Key Server PGP Key ID: E1AAE053


