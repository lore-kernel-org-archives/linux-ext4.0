From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 3/6] dax: add tracepoint infrastructure, PMD tracing
Date: Thu, 24 Nov 2016 17:32:20 +0000
Message-ID: <20161124173220.GR1555@ZenIV.linux.org.uk>
References: <1479926662-21718-1-git-send-email-ross.zwisler@linux.intel.com>
 <1479926662-21718-4-git-send-email-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-nvdimm@lists.01.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1479926662-21718-4-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 23, 2016 at 11:44:19AM -0700, Ross Zwisler wrote:
> Tracepoints are the standard way to capture debugging and tracing
> information in many parts of the kernel, including the XFS and ext4
> filesystems.  Create a tracepoint header for FS DAX and add the first DAX
> tracepoints to the PMD fault handler.  This allows the tracing for DAX to
> be done in the same way as the filesystem tracing so that developers can
> look at them together and get a coherent idea of what the system is doing.

	It also has one hell of potential for becoming a massive nuisance.
Keep in mind that if any userland code becomes dependent on those - that's it,
they have become parts of stable userland ABI and are to be maintained
indefinitely.  Don't expect "tracepoints are special case" to prevent that.

	So treat anything you add in that manner as potential stable ABI
you might have to keep around forever.  It's *not* a glorified debugging
printk.
