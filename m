From: Theodore Tso <tytso@mit.edu>
Subject: Re: bug when we do an mkfs.ext4 + tune2fs
Date: Tue, 20 Jan 2009 09:05:10 -0500
Message-ID: <20090120140510.GC10037@mit.edu>
References: <580e35610901200521x20a9bc85l66ea520151008bc9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: fdbugs <fdbugs@dupoux.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39985 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbZATOFP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Jan 2009 09:05:15 -0500
Content-Disposition: inline
In-Reply-To: <580e35610901200521x20a9bc85l66ea520151008bc9@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 20, 2009 at 01:21:45PM +0000, fdbugs wrote:
> Hi,
> 
> I have an error when I try to mount an ext4 after having changed its
> uuid with tune2fs. If I just do an mkfs.ext4 I can mount it, but if I
> do an mkfs.ext4 and then an e2label -U on it, it can't be mounted.
> Fortunately this bug is quite easy to reproduce.

This is a bug in tune2fs/e2label; it's fixed in the maint branch of
e2fsprogs, and I hope to get a release out soon.  The relevant commit
is:

commit 9d4a4dc2870c46c74f815ec2bebe10b4701accf2
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Nov 14 17:42:27 2008 -0500

    tune2fs: Update the block group checksums when changing the UUID
    
    Since the block group checksums depend on the UUID, we need to update
    the block group checksums when setting the UUID.  We only do so if all
    of the checksums are correct, however.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

You can work around it by using the command "e2fsck -fy" right after
the e2label -U, but that's admittedly quite annoying.  :-/

							- Ted
