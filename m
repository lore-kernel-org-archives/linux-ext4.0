From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH] e2fsck: Discard free data and inode blocks.
Date: Fri, 22 Oct 2010 12:00:46 -0600
Message-ID: <0694FED8-F35E-4D46-9DF9-E60855E2F2B5@dilger.ca>
References: <1287670556-23460-1-git-send-email-lczerner@redhat.com> <6388FD2D-50A8-42B9-A955-3824451ACBF4@dilger.ca> <alpine.LFD.2.00.1010221059490.3007@dhcp-lab-213.englab.brq.redhat.com> <4CC175E6.5000700@gmail.com> <alpine.LFD.2.00.1010221335080.3390@dhcp-lab-213.englab.brq.redhat.com> <4CC19BC2.9010503@gmail.com> <alpine.LFD.2.00.1010221620490.3390@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ric Wheeler <ricwheeler@gmail.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:38014 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932458Ab0JVSAt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Oct 2010 14:00:49 -0400
In-Reply-To: <alpine.LFD.2.00.1010221620490.3390@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-10-22, at 08:32, Lukas Czerner wrote:
>>> There is a concern that discard might
>>> prevent data recovery after fsck because it might be already discarded
>>> (some weird fs corruption?) in pass 5. However in my opinion this is a
>>> very small window (if there even is any), because we have already passed
>>> check 1-4 and we have just confirmed that group descriptors should be ok.

I don't totally agree.  When users have a serious filesystem problem, the first thing they normally do is run e2fsck to see if it is corrected (it may even be done automatically at boot after errors=panic causing a reboot.

After that, they may want to recover some more data (e.g. with ext3grep, or restore an e2image of the metadata, and re-run e2fsck).  If e2fsck will discard all of the data then any data recovery will be impossible.

>>> On the other hand there is nothing to be afraid of in the case of mkfs,
>>> because we can not possibly lose any relevant data, because discard is
>>> done before the filesystem gets created.

Well, I've worked several times with users that have accidentally repartitioned and/or reformatted over top of their important data, and it is usually possible to recover some data from this.  Again, with discard that would be impossible.

I agree that with mke2fs there is less often a need to do that, and the normal intent of mke2fs is to destroy the previously-existing data, which is why I don't totally object to allowing discard by default for it.  The intent of e2fsck is different however, since it is usually used for recovery purposes.

I'm trying to think of a good heuristic for when discard could be chosen automatically, but have a hard time doing so:

- the current heuristic of "no block bitmap errors" is not strong enough...
- even a completely clean e2fsck is not sufficient, because sometimes/often
  in the case of serious corruption a second e2fsck is run to ensure all
  the problems have been fixed
- after "N" consecutive clean e2fsck runs might be enough, but we don't have
  a counter for that today (but it isn't hard to add, if we are changing the
  e2fsck code anyway).  That said, e2fsck is run so rarely on some systems
  that this would equate to "never" in some cases


Cheers, Andreas





