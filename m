From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: unexpected sync delays in dpkg for small pre-allocated files on
 ext4
Date: Tue, 24 May 2016 19:13:28 -0400
Message-ID: <20160524231328.GB387@thunk.org>
References: <57448A5D.4050805@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Gernot Hillier <gernot.hillier@siemens.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58668 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbcEZAow (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 May 2016 20:44:52 -0400
Content-Disposition: inline
In-Reply-To: <57448A5D.4050805@siemens.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 24, 2016 at 07:07:41PM +0200, Gernot Hillier wrote:
> 
> To me, the problem looks comparable to
> https://bugzilla.kernel.org/show_bug.cgi?id=56821 (even if we don't see
> a full hang and there's no RAID involved for us), so a closer look on
> the SCSI layer or driver might be the next step?

What I would suggest is to create a small test case which compares the
time it takes to allocate 1 megabyte of memory, zero it, and then
write one megabytes of zeros using the write(2) system call.  Then try
writing one megabytes of zero using the BLKZEROOUT ioctl.

I'm pretty sure you'll see same issue with BLKZEROOUT ioctl, but at
this point, we'll be able to send bug reports to the SCSI and block
layer developers with something that makes this very clear that it has
nothing to do with ext4.

This way we can also do some differential diagnosis; given that I'm
not seeing this complaint from most people, I suspect it will be a
matter of adding some specific devices to a blacklist (so that even
though the SCSI device claims to support WRITE SAME, we need to
disable it because it has a really lousy implementation of the SCSI
WRITE SAME command).

Cheers,

					- Ted


