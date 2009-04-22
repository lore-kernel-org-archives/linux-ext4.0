From: Jeremy Sanders <jss@ast.cam.ac.uk>
Subject: Re: fsck.ext4: Group descriptors look bad... trying backup	blocks...
Date: Wed, 22 Apr 2009 10:07:50 +0100
Message-ID: <gsmmp6$ek$1@ger.gmane.org>
References: <gs9nm5$8m1$1@ger.gmane.org> <49E8B5AD.6030907@redhat.com> <gshfgl$o6m$1@ger.gmane.org> <20090420113534.GR19186@mit.edu> <alpine.LFD.2.00.0904201237500.17316@xpc17.ast.cam.ac.uk> <20090420124810.GT19186@mit.edu> <49EC8B97.6010308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:53211 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbZDVJII (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Apr 2009 05:08:08 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LwYR1-0003u2-8X
	for linux-ext4@vger.kernel.org; Wed, 22 Apr 2009 09:08:03 +0000
Received: from xpc17.ast.cam.ac.uk ([131.111.69.96])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 22 Apr 2009 09:08:03 +0000
Received: from jss by xpc17.ast.cam.ac.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 22 Apr 2009 09:08:03 +0000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:

> I think trying a filesystem with just under 8T would be a useful test too.

Okay, I tried partitioning the md device so that it was under 8T (7.1T in 
fact). Unfortunately I wasn't able to reproduce it in this configuration.

So, either it is a 8T+ problem, which disagrees with the other report, or 
the geometry has some sort of impact, or it is because the files I'm copying 
keep changing, so it may have gone away, or it is not 100% reproducible.

Shall I wait to see if you have a useful testcase from Thierry Vignaud 
before trying something else?

Jeremy

-- 
Jeremy Sanders <jss@ast.cam.ac.uk>   http://www-xray.ast.cam.ac.uk/~jss/
X-Ray Group, Institute of Astronomy, University of Cambridge, UK.
Public Key Server PGP Key ID: E1AAE053


