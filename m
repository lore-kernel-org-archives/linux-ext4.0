From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: Feature request: e2fsck -z
Date: Wed, 10 Aug 2011 13:09:47 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1108101307590.4380@dhcp-27-109.brq.redhat.com>
References: <4E4173D4.9010104@zytor.com> <4E422686.8080207@gmail.com> <4420E0D8-5E16-4FD0-A7A9-B462F02D742D@dilger.ca> <4E423FD0.40108@gmail.com> <alpine.LFD.2.00.1108101134580.4380@dhcp-27-109.brq.redhat.com> <82k4ala62o.fsf@mid.bfk.de>
 <alpine.LFD.2.00.1108101259330.4380@dhcp-27-109.brq.redhat.com> <82fwl9a5o5.fsf@mid.bfk.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>,
	Ric Wheeler <ricwheeler@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-ext4@vger.kernel.org
To: Florian Weimer <fweimer@bfk.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796Ab1HJLJy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Aug 2011 07:09:54 -0400
In-Reply-To: <82fwl9a5o5.fsf@mid.bfk.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 10 Aug 2011, Florian Weimer wrote:

> * Lukas Czerner:
> 
> > On Wed, 10 Aug 2011, Florian Weimer wrote:
> >
> >> * Lukas Czerner:
> >> 
> >> > You're right. It is a part of e2fsck and you can enable it with -E
> >> > discard.
> >> 
> >> If the block device does not support TRIM, does this result in zeros
> >> being written instead?
> 
> > Of course not, discard works only on devices which does support it. If
> > the device does not support discard it will to nothing.
> 
> Oh, then it doesn't address hpa's use case (improving compression).
> 

It does if he will use SSD's with "discard_zeroes_data" capability. But
my original answer was to simply confirm that e2fsck has that feature.

Thanks!
-Lukas
