From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: 2nd Attempt - FSCK Errors
Date: Fri, 3 May 2013 09:14:21 -0400
Message-ID: <20130503131421.GC32297@thunk.org>
References: <007b01ce45ab$0ffc24f0$2ff46ed0$@ntlworld.com>
 <CAFB1F4E-F086-4712-B70D-74F85F3BFDAE@dilger.ca>
 <000f01ce47ec$ca7767c0$5f663740$@ntlworld.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 'Andreas Dilger' <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Stephen Elliott <techweb@ntlworld.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46116 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760356Ab3ECNOZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 May 2013 09:14:25 -0400
Content-Disposition: inline
In-Reply-To: <000f01ce47ec$ca7767c0$5f663740$@ntlworld.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

What you've shown us makes me suspicious about whether the hardware
device is sane or not.  In the previous e2fsck run, it set i_size to a
non-zero value.  Yet when debugfs tries to read the same inode, it's
now seeing all zero's.

So that implies the disk (or software raid device; you haven't been
clear what the underlying storage is for this file system) is not
returning the same information for a particular block as was
previously written.

If the underlying block device is not stable, there really is nothing
for e2fsck to do.  You might want to check /var/log/messages for any
error messages relating to the underlying storage device(s).  If
you're seeing I/O errors in the log files, that would be another hint.

At this point, my recommendation to you is to find a separate disk (or
RAID array if necessary) which is as big as the underlying disk, and
do an image copy (via dd or ddrescue) to a known-good storage device,
and then retry the e2fsck on this copy of the file system.

Regards,

						- Ted

