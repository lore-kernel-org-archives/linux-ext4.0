From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: dax pmd fault handler never returns to userspace
Date: Wed, 18 Nov 2015 13:32:46 -0500
Message-ID: <x49lh9vma41.fsf@segfault.boston.devel.redhat.com>
References: <x49wptfnw2l.fsf@segfault.boston.devel.redhat.com>
	<CAPcyv4jnNNFAp_L5BFbP4K6vNhffELSS7g0aekhGnCadsBCfnw@mail.gmail.com>
	<20151118170014.GB10656@linux.intel.com>
	<x4937w3nqze.fsf@segfault.boston.devel.redhat.com>
	<CAPcyv4grgkLTVHdGhVSOs1sXsiLQyB1ubcRvmhW=hMZnA9MnHQ@mail.gmail.com>
	<20151118182320.GA7901@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Dan Williams <dan.j.williams@intel.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-nvdimm <linux-nvdimm@ml01.01.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Ross Zwisler <ross.zwisler@intel.com>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20151118182320.GA7901@linux.intel.com> (Ross Zwisler's message
	of "Wed, 18 Nov 2015 11:23:20 -0700")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ross Zwisler <ross.zwisler@linux.intel.com> writes:

> Yea, my first round of testing was broken, sorry about that.
>
> It looks like this test causes the PMD fault handler to be called repeatedly
> over and over until you kill the userspace process.  This doesn't happen for
> XFS because when using XFS this test doesn't hit PMD faults, only PTE faults.

Hmm, I wonder why not?  Sounds like that will need investigating as
well, right?

-Jeff

> So, looks like a livelock as far as I can tell.
>
> Still debugging.

Thanks!
Jeff
