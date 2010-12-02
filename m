From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PARCH 0/1 RFC] e2image: Add support for QCOW2 image format
Date: Thu, 2 Dec 2010 09:24:50 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1012020923250.2874@dhcp-lab-213.englab.brq.redhat.com>
References: <1291225309-10750-1-git-send-email-lczerner@redhat.com> <3D193EF5-5995-4674-881B-DF74B855CE32@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
	sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464Ab0LBIYz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Dec 2010 03:24:55 -0500
In-Reply-To: <3D193EF5-5995-4674-881B-DF74B855CE32@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 1 Dec 2010, Andreas Dilger wrote:

> On 2010-12-01, at 10:41, Lukas Czerner wrote:
> > I am presenting you an initial parch, which works for me quite nicely, however so far it did received just limited testing. Nevertheless you
> > can try it simply by invoking e2image with '-q' parameter like this:
> > 
> > 	e2image -q /dev/sda1 myimage
> 
> Probably "-q" isn't the best name, since that normally means "quiet".  Maybe "-Q"?
> 
> Cheers, Andreas
> 

Fair enough, I can change it to "-Q".

Thanks!

-Lukas
