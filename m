From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Corrupt superblocks
Date: Wed, 04 Nov 2009 16:24:04 -0600
Message-ID: <4AF1FF04.9040503@redhat.com>
References: <200911041939.57795.fabian-buettner@gmx.de> <200911042256.50250.fabian-buettner@gmx.de> <4AF1F94B.5020108@redhat.com> <200911042307.40776.fabian-buettner@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: fabian-buettner@gmx.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932910AbZKDWYF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Nov 2009 17:24:05 -0500
In-Reply-To: <200911042307.40776.fabian-buettner@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

fabian-buettner@gmx.de wrote:

> So maybe i did harm my fs by running e2fsck -b?

If /dev/vg/root didn't exist, no filesystem was harmed in the process I
am sure.  :)

> Because running fsck afterwards gave me a lot of those Group descriptor 
> checksum fixing proposals?
> I am surprised that e2fsck just told me that my fs is clean.
> 
> Do you have a clue why an entry in my /etc/fsab like
> /dev/vg/root            /               ext4            noatime         0 0

This tells the initscripts not to try running fsck on /dev/vg/root at
all (see man fstab)

> works, while
> /dev/vg/root            /               ext4            noatime         0 1
> doesnt?

These are probably questions for your distribution; it sounds like the
initscripts are not able to point e2fsck at the proper device, at the
proper time...

-Eric

> - fabian

