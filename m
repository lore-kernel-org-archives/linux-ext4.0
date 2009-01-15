From: Theodore Tso <tytso@mit.edu>
Subject: Re: [stable] Patch Upstream: ext4: Fix s_dirty_blocks_counter if
	block allocation failed with nodelalloc
Date: Wed, 14 Jan 2009 20:30:12 -0500
Message-ID: <20090115013012.GA8914@mit.edu>
References: <200901090125.n091P7CU028977@hera.kernel.org> <20090114234748.GD24230@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: aneesh.kumar@linux.vnet.ibm.com, sct@redhat.com,
	akpm@linux-foundation.org, adilger@sun.com, stable@kernel.org,
	linux-ext4@vger.kernel.org
To: Greg KH <greg@kroah.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:40937 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbZAOBah (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Jan 2009 20:30:37 -0500
Content-Disposition: inline
In-Reply-To: <20090114234748.GD24230@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 14, 2009 at 03:47:48PM -0800, Greg KH wrote:
> Hi Ted and others,
> 
> I see a bunch of ext4 / jbd2 patches were tagged as requested to go into
> the -stable tree.  But there seems to not be any simple way to determine
> what order these patches should go in.
> 
> Can someone please list the order of them, or resend all patches that
> they request to go into the 2.6.28-stable tree (and 2.6.27 if some of
> the patches apply there as well.)

I'll put together git branches versus the 2.6.28-stable and
2.6.27-stable, hopefully in the next week or so.

	       		    	     	     - Ted
