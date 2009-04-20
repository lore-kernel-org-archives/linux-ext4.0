From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: fsck.ext4: Group descriptors look bad... trying backup blocks...
Date: Mon, 20 Apr 2009 11:26:00 -0500
Message-ID: <49ECA218.4080106@redhat.com>
References: <gs9nm5$8m1$1@ger.gmane.org> <49E8B5AD.6030907@redhat.com> <gshfgl$o6m$1@ger.gmane.org> <20090420113534.GR19186@mit.edu> <alpine.LFD.2.00.0904201237500.17316@xpc17.ast.cam.ac.uk> <20090420124810.GT19186@mit.edu> <49EC8B97.6010308@redhat.com> <49EC9A11.1080105@redhat.com> <alpine.LFD.2.00.0904201652540.17316@xpc17.ast.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jeremy Sanders <jss@ast.cam.ac.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:40203 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbZDTQ0M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2009 12:26:12 -0400
In-Reply-To: <alpine.LFD.2.00.0904201652540.17316@xpc17.ast.cam.ac.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jeremy Sanders wrote:
> On Mon, 20 Apr 2009, Eric Sandeen wrote:
...

>> One other question - do you make use of xattrs on this filesystem?
> 
> No.

I've commandeered about 10T of disk space to see if I can hit this.
Would you mind providing dumpe2fs -h output for your 8.2T filesystem so
I can exactly replicate the geometry?

Thanks,
-Eric
