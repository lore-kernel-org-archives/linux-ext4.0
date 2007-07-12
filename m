From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Date: Thu, 12 Jul 2007 23:13:34 +1000
Message-ID: <20070712131334.GY31489@sgi.com>
References: <20070625150320.GA8686@amitarora.in.ibm.com> <20070625214626.GJ5181@schatzie.adilger.int> <20070626103247.GA19870@amitarora.in.ibm.com> <20070630102111.GB23568@infradead.org> <20070630165246.GA5159@schatzie.adilger.int> <20070703100848.GA14936@amitarora.in.ibm.com> <20070703103107.GA29763@infradead.org> <20070703114650.GB14936@amitarora.in.ibm.com> <20070711090312.GA18301@infradead.org> <20070712072813.GA31260@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	David Chinner <dgc@sgi.com>, cmm@us.ibm.com, xfs@oss.sgi.com
To: Suparna Bhattacharya <suparna@in.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39574 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932396AbXGLNOF (ORCPT
	<rfc822;@relay.sgi.com:linux-ext4@vger.kernel.org>);
	Thu, 12 Jul 2007 09:14:05 -0400
Content-Disposition: inline
In-Reply-To: <20070712072813.GA31260@in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 12, 2007 at 12:58:13PM +0530, Suparna Bhattacharya wrote:
> 
> Why don't we just merge the interface for preallocation (essentially
> enough to satisfy posix_fallocate() and the simple XFS requirement for 
> space reservation without changing file size), which there is clear agreement
> on (I hope :)).  After all, this was all that we set out to do when we
> started.
> 
> And leave all the dealloc/punch/hsm type features for separate future patches/
> debates, those really shouldn't hold up the basic fallocate interface.
> I agree with Christoph that we are just diverging too much in trying to
> club those decisions here.
> 
> Dave, Andreas, Ted ?

Sure. I'll just make XFS work with whatever it is that gets merged.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
