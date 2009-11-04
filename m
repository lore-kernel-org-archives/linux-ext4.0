From: fabian-buettner@gmx.de
Subject: Re: Corrupt superblocks
Date: Wed, 4 Nov 2009 22:56:49 +0100
Message-ID: <200911042256.50250.fabian-buettner@gmx.de>
References: <200911041939.57795.fabian-buettner@gmx.de> <4AF1D42A.6000304@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38171 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932998AbZKDV4q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Nov 2009 16:56:46 -0500
In-Reply-To: <4AF1D42A.6000304@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Why do you say you have a corrupted superblock?

Because of this message: fsck.ext4: No such file or directory while trying to 
open /dev/vg/root
/dev/vg/root: The superblock could not be read or does not describe a correct 
ext2 filesystem ... at the end of this message i am told to run e2fsck -b 
8193 <device>

> I suppose I'd try booting a live/rescue cd, and just manually run e2fsck
> against your root device, as a starter - and capture any interesting
>  output.
> 
> Any sort of kernel or fsck logs indicating more of what actually went
> wrong would be Very helpful here.

I just booted into a rescue cd and run e2fsck /dev/vg/root.
surprisingly it said: /dev/vg/root: clean

- fabian
