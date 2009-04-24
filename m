From: Jeremy Sanders <jss@ast.cam.ac.uk>
Subject: Re: fsck.ext4: Group descriptors look bad... trying backup blocks...
Date: Fri, 24 Apr 2009 09:27:39 +0100
Message-ID: <gsrvqq$6kk$1@ger.gmane.org>
References: <gs9nm5$8m1$1@ger.gmane.org> <49E8B5AD.6030907@redhat.com> <gshfgl$o6m$1@ger.gmane.org> <20090420113534.GR19186@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7Bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:56893 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502AbZDXJNQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Apr 2009 05:13:16 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LxHT5-0001VK-Ej
	for linux-ext4@vger.kernel.org; Fri, 24 Apr 2009 09:13:11 +0000
Received: from xpc17.ast.cam.ac.uk ([131.111.69.96])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 24 Apr 2009 09:13:11 +0000
Received: from jss by xpc17.ast.cam.ac.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 24 Apr 2009 09:13:11 +0000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:

> Do you have to reboot to see this, or is it enough to unmount the
> filesystem?  How big is the ext4 filesystem, and how big was the
> amount of data that you rsync'ed?  One thing that would be worth
> trying if you can easily reproduce is whether it happens on a single
> device disk, or whether it only shows up when you use a /dev/mdX
> device.

I've been able to reproduce it on a single device disk (It was partitioned 
to have the same number of blocks as the md device).

Jeremy

-- 
Jeremy Sanders <jss@ast.cam.ac.uk>   http://www-xray.ast.cam.ac.uk/~jss/
X-Ray Group, Institute of Astronomy, University of Cambridge, UK.
Public Key Server PGP Key ID: E1AAE053


