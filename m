From: Jeremy Sanders <jss@ast.cam.ac.uk>
Subject: Re: fsck.ext4: Group descriptors look bad... trying backup blocks...
Date: Mon, 20 Apr 2009 10:33:09 +0100
Message-ID: <gshfgl$o6m$1@ger.gmane.org>
References: <gs9nm5$8m1$1@ger.gmane.org> <49E8B5AD.6030907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:52533 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbZDTJdX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2009 05:33:23 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LvpsP-0002B5-VS
	for linux-ext4@vger.kernel.org; Mon, 20 Apr 2009 09:33:22 +0000
Received: from xpc17.ast.cam.ac.uk ([131.111.69.96])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 20 Apr 2009 09:33:21 +0000
Received: from jss by xpc17.ast.cam.ac.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 20 Apr 2009 09:33:21 +0000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:

> Jeremy, if you're willing, could you upgrade to the 2.6.29 kernel that's
> in F10 updates-testing?  That way the ext4 code is a bit more of a
> recent, common codebase.  Also, if this is a test fs, re-mkfs'ing from
> scratch might not be a bad way to go.
> 
> Depending on how hard it is to reproduce, it may also be interesting to
> try a filesystem just shy of 8TB (2^31) blocks in case there is some
> 32-bit wrap-around there, since you're at 8.2T....

I wasn't able to trivially reproduce the problem with the old kernel, but I 
updated to 2.6.29.1-30.fc10.x86_64 in updates testing. This introduced some 
further problems with a USB issue and some sort of stack dump probably 
associated with the r8169 driver (see bugzilla).

However, the system seems to mostly work, so I recreated the ext4 device, 
I've just run my backup script again and fsck'd the device. It seems the 
problem is reproducible with the new kernel:

[root@xback2 ~]# fsck /dev/md0
fsck 1.41.4 (27-Jan-2009)
e2fsck 1.41.4 (27-Jan-2009)
fsck.ext4: Group descriptors look bad... trying backup blocks...
Group descriptor 0 checksum is invalid.  Fix<y>?

Looks like there's a real problem in ext4 causing this under certain 
circumstances (unless an obscure hardware error is somehow giving the same 
problem).

To cause this, all I did was rsync a set of directories to the disk. No hard 
link trees were created.

Jeremy

-- 
Jeremy Sanders <jss@ast.cam.ac.uk>   http://www-xray.ast.cam.ac.uk/~jss/
X-Ray Group, Institute of Astronomy, University of Cambridge, UK.
Public Key Server PGP Key ID: E1AAE053


