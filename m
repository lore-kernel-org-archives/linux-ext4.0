From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: dax pmd fault handler never returns to userspace
Date: Wed, 18 Nov 2015 10:58:29 -0800
Message-ID: <CAPcyv4i9o4Uznpi3z=FUGZJ14GVnM6dWxyXbgi-1v1YPo=jKqg@mail.gmail.com>
References: <x49wptfnw2l.fsf@segfault.boston.devel.redhat.com>
	<CAPcyv4jnNNFAp_L5BFbP4K6vNhffELSS7g0aekhGnCadsBCfnw@mail.gmail.com>
	<20151118170014.GB10656@linux.intel.com>
	<x4937w3nqze.fsf@segfault.boston.devel.redhat.com>
	<CAPcyv4grgkLTVHdGhVSOs1sXsiLQyB1ubcRvmhW=hMZnA9MnHQ@mail.gmail.com>
	<20151118182320.GA7901@linux.intel.com>
	<x49lh9vma41.fsf@segfault.boston.devel.redhat.com>
	<20151118185326.GA29052@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Ross Zwisler <ross.zwisler@linux.intel.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-nvdimm <linux-nvdimm@ml01.01.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Ross Zwisler <ross.zwisler@intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20151118185326.GA29052@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 18, 2015 at 10:53 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Wed, Nov 18, 2015 at 01:32:46PM -0500, Jeff Moyer wrote:
>> Ross Zwisler <ross.zwisler@linux.intel.com> writes:
>>
>> > Yea, my first round of testing was broken, sorry about that.
>> >
>> > It looks like this test causes the PMD fault handler to be called repeatedly
>> > over and over until you kill the userspace process.  This doesn't happen for
>> > XFS because when using XFS this test doesn't hit PMD faults, only PTE faults.
>>
>> Hmm, I wonder why not?
>
> Well, whether or not you get PMDs is dependent on the block allocator for the
> filesystem.  We ask the FS how much space is contiguous via get_blocks(), and
> if it's less than PMD_SIZE (2 MiB) we fall back to the regular 4k page fault
> path.   This code all lives in __dax_pmd_fault().  There are also a bunch of
> other reasons why we'd fall back to 4k faults - the virtual address isn't 2
> MiB aligned, etc.   It's actually pretty hard to get everything right so you
> actually get PMD faults.
>
> Anyway, my guess is that we're failing to meet one of our criteria in XFS, so
> we just always fall back to PTEs for this test.
>
>> Sounds like that will need investigating as well, right?
>
> Yep, on it.

XFS can do pmd faults just fine, you just need to use fiemap to find a
2MiB aligned physical offset.  See the ndctl pmd test I posted.
