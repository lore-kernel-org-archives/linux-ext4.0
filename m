From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] extend e2fsprogs functionality to add EXT2_FLAG_DIRECT
	option
Date: Tue, 12 Jan 2010 07:46:00 -0500
Message-ID: <20100112124600.GA7151@infradead.org>
References: <4B46FCB2.1090308@redhat.com> <4B4B84E2.1050508@redhat.com> <4B4C54DC.4040006@redhat.com> <4B4C6429.6090803@redhat.com> <4B4C67F5.1020009@redhat.com> <20100112122319.GA20596@infradead.org> <4B4C6B70.1050205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org
To: Michal Novotny <minovotn@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39984 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab0ALMqB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jan 2010 07:46:01 -0500
Content-Disposition: inline
In-Reply-To: <4B4C6B70.1050205@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 12, 2010 at 01:30:40PM +0100, Michal Novotny wrote:
> Not really, pygrub doesn't do any manipulation with file system and  
> also, it's not working on a life file system. It's called before the  
> guest boots up to read information about grub.conf/initrd and kernel for  
> PV guest and after this is read and selected in pygrub then the guest is  
> booted using the kernel and initrd extracted from the image (after which  
> the file is closed). Once again, nothing uses write support and it was  
> added just to make it use O_DIRECT for both read and write operations  
> but only pygrub uses only read support and O_DIRECT passed here is the  
> only way to make it use non-cached data.

So what caches get in the way?  From the above it seems the situation
is the following:

 - filesystem N is a guest filesystem.  It's not usually mounted on the
   host, except for initial setup long time ago
 - before booting a guest your "pygrub" tools needs to read files on
   it, and it's doing so using e2fsprogs
 - once the guest is life it uses the extN kernel driver to access the
   filesystem

nowhere in this cycle you should have any stale cached data.  The kernel
always makes sure to write back data on umount/reboot, as does e2fsprogs
if actually used to write data (which you said is not the case anyway).

The only data that may be in the cache are unmodified data from reads
on the block device from either e2fsprogs or a suboptimal virtual block
device implementation, but these can't cause any problems.
