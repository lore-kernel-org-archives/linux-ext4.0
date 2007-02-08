From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: Testing ext4 persistent preallocation patches for 64 bit features
Date: Thu, 8 Feb 2007 14:22:31 +0530
Message-ID: <20070208085231.GA15964@amitarora.in.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070207074801.GA5419@amitarora.in.ibm.com> <1170836750.4355.36.camel@localhost.localdomain> <20070207103622.GA6328@in.ibm.com> <20070207211117.GE6565@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: suparna@in.ibm.com, cmm@us.ibm.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, alex@clusterfs.com,
	suzuki@in.ibm.com
To: adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:36097 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423085AbXBHIwl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Feb 2007 03:52:41 -0500
Content-Disposition: inline
In-Reply-To: <20070207211117.GE6565@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 07, 2007 at 02:11:17PM -0700, Andreas Dilger wrote:
> On Feb 07, 2007  16:06 +0530, Suparna Bhattacharya wrote:
> > On Wed, Feb 07, 2007 at 12:25:50AM -0800, Mingming Cao wrote:
> > > - disable preallocation if the filesystem free blocks is under some low
> > > watermarks, to save space for near future real block allocation?
> > 
> > A policy decision like this is probably worth a discussion during today's call.
> > 
> > > - is de-preallocation something worth doing?
> 
> As discussed in the call - I don't think we can remove preallocations.
> The whole point of database preallocation is to guarantee that this space
> is available in the filesystem when writing into a file at random offsets
> (which would otherwise be sparse).
> 
> Similarly, persistent preallocation shouldn't be considered differently
> than an efficient way of doing zero filling of blocks.  At least that is
> my understanding...  Is this code implementing the "uninitialized extents"
> for databases (via explicit preallocation via fallocate/ioctl) so that
> they don't have to zero-fill large files, or is there also automatic
> preallocation of space to files (e.g. for O_APPEND files)?

You are right. There is no automatic preallocation of space being done
here. This code just implements the explicit (persistent) preallocation
of blocks via ioctl.

--
Regards,
Amit Arora
