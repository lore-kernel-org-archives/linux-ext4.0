From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Tue, 6 Mar 2007 14:47:46 +0000
Message-ID: <20070306144746.GA22052@infradead.org>
References: <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070301142537.b5950cd7.akpm@linux-foundation.org> <1172788855.26078.294.camel@edge> <20070301145256.3e999932.akpm@linux-foundation.org> <45E86CBA.3070905@us.ibm.com> <20070305122742.GA11486@atrey.karlin.mff.cuni.cz> <45EC7773.7020603@us.ibm.com> <20070306072850.GA23081@infradead.org> <45ED7C59.4050508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Mingming Cao <cmm@us.ibm.com>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>, nscott@aconex.com,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, alex@clusterfs.com,
	suzuki@in.ibm.com
To: Ulrich Drepper <drepper@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <45ED7C59.4050508@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Mar 06, 2007 at 06:36:09AM -0800, Ulrich Drepper wrote:
> Christoph Hellwig wrote:
> > fallocate with the whence argument and flags is already quite complicated,
> > I'd rather have another call for placement decisions, that would
> > be called on an fd to do placement decissions for any further allocations
> > (prealloc, write, etc)
> 
> Yes, posix_fallocate shouldn't be made more complicated.  But I don't
> understand why requesting linear layout of the blocks should be an
> option.  It's always an advantage if the blocks requested this way are
> linear on disk.  So, the kernel should always do its best to make this
> happen, without needing an additional option.

There are HPC workloads where you have multi writers on multiple machines
that write to different parts of a file.  You preferably want each
of those regions in separate allocation groups.  (Or tell the customers
to use separate files for the regions..)
