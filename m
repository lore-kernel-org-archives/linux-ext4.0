From: Greg KH <greg@kroah.com>
Subject: Re: [stable] Patch Upstream: ext4: Fix s_dirty_blocks_counter if
	block allocation failed with nodelalloc
Date: Wed, 14 Jan 2009 20:16:53 -0800
Message-ID: <20090115041653.GB23164@kroah.com>
References: <200901090125.n091P7CU028977@hera.kernel.org> <20090114234748.GD24230@kroah.com> <20090115013012.GA8914@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: aneesh.kumar@linux.vnet.ibm.com, sct@redhat.com,
	akpm@linux-foundation.org, adilger@sun.com, stable@kernel.org,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:41405 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756951AbZAOESD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Jan 2009 23:18:03 -0500
Content-Disposition: inline
In-Reply-To: <20090115013012.GA8914@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 14, 2009 at 08:30:12PM -0500, Theodore Tso wrote:
> On Wed, Jan 14, 2009 at 03:47:48PM -0800, Greg KH wrote:
> > Hi Ted and others,
> > 
> > I see a bunch of ext4 / jbd2 patches were tagged as requested to go into
> > the -stable tree.  But there seems to not be any simple way to determine
> > what order these patches should go in.
> > 
> > Can someone please list the order of them, or resend all patches that
> > they request to go into the 2.6.28-stable tree (and 2.6.27 if some of
> > the patches apply there as well.)
> 
> I'll put together git branches versus the 2.6.28-stable and
> 2.6.27-stable, hopefully in the next week or so.

Thanks, I'll go drop all ext4 and jbd2 patches from our stable
"to-apply" queue then.

greg k-h
