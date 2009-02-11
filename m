From: Raimund Andersen <anderse@gmx.de>
Subject: Re: Filesystem still has errors
Date: Wed, 11 Feb 2009 22:34:45 +0000 (UTC)
Message-ID: <loom.20090211T222920-494@post.gmane.org>
References: <loom.20090211T220951-175@post.gmane.org> <49934EC8.7040800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:45234 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961AbZBKWex (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Feb 2009 17:34:53 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LXNfR-0003yI-BN
	for linux-ext4@vger.kernel.org; Wed, 11 Feb 2009 22:34:53 +0000
Received: from 77-20-221-137-dynip.superkabel.de ([77.20.221.137])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 11 Feb 2009 22:34:53 +0000
Received: from anderse by 77-20-221-137-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 11 Feb 2009 22:34:53 +0000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen <sandeen <at> redhat.com> writes:

> 
> You should expect that checking a live filesystem will produce errors,
> actually.  So don't worry about that.  The filesystem is not quiesced,
> and it's not consistent.  That is to be expected, and it's why you see
> the different behavior w/ forcefsck vs. e2fsck -n on the live fs.
> 
> As for the spurious ENOSPC, I'm not certain.  Do you still get the error?

Thanks for your quick reply. No, at the moment, I don't get it. Yesterday, it
occured once and a reboot let it vanish, and I got it some days before. Also
then, a reboot let it disappear. So could it be of help if I collect any
information in the case it might reappear? What exactly should I do then?

Thank you, once again.

rgds Raimund

