From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Date: Wed, 27 Jun 2007 00:42:15 +0530
Message-ID: <20070626191215.GB13324@amitarora.in.ibm.com>
References: <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625215239.GK5181@schatzie.adilger.int> <20070626104546.GB19870@amitarora.in.ibm.com> <20070626154250.GD6652@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>,
	suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:43145 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758647AbXFZTMJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Jun 2007 15:12:09 -0400
Content-Disposition: inline
In-Reply-To: <20070626154250.GD6652@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 26, 2007 at 11:42:50AM -0400, Andreas Dilger wrote:
> On Jun 26, 2007  16:15 +0530, Amit K. Arora wrote:
> > On Mon, Jun 25, 2007 at 03:52:39PM -0600, Andreas Dilger wrote:
> > > In XFS one of the (many) ALLOC modes is to zero existing data on allocate.
> > > For ext4 all this would mean is calling ext4_ext_mark_uninitialized() on
> > > each extent.  For some workloads this would be much faster than truncate
> > > and reallocate of all the blocks in a file.
> > 
> > In ext4, we already mark each extent having preallocated blocks as
> > uninitialized. This is done as part of following code (which is part of
> > patch 5/7) in ext4_ext_get_blocks() :  
> 
> What I meant is that with XFS_IOC_ALLOCSP the previously-written data
> is ZEROED OUT, unlike with fallocate() which leaves previously-written
> data alone and only allocates in holes.
> 
> In order to specify this for allocation, FA_FL_DEL_DATA would need to make
> sense for allocations (as well as the deallocation).  This is farily easy
> to do - just mark all of the existing extents as unallocated, and their
> data disappears.

Ok, agreed. Will add the FA_ZERO_SPACE mode too.
Thanks!

--
Regards,
Amit Arora
