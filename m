From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: fsck.ext4: Group descriptors look bad... trying backup blocks...
Date: Fri, 17 Apr 2009 12:00:29 -0500
Message-ID: <49E8B5AD.6030907@redhat.com>
References: <gs9nm5$8m1$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jeremy Sanders <jss@ast.cam.ac.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:40453 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbZDQRAq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Apr 2009 13:00:46 -0400
In-Reply-To: <gs9nm5$8m1$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jeremy Sanders wrote:
> Hi - I'm trying out ext4 on a large 8.2 TB software raid device (md). On 
> rebooting (cleanly unmounting), I tried an fsck on the device. I get the 
> following:
> 
> [root@xback2 ~]# fsck /dev/md0
> fsck 1.41.4 (27-Jan-2009)
> e2fsck 1.41.4 (27-Jan-2009)
> fsck.ext4: Group descriptors look bad... trying backup blocks...
> Group descriptor 0 checksum is invalid.  Fix<y>?
> 
> It then finds lots of bad group descriptors.
> 
> This is Fedora 10, 2.6.27.21-170.2.56.fc10.x86_64 and 
> e2fsprogs-1.41.4-4.fc10.x86_64.
> 

Jeremy, if you're willing, could you upgrade to the 2.6.29 kernel that's
in F10 updates-testing?  That way the ext4 code is a bit more of a
recent, common codebase.  Also, if this is a test fs, re-mkfs'ing from
scratch might not be a bad way to go.

Depending on how hard it is to reproduce, it may also be interesting to
try a filesystem just shy of 8TB (2^31) blocks in case there is some
32-bit wrap-around there, since you're at 8.2T....

-Eric
