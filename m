From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] e2fsck: don't try to set a UUID on metadata_csum
 file systems
Date: Sat, 16 Apr 2016 11:45:38 -0400
Message-ID: <20160416154538.GC5447@thunk.org>
References: <1460769225-31398-1-git-send-email-tytso@mit.edu>
 <1460769225-31398-3-git-send-email-tytso@mit.edu>
 <062EB0E7-1B5E-4DF0-B4B2-F87A7566A81F@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35806 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbcDPPpm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Apr 2016 11:45:42 -0400
Content-Disposition: inline
In-Reply-To: <062EB0E7-1B5E-4DF0-B4B2-F87A7566A81F@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 15, 2016 at 09:06:04PM -0600, Andreas Dilger wrote:
> > If the UUID field is NULL, e2fsck will try to generate and set a new
> > UUID.  This will cause massive problems if the metadata_csum feature
> > is set, so avoid doing so in that case.
> 
> Should enabling the metadata csum feature complain/fail if the checksum
> is unset?  It doesn't make sense to use a NULL UUID as the checksum salt.

Well, for hard disks, it's certainly not a great idea, although it
won't automatically break things.  For images that are being cloned
for VM's, the UUID's are all going to be the same anyway, so whether
they are all NULL or all "964ef7ca-ddce-4ce2-906e-d2d69be29b1f"
doesn't really matter a whole lot.  And the same holds true if someone
recreates a file system on a HDD with an explicitly specified UUID
which is the same as what had previously been used on that file
system.

The real problem was the mistake we made in overloading the UUID is
the checksum seed.  We've fixed that, but it's going to be quite a
while before we can assume that it is generally available.

I could see adding a warning message to mke2fs if the user specifies a
UUID (whether it be NULL or any other value) but I'm not really sure
it's worth it.

Cheers,

						- Ted
						
