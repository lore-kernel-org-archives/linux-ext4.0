From: David Sterba <dsterba@suse.cz>
Subject: Re: [Ocfs2-devel] [PATCH 2/4 v3] fiemap: add EXTENT_DATA_COMPRESSED
 flag
Date: Mon, 28 Jul 2014 18:49:09 +0200
Message-ID: <20140728164909.GK1553@twin.jikos.cz>
References: <cover.1386778302.git.dsterba@suse.cz>
 <4f8d5dc5b51a43efaf16c39398c23a6276e40a30.1386778303.git.dsterba@suse.cz>
 <20131212232443.GL31386@dastard>
 <9520AB36-B728-423A-8EA1-FDD22B79AE90@dilger.ca>
 <B58DEEA8-561A-4173-B9F5-528B73E06C6D@dilger.ca>
 <20140724192245.GG1553@suse.cz>
 <5B4825C3-F47E-48B7-8DA4-6D79F53B73B1@dilger.ca>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dsterba@suse.cz, linux-nilfs@vger.kernel.org, xfs@oss.sgi.com,
	Btrfs Developer List <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57368 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbaG1QtM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jul 2014 12:49:12 -0400
Content-Disposition: inline
In-Reply-To: <5B4825C3-F47E-48B7-8DA4-6D79F53B73B1@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks for the feedback.

On Thu, Jul 24, 2014 at 04:34:35PM -0600, Andreas Dilger wrote:
> >> - rename fe_length to fe_logi_length and #define fe_length fe_logi_length
> >> - always fill in fe_phys_length (= fe_logi_length for uncompressed files)
> >>  and set FIEMAP_EXTENT_PHYS_LENGTH whether the extent is compressed or not
> > 
> > This is my understanding and contradicts the first point.
> 
> I think Dave Chinner's former point was that having fe_phys_length validity
> depend on FIEMAP_EXTENT_DATA_COMPRESSED is a non-intuitive interface.  It is
> not true that fe_phys_length would always be valid, since that is not the
> case for older kernels that currently always set this field to 0, so they
> need some flag to indicate if fe_phys_length is valid.

I see the backward compatibility issue now. The patches (up to v4)
updated all filesystems to fill the physical length with logical,
but this should be 0 to keep the backward compatibility and also to keep
the changes to existing fiemap users minimal.

So for v5, PHYS_LENGTH will be introduced but only used by btrfs
together with ENCODED and COMPRESSED. Though this may look too much for
my needs to represent compressed extent, it is flexible for future use.

> Alternately,
> userspace could do:
> 
> 	if (ext->fe_phys_length == 0)
> 		ext->fe_phys_length = ext->fe_logi_length;
> 
> but that pre-supposes that fe_phys_length == 0 is never a valid value when
> fe_logi_length is non-zero, and this might introduce errors in some cases.
> I could imagine that some compression methods might not allocate any space
> at all if it was all zeroes, and just store a bit in the blockpointer or
> extent, so having a separate FIEMAP_EXTENT_PHYS_LENGTH is probably safer
> in the long run.

Sounds good to me.

> That opens up the question of whether a written zero
> filled space that gets compressed away is different from a hole, but I'd
> prefer to just return whatever the file mapping is than interpret it.

It could save some bytes, but I don' see it too practical. I expect the
amount of zeroed blocks to be low on average and the current compression
methods are able to squeeze long runs of zeros to a few tens of bytes
per page.
