From: fabian-buettner@gmx.de
Subject: Re: Corrupt superblocks
Date: Mon, 9 Nov 2009 21:18:02 +0100
Message-ID: <200911092118.03036.fabian-buettner@gmx.de>
References: <200911041939.57795.fabian-buettner@gmx.de> <200911042307.40776.fabian-buettner@gmx.de> <4AF1FF04.9040503@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52756 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753967AbZKIUgG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Nov 2009 15:36:06 -0500
In-Reply-To: <4AF1FF04.9040503@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wednesday 04 November 2009 23:24:04 you wrote:
> This tells the initscripts not to try running fsck on /dev/vg/root at
> all (see man fstab)
> 
> > works, while
> > /dev/vg/root            /               ext4            noatime         0
> > 1 doesnt?
> 
> These are probably questions for your distribution; it sounds like the
> initscripts are not able to point e2fsck at the proper device, at the
> proper time...

Thank you for pointing me in the right direction. I had to upgrade to 
baselayout 2 to get it working correctly.

- fabian
