From: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm,x86: fix SMP x86 32bit build for native_pud_clear()
Date: Thu, 16 Feb 2017 09:27:52 -0700
Message-ID: <7280edbc-ba2b-2b72-680a-9408a8e764b9@intel.com>
References: <148719066814.31111.3239231168815337012.stgit@djiang5-desk3.ch.intel.com>
 <68216ac2-e194-30fa-9dcb-2020e8953bf5@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: jack-IBi9RG/b67k@public.gmane.org, alexander.kapshuk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
 vbabka-AlSwsSmVLrQ@public.gmane.org, keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
To: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <68216ac2-e194-30fa-9dcb-2020e8953bf5-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org



On 02/16/2017 08:42 AM, Dave Hansen wrote:
> On 02/15/2017 12:31 PM, Dave Jiang wrote:
>> The fix introduced by e4decc90 to fix the UP case for 32bit x86, however
>> that broke the SMP case that was working previously. Add ifdef so the dummy
>> function only show up for 32bit UP case only.
> 
> Could you elaborate a bit on how it broke things?

So originally 0-day build found that commit a10a1701 (mm, x86: add
support for PUD-sized transparent hugepages) is breaking 32bit x86 UP
config because native_pud_clear() was missing to satisfy
arch/x86/include/asm/pgtable.h. I added a dummy function to satisfy that
with commit e4decc90 (mm,x86: native_pud_clear missing on i386 build).
However in the process of doing that, I broke the 32bit x86 SMP config
that was working before.

> 
>> Fix: e4decc90 mm,x86: native_pud_clear missing on i386 build
> 
> Which tree is that in, btw?
> 
linux-next-20170214 I believe
