From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH] extend e2fsprogs functionality to add EXT2_FLAG_DIRECT
 option
Date: Tue, 12 Jan 2010 15:01:11 -0500
Message-ID: <4B4CD507.9010301@redhat.com>
References: <4B46FCB2.1090308@redhat.com> <4B4B84E2.1050508@redhat.com> <4B4C54DC.4040006@redhat.com> <4B4C6429.6090803@redhat.com> <4B4C67F5.1020009@redhat.com> <20100112122319.GA20596@infradead.org> <4B4C9244.2050704@redhat.com> <4B4C9940.8060004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-ext4@vger.kernel.org
To: Michal Novotny <minovotn@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab0ALUBA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jan 2010 15:01:00 -0500
In-Reply-To: <4B4C9940.8060004@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Just for completeness, this is what we think we have going on:

1) First boot: Running on the host, pygrub reads the device (unmounted) 
to bootstrap the guest with image A (kernel + grub.conf)

(2) guest image updates the kernel/grub.conf using weird Xen IO path 
(bypassing the host page cache, creating BIO's directly in the host 
memory).

Note that at this point in time, the image from (1) is still possibly in 
the page cache of the host

(3) reboot of guest - host pygrub uses page cache (stale pages) when 
bootstrapping the guest who occasionally boots into the stale image.

This doesn't happen all of the time - if the pages are dropped before 
(3) happens, it won't happen.

Uses O_DIRECT has a side effect of invalidating the page cache while 
reading.

Dropping VM caches just for the devices in question would fix this or 
(as Christoph mentioned) use kvm which does this more sanely :-)

ric

