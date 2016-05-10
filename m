From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [RFC v3] [PATCH 0/18] DAX page fault locking
Date: Tue, 10 May 2016 14:30:03 -0600
Message-ID: <20160510203003.GA5314@linux.intel.com>
References: <1461015341-20153-1-git-send-email-jack@suse.cz>
 <20160506203308.GA12506@linux.intel.com>
 <20160509093828.GF11897@quack2.suse.cz>
 <20160510152814.GQ11897@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>,
	linux-nvdimm@lists.01.org, Matthew Wilcox <willy@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160510152814.GQ11897@quack2.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 10, 2016 at 05:28:14PM +0200, Jan Kara wrote:
> On Mon 09-05-16 11:38:28, Jan Kara wrote:
> Somehow, I'm not able to reproduce the warnings... Anyway, I think I see
> what's going on. Can you check whether the warning goes away when you
> change the condition at the end of page_cache_tree_delete() to:
> 
>         if (!dax_mapping(mapping) && !workingset_node_pages(node) &&
>             list_empty(&node->private_list)) {

Yep, this took care of both of the issues that I reported.  I'll restart my
testing with this in my baseline, but as of this fix I don't have any more
open testing issues. :)
