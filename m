From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext2, ext4: Fix issue with missing journal entry
Date: Sat, 27 Feb 2016 14:21:48 -0500
Message-ID: <20160227192148.GC15325@thunk.org>
References: <1453921308-5544-1-git-send-email-ross.zwisler@linux.intel.com>
 <20160128131630.GI7726@quack.suse.cz>
 <20160128163211.GA19770@linux.intel.com>
 <20160224204446.GB13473@linux.intel.com>
 <20160225083728.GA24965@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>,
	Jan Kara <jack@suse.com>,
	Matthew Wilcox <willy@linux.intel.com>,
	linux-ext4@vger.kernel.org, linux-nvdimm@ml01.01.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160225083728.GA24965@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Feb 25, 2016 at 09:37:28AM +0100, Jan Kara wrote:
> > Looks like this patch didn't ever get merged for v4.5?  Is it still queued for
> > v4.6?
> 
> Ted has been pretty busy lately and we probably didn't make it sufficiently
> clear that he should pick up this patch. Ted, can you please pick up this
> patch and push it to 4.5? Thanks. Feel free to add my:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Sorry, yes, I missed this one since most of the DAX patches have been
going through other trees.   I've just sent a pull request to Linus.

      	      	    	     	       - Ted
