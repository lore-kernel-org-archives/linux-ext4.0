From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 0/9] re-enable DAX PMD support
Date: Thu, 1 Sep 2016 10:21:39 -0600
Message-ID: <20160901162139.GA6687@linux.intel.com>
References: <20160823220419.11717-1-ross.zwisler@linux.intel.com>
 <20160830230150.GA12173@linux.intel.com>
 <1472674799.2092.19.camel@hpe.com>
 <20160831213607.GA6921@linux.intel.com>
 <1472681284.2092.30.camel@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"mawilcox@microsoft.com" <mawilcox@microsoft.com>,
	"linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"jack@suse.com" <jack@suse.com>, "tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1472681284.2092.30.camel@hpe.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 31, 2016 at 10:08:59PM +0000, Kani, Toshimitsu wrote:
> On Wed, 2016-08-31 at 15:36 -0600, Ross Zwisler wrote:
> > On Wed, Aug 31, 2016 at 08:20:48PM +0000, Kani, Toshimitsu wrote:
> > > 
> > > On Tue, 2016-08-30 at 17:01 -0600, Ross Zwisler wrote:
> > > > 
> > > > On Tue, Aug 23, 2016 at 04:04:10PM -0600, Ross Zwisler wrote:
>  :
> > > > 
> > > > Ping on this series?  Any objections or comments?
> > > 
> > > Hi Ross,
> > > 
> > > I am seeing a major performance loss in fio mmap test with this
> > > patch-set applied.  This happens with or without my patches [1]
> > > applied on top of yours.  Without my patches, dax_pmd_fault() falls
> > > back to the pte handler since an mmap'ed address is not 2MB-
> > > aligned.
> > > 
> > > I have attached three test results.
> > >  o rc4.log - 4.8.0-rc4 (base)
> > >  o non-pmd.log - 4.8.0-rc4 + your patchset (fall back to pte)
> > >  o pmd.log - 4.8.0-rc4 + your patchset + my patchset (use pmd maps)
> > > 
> > > My test steps are as follows.
> > > 
> > > mkfs.ext4 -O bigalloc -C 2M /dev/pmem0
> > > mount -o dax /dev/pmem0 /mnt/pmem0
> > > numactl --preferred block:pmem0 --cpunodebind block:pmem0 fio
> > > test.fio
> > > 
> > > "test.fio"
> > > ---
> > > [global]
> > > bs=4k
> > > size=2G
> > > directory=/mnt/pmem0
> > > ioengine=mmap
> > > [randrw]
> > > rw=randrw
> > > ---
> > > 
> > > Can you please take a look?
> > 
> > Yep, thanks for the report.
> 
> I have some more observations.  It seems this issue is related with pmd
> mappings after all.  fio creates "randrw.0.0" file.  In my setup, an
> initial test run creates pmd mappings and hits this issue.  Subsequent
> test runs (i.e. randrw.0.0 exists), without my patches, fall back to
> pte mappings and do not hit this issue.  With my patches applied,
> subsequent runs still create pmd mappings and hit this issue.

I've been able to reproduce this on my test setup, and I agree that it appears
to be related to the PMD mappings.  Here's my performance with 4k mappings,
either before my set or without your patches:

 READ: io=1022.7MB, aggrb=590299KB/s, minb=590299KB/s, maxb=590299KB/s, mint=1774msec, maxt=1774msec
WRITE: io=1025.4MB, aggrb=591860KB/s, minb=591860KB/s, maxb=591860KB/s, mint=1774msec, maxt=1774msec

And with 2 MiB pages:

 READ: io=1022.7MB, aggrb=17931KB/s, minb=17931KB/s, maxb=17931KB/s, mint=58401msec, maxt=58401msec
WRITE: io=1025.4MB, aggrb=17978KB/s, minb=17978KB/s, maxb=17978KB/s, mint=58401msec, maxt=58401msec

Dan is seeing something similar with his device DAX code with 2MiB pages, so
our best guess right now is that it must be in the PMD MM code, since that's
really the only thing that the fs/dax and device/dax implementations share.

Interestingly, I'm getting the opposite results when testing in my VM.  Here's
the performance with 4k pages:

 READ: io=1022.7MB, aggrb=251728KB/s, minb=251728KB/s, maxb=251728KB/s, mint=4160msec, maxt=4160msec
WRITE: io=1025.4MB, aggrb=252394KB/s, minb=252394KB/s, maxb=252394KB/s, mint=4160msec, maxt=4160msec

And with 2MiB pages:

 READ: io=1022.7MB, aggrb=902751KB/s, minb=902751KB/s, maxb=902751KB/s, mint=1160msec, maxt=1160msec
WRITE: io=1025.4MB, aggrb=905137KB/s, minb=905137KB/s, maxb=905137KB/s, mint=1160msec, maxt=1160msec

This is a totally different system, so the halved 4k performance in the VM
isn't comparable to my bare metal system, but it's interesting that the use of
PMDs over tripled the performance in my VM.  Hmm...

We'll keep digging into this.  Thanks again for the report. :)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
