From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH/RFC] - make ext3 more robust in the face of filesystem corruption
Date: Thu, 19 Oct 2006 01:35:18 -0600
Message-ID: <20061019073518.GN3509@schatzie.adilger.int>
References: <45369869.60400@redhat.com> <20061018214022.GJ3509@schatzie.adilger.int> <4536A31F.5050604@redhat.com> <20061018222449.GK3509@schatzie.adilger.int> <4536C642.5020301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:12496 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1946073AbWJSHfV
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Oct 2006 03:35:21 -0400
To: Eric Sandeen <esandeen@redhat.com>
Content-Disposition: inline
In-Reply-To: <4536C642.5020301@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 18, 2006  19:26 -0500, Eric Sandeen wrote:
> >Well, it would also be possible to look into inode->i_blocks to see what
> >blocks exist past this offset, but that is complicated by the introduction
> > <eom>
> introduction of ...?  :)

Sorry - introduction of extents.  So we can't just look into the i_blocks
{d,t,}indirect blocks to work out the maximum reasonable size for an inode
without adding decoding of extents into this code.  Maybe if "SEEK_DATA"
is added to ext3 (patch was proposed this past week) then we could seek
past the hole efficiently.  For now I'm happy to assume i_blocks * 512 is
a safe upper limit on the file size.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
