From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/6][TAKE5] fallocate system call
Date: Thu, 28 Jun 2007 23:27:57 +0530
Message-ID: <20070628175757.GA1674@amitarora.in.ibm.com>
References: <20070510223950.GD86004887@sgi.com> <20070511110301.GB28425@in.ibm.com> <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070628025543.9467216f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>,
	Andreas Dilger <adilger@clusterfs.com>, suparna@in.ibm.com,
	cmm@us.ibm.com, xfs@oss.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48895 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755430AbXF1R5x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Jun 2007 13:57:53 -0400
Content-Disposition: inline
In-Reply-To: <20070628025543.9467216f.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 28, 2007 at 02:55:43AM -0700, Andrew Morton wrote:
> On Mon, 25 Jun 2007 18:58:10 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
> 
> > N O T E: 
> > -------
> > 1) Only Patches 4/7 and 7/7 are NEW. Rest of them are _already_ part
> >    of ext4 patch queue git tree hosted by Ted.
> 
> Why the heck are replacements for these things being sent out again when
> they're already in -mm and they're already in Ted's queue (from which I
> need to diligently drop them each time I remerge)?
> 
> Are we all supposed to re-review the entire patchset (or at least #4 and
> #7) again?

As I mentioned in the note above, only patches #4 and #7 were new and
thus these needed to be reviewed. Other patches are _not_ replacements
of any of the patches which are already part of -mm and/or in Ted's
patch queue. They were posted again as just "placeholders" so that the
two new patches (#4 & #7) could be reviewed. Sorry for any confusion.
 
> Please drop the non-ext4 patches from the ext4 tree and send incremental
> patches against the (non-ext4) fallocate patches in -mm.

Please let us know what you think of Mingming's suggestion of posting
all the fallocate patches including the ext4 ones as incremental ones
against the -mm.

--
Regards,
Amit Arora
