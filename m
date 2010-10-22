From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsck: Discard free data and inode blocks.
Date: Fri, 22 Oct 2010 13:27:19 -0500
Message-ID: <4CC1D787.5000707@redhat.com>
References: <1287670556-23460-1-git-send-email-lczerner@redhat.com> <6388FD2D-50A8-42B9-A955-3824451ACBF4@dilger.ca> <alpine.LFD.2.00.1010221059490.3007@dhcp-lab-213.englab.brq.redhat.com> <4CC175E6.5000700@gmail.com> <alpine.LFD.2.00.1010221335080.3390@dhcp-lab-213.englab.brq.redhat.com> <4CC19BC2.9010503@gmail.com> <alpine.LFD.2.00.1010221620490.3390@dhcp-lab-213.englab.brq.redhat.com> <0694FED8-F35E-4D46-9DF9-E60855E2F2B5@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>,
	Ric Wheeler <ricwheeler@gmail.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942Ab0JVS10 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Oct 2010 14:27:26 -0400
In-Reply-To: <0694FED8-F35E-4D46-9DF9-E60855E2F2B5@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On 2010-10-22, at 08:32, Lukas Czerner wrote:
>>>> There is a concern that discard might prevent data recovery
>>>> after fsck because it might be already discarded (some weird fs
>>>> corruption?) in pass 5. However in my opinion this is a very
>>>> small window (if there even is any), because we have already
>>>> passed check 1-4 and we have just confirmed that group
>>>> descriptors should be ok.
> 
> I don't totally agree.  When users have a serious filesystem problem,
> the first thing they normally do is run e2fsck to see if it is
> corrected (it may even be done automatically at boot after
> errors=panic causing a reboot.
> 
> After that, they may want to recover some more data (e.g. with
> ext3grep, or restore an e2image of the metadata, and re-run e2fsck).
> If e2fsck will discard all of the data then any data recovery will be
> impossible.

Could set it to only issue discard when the check was clean....

It could still be an option of course, but that might be safer still.

-Eric
