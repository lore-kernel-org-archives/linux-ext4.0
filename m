From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/4] ext4: DAX fixes
Date: Mon, 16 May 2016 16:26:16 +0200
Message-ID: <20160516142616.GB21714@quack2.suse.cz>
References: <1462959551-28622-1-git-send-email-jack@suse.cz>
 <20160513052419.GD5862@thunk.org>
 <20160513135600.GA2996@thunk.org>
 <20160516093525.GD12026@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-nvdimm@ml01.01.org, Vishal Verma <vishal.l.verma@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-fsdevel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbcEPO0V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 May 2016 10:26:21 -0400
Content-Disposition: inline
In-Reply-To: <20160516093525.GD12026@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 16-05-16 11:35:25, Jan Kara wrote:
> On Fri 13-05-16 09:56:00, Ted Tso wrote:
> > On Fri, May 13, 2016 at 01:24:19AM -0400, Theodore Ts'o wrote:
> > > Queued and I'm running tests before I push them out.  The patches
> > > passed the smoke tests[1], and the full tests should be running for the
> > > next seven hours or so at:   http://104.197.222.91
> > 
> > So the good news is that the full tests ("gce-xfstests full") look
> > really good[1]) Unfortunately the DAX tests ("gce-xfstests -c dax -g
> > auto") show a regression.  Is this expected?  (i.e., were you
> > expecting test regressions that will be fixed by the DAX patch
> > series?)
> 
> No, I was not expecting to get new xfstests failures from just ext4
> patches. That being said I didn't test ext4 patches on their own, just in
> combination with other DAX changes so there may be some interaction I
> forgot about. I'll see whether I can reproduce the failures and understand
> what's going on. Thanks for having a look!

So I have nailed this down. The patch "ext4: Handle transient ENOSPC
properly for DAX" changes how ext4_dax_mmap_get_block() (later renamed to
ext4_dax_get_block()) behaves for calls with create == 0 and that trips
over an issue in __dax_fault() (a bug that __dax_fault() doesn't call
get_blocks() with create == 1 for write faults into unwritten extents)
which gets fixed only in "dax: Remove dead zeroing code from fault handlers".

I see two options here:

1) Just push patches as is and have ext4 dax broken between ext4 merge and
nvdimm merge.

2) Split out the one-line change from "dax: Remove dead zeroing code from
fault handlers" in __dax_fault() which fixes the behavior for ext4 and
merge it through ext4 tree. Merge the rest through nvdimm tree.

Dan? Ted?

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
