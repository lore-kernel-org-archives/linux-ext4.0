From: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch 1/2] add init_ext4_proc() stub for when CONFIG_PROC_FS is not set
Date: Tue, 9 Oct 2007 13:40:12 -0400
Message-ID: <20071009174012.GJ31713@thunk.org>
References: <20071009055033.145153755@au1.ibm.com> <20071009061101.666614585@au1.ibm.com> <1191947487.12131.33.camel@dyn9047017100.beaverton.ibm.com> <1191949386.3793.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Badari Pulavarty <pbadari@gmail.com>, markn@au1.ibm.com,
	ext4 <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52869 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbXJIRkX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Oct 2007 13:40:23 -0400
Content-Disposition: inline
In-Reply-To: <1191949386.3793.16.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 09, 2007 at 10:03:06AM -0700, Mingming Cao wrote:
> I guess our testing did not catch this up because we have CONFIG_PROC_FS
> enabled all the time. mballoc needs procfs for exporting some stats info
> and tunable paramenters to optimize/customize multiple allocation.
> 
> We could select CONFIG_PROC_FS at kconfig when ext4dev is enabled.

We definitely should be able to compile without CONFIG_PROC_FS; it's a
major flaw in the mballoc-core.patch that it doesn't work without it.  

I'm not sure why ext4_pspace_cachep is initialized in
init_ext4_proc(), since it looks like that is being used as part of
the core mballoc infrastructure, and just for proc work.  It's
definitely very unfortunate that the proc support is intertwined with
the rest of the mballoc code, since the it means that adding the
straight-forward #ifdef's will make the code quite ugly. 

		 	       	    	- Ted
