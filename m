From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 0/5][64-BIT] Miscellaneous e2fsprogs 64-bit patches -
	description
Date: Wed, 15 Apr 2009 20:31:46 -0400
Message-ID: <20090416003146.GH21586@mit.edu>
References: <11629.1239227147@alphaville.usa.hp.com> <20090415195014.GB1668@shell> <49E63BDF.5020506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Valerie Aurora Henson <vaurora@redhat.com>,
	Nick Dokos <nicholas.dokos@hp.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52739 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbZDPAbv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Apr 2009 20:31:51 -0400
Content-Disposition: inline
In-Reply-To: <49E63BDF.5020506@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 15, 2009 at 02:56:15PM -0500, Eric Sandeen wrote:
> Valerie Aurora Henson wrote:
> >> Or I can forego the compression and try to save to a file: it's sparse
> >> (I only used 7GiB before it failed), but its nominal size exceeded the
> >> maximum file size limit on ext4, at which point I start getting lseek
> >> failures.
> 
> We really need some e2image format which encodes the sparseness, I think...

On my two do list for when I have copies amounts of free time is to
take the qemu image format code, and retrofit it into the I/O manager
code, and then teach e2image to use it, and then teach e2fsck,
debugfs, dumpe2fs, to be able to specify that arbitrary I/O managers
by name.  That would allow dumpe2fs, debugfs, e2fsck, etc., to operate
on an qemu-img file, where e2image would have a new option to create a
meta-data only qemu-img format file.

Now, if I only had a minion at hand to carry out my evil plans.   :-)

     	       	     	       	       	     - Ted
