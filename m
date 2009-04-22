From: Jeremy Sanders <jss@ast.cam.ac.uk>
Subject: Re: fsck.ext4: Group descriptors look bad... trying backup	blocks...
Date: Wed, 22 Apr 2009 10:34:26 +0100
Message-ID: <gsmob2$5vs$1@ger.gmane.org>
References: <49E8B5AD.6030907@redhat.com> <gshfgl$o6m$1@ger.gmane.org> <20090420113534.GR19186@mit.edu> <alpine.LFD.2.00.0904201237500.17316@xpc17.ast.cam.ac.uk> <20090420124810.GT19186@mit.edu> <49EC8B97.6010308@redhat.com> <49EC9A11.1080105@redhat.com> <alpine.LFD.2.00.0904201652540.17316@xpc17.ast.cam.ac.uk> <20090420182800.GC3209@webber.adilger.int> <alpine.LFD.2.00.0904201953260.30497@xpc17.ast.cam.ac.uk> <20090420204534.GF3209@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:40952 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322AbZDVJel (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Apr 2009 05:34:41 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LwYqi-00052g-Ku
	for linux-ext4@vger.kernel.org; Wed, 22 Apr 2009 09:34:36 +0000
Received: from xpc17.ast.cam.ac.uk ([131.111.69.96])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 22 Apr 2009 09:34:36 +0000
Received: from jss by xpc17.ast.cam.ac.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 22 Apr 2009 09:34:36 +0000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:

> File ACL: 0    Directory ACL: 0
> ^^^^^^^^^^^ ##### this would be non-zero #####

These are zero on this device.

Jerey

-- 
Jeremy Sanders <jss@ast.cam.ac.uk>   http://www-xray.ast.cam.ac.uk/~jss/
X-Ray Group, Institute of Astronomy, University of Cambridge, UK.
Public Key Server PGP Key ID: E1AAE053


