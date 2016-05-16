From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/4] ext4: DAX fixes
Date: Mon, 16 May 2016 11:08:20 -0400
Message-ID: <20160516150820.GJ7799@thunk.org>
References: <1462959551-28622-1-git-send-email-jack@suse.cz>
 <20160513052419.GD5862@thunk.org>
 <20160513135600.GA2996@thunk.org>
 <20160516093525.GD12026@quack2.suse.cz>
 <20160516142616.GB21714@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-nvdimm@ml01.01.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160516142616.GB21714@quack2.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 16, 2016 at 04:26:16PM +0200, Jan Kara wrote:
> 1) Just push patches as is and have ext4 dax broken between ext4 merge and
> nvdimm merge.
> 
> 2) Split out the one-line change from "dax: Remove dead zeroing code from
> fault handlers" in __dax_fault() which fixes the behavior for ext4 and
> merge it through ext4 tree. Merge the rest through nvdimm tree.

I'm good either way, although I have a slight preference for (2).
It's really tiny preference, though, so if you or Dan want to run the
fix through the dax branch, that's fine too.

I've updated the ext4 dev branch to point include your dax changes, so
they can get picked up for linux-next integration testing.

     	     	       	   	      		  - Ted
