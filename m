From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: fsck.ext4: Group descriptors look bad... trying backup blocks...
Date: Fri, 17 Apr 2009 12:10:12 -0500
Message-ID: <49E8B7F4.6020608@redhat.com>
References: <gs9nm5$8m1$1@ger.gmane.org> <20090417115659.GB7117@mit.edu> <gs9rve$rid$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jeremy Sanders <jss@ast.cam.ac.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52718 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762118AbZDQRKR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Apr 2009 13:10:17 -0400
In-Reply-To: <gs9rve$rid$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jeremy Sanders wrote:
> Theodore Tso wrote:

...

>> I see from the dumpe2fs that you sent it had only been in use for a
>> week.  How were you using the filesystem?  Did you try using the
>> online resize feature at any time?
> 
> No. The filesystem was used to store rsync snapshots of other file systems 
> (using the hard link feature). I had only rsynced the initial data and run a 
> couple of rsync backups on to it. The filesystem was created using:
> 
> mkfs.ext4 -m0 -b 4096 -E stride=8,stripe-width=72  /dev/md0

Can you show us exactly how you're using rsync?  is this with
rdiff-backup or some similar tool?

Thanks,
-Eric
