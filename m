From: Theodore Tso <tytso@mit.edu>
Subject: Re: Patch to support LUKS UUIDs in libblkid
Date: Mon, 23 Jul 2007 12:19:17 -0400
Message-ID: <20070723161917.GA30165@thunk.org>
References: <4665479E.2060707@redhat.com> <20070608153600.GA9726@thunk.org> <466D373C.6000502@redhat.com> <20070612234004.GA12189@thunk.org> <466FCE52.4000605@redhat.com> <20070621175618.GA22285@thunk.org> <46964694.7000707@redhat.com> <46A4C272.3040907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Karsten Hopp <karsten@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37258 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759996AbXGWQTV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jul 2007 12:19:21 -0400
Content-Disposition: inline
In-Reply-To: <46A4C272.3040907@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 23, 2007 at 05:00:02PM +0200, Karsten Hopp wrote:
>
>  I've encountered a problem with this patch, consider the following
>  setup:
> 
>  in /etc/fstab:
>  UUID=<some LUKS uuid>  / ext3 defaults 0 0

Well, the problem is that what you should be putting in /etc/fstab is:

UUID=<uuid of the ext3 filesystem>  / ext3 defaults 0 0

If you put "UUID=<some LUKS uuid>", then of course you will get the
underlying device; that's what you asked for --- what device has the
UUID set to <some LUKS uuid> --- and the computer gave you what you
asked for, which is what not what you wanted.  :-)

If you put the UUID of the ext3 filesystem, then the blkid library
will search through the /dev/mapper devices and find the correct
/dev/mapper device for the underlying filesystem, which is as it should be.

This of course assumes that someone has correctly activated the LUKS
filesystem (and presumably passed LUKS the correct crypto information)
so that it appears as one of the /dev/mapper filesystems.  If that is
why you put the UUID of LUKS partition in /etc/fstab, then we have a
fundamental conflict of what /etc/fstab is for.  /etc/fstab's job is
to identify the actual devices for mounting a filesystem. 

   	    	       	       	   	      - Ted
