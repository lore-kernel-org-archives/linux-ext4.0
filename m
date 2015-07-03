From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 3/6] ext4: Use ext4_get_block_write() for DAX
Date: Fri, 3 Jul 2015 15:07:03 -0400
Message-ID: <20150703190703.GK9456@thunk.org>
References: <1435934443-17090-1-git-send-email-matthew.r.wilcox@intel.com>
 <1435934443-17090-4-git-send-email-matthew.r.wilcox@intel.com>
 <20150703183027.GH9456@thunk.org>
 <20150703184824.GA13681@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150703184824.GA13681@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 03, 2015 at 02:48:24PM -0400, Matthew Wilcox wrote:
> 
> At boot, I "modprobe pmem".

Is there a reason why it's important to build and load pmem as a
module?  If I use CONFIG_BLK_DEV_PMEM=y (which is more convenient
given how I launch my KVM test appliance), should I expect any
problems?

I assume that this won't detect any bugs caused by missing CLFLUSH
instructions, but I assume that when using NVM as a block device, this
isn't much of an issue, as long as we don't care about torn writes?
(How using NVM with metdata checksums, or any checksums for that
matter, seems to be an interesting question --- how do we recover from
a checksum failure after a power failure?)

					- Ted
