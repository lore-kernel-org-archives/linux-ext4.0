From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: dax pmd fault handler never returns to userspace
Date: Wed, 18 Nov 2015 13:57:24 -0800
Message-ID: <CAPcyv4g5LoOZH81JfB+xTKXs5cSxZogTfFUyQqq1U8h=aNrjuw@mail.gmail.com>
References: <x49wptfnw2l.fsf@segfault.boston.devel.redhat.com>
	<CAPcyv4jnNNFAp_L5BFbP4K6vNhffELSS7g0aekhGnCadsBCfnw@mail.gmail.com>
	<20151118170014.GB10656@linux.intel.com>
	<x4937w3nqze.fsf@segfault.boston.devel.redhat.com>
	<CAPcyv4grgkLTVHdGhVSOs1sXsiLQyB1ubcRvmhW=hMZnA9MnHQ@mail.gmail.com>
	<20151118182320.GA7901@linux.intel.com>
	<1447882389.21443.151.camel@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-nvdimm <linux-nvdimm@ml01.01.org>,
	Ross Zwisler <ross.zwisler@intel.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Toshi Kani <toshi.kani@hpe.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1447882389.21443.151.camel@hpe.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 18, 2015 at 1:33 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
> I am seeing a similar/same problem in my test.  I think the problem is that in
> case of a WP fault, wp_huge_pmd() -> __dax_pmd_fault() -> vmf_insert_pfn_pmd(),
> which is a no-op since the PMD is mapped already.  We need WP handling for this
> PMD map.
>
> If it helps, I have attached change for follow_trans_huge_pmd().  I have not
> tested much, though.

Interesting, I didn't get this far because my tests were crashing the
kernel.  I'll add this case the pmd fault test in ndctl.
