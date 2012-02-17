From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] e2image: add -a switch to include all data
Date: Fri, 17 Feb 2012 15:39:08 -0500
Message-ID: <20120217203908.GA25812@thunk.org>
References: <1329428112-8911-1-git-send-email-psusi@ubuntu.com>
 <1329428112-8911-2-git-send-email-psusi@ubuntu.com>
 <20120216231745.GC26473@thunk.org>
 <4F3D9CB3.4020704@ubuntu.com>
 <alpine.LFD.2.00.1202171006380.6479@dhcp-27-109.brq.redhat.com>
 <20120217145025.GC19606@thunk.org>
 <alpine.LFD.2.00.1202171630130.5649@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phillip Susi <psusi@ubuntu.com>, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35632 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977Ab2BQUjM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Feb 2012 15:39:12 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1202171630130.5649@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 17, 2012 at 04:35:20PM +0100, Lukas Czerner wrote:
> as I said I have never tested this. Well, actually I did some very
> limited testing, but since this was not (and still is not right?) the
> scope of e2image

I don't think it's within the scope of e2image to be guaranteed way of
converting a general-purpose qcow2 image file from qemu to a raw image
file.  It would be *nice* if this worked, but I don't think that's the
main thrust of e2image's functionality, no.

I'd consider it more within e2fsprogs's scope if e2fsck, dumpe2fs,
debugfs, etc., could operate directly on a qcow2 file (i.e., if the
qcow2 functionality was implemented as an io_manager).  Combined with
Darrick's fuse2fs, or the e2tools package, it would mean that we could
manipulate qcow2 files directly from the host OS.  I think sysadmins
who are using virtualization would find that to be a useful feature.

I just keep hoping that someone will be able to convince their
management that it's useful enough to put in the development effort.  :-)

	   	     	    	      - Ted
