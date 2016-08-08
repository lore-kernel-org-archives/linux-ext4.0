From: "Kani, Toshimitsu" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: RE: Subtle races between DAX mmap fault and write path
Date: Mon, 8 Aug 2016 19:32:47 +0000
Message-ID: <CS1PR84MB0005ADA0CDED56A9E5FF64A5821B0@CS1PR84MB0005.NAMPRD84.PROD.OUTLOOK.COM>
References: <20160729022152.GZ16044@dastard>
 <CAPcyv4gOcDGzikJHYGxNXtYqQKkPUgkG+z4ASxogQUnp1zmD2g@mail.gmail.com>
 <20160730001249.GE16044@dastard> <579F20D9.80107@plexistor.com>
 <20160802002144.GL16044@dastard> <1470335997.8908.128.camel@hpe.com>
 <20160805112739.GG16044@dastard>
 <CS1PR84MB0119314ACA9B4823C0FE33318E180@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
 <20160808092655.GA29128@quack2.suse.cz>
 <CS1PR84MB0119ACB424699154BDA197B28E1B0@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
 <20160808182827.GI29128@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, "xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org" <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>,
 "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "Boylston, Brian" <brian.boylston-ZPxbGqLxI0U@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20160808182827.GI29128-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
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

> > Jan Kara wrote on 2016-08-08:
> > > On Fri 05-08-16 19:58:33, Boylston, Brian wrote:
> >
> > I used NVML 1.1 for the measurements.  In this version and with the
> > hardware that I used, the pmem_persist() flow is:
> >
> >   pmem_persist()
> >     pmem_flush()
> >       Func_flush() == flush_clflush
> >         CLFLUSH
> >     pmem_drain()
> >       Func_predrain_fence() == predrain_fence_empty
> >         no-op
> >
> > So, I don't think that pmem_persist() does anything to cause the filesystem
> > to flush metadata as it doesn't make any system calls?
> 
> Ah, you are right. I somehow misread what is in NVML sources. I agree with
> Christoph that _persist suffix is then misleading for the reasons he stated
> but that's irrelevant to the test you did.
> 
> So it indeed seems that in your test movnt + sfence is an order of
> magnitude faster than cached memcpy + cflush + sfence. I'm surprised I have
> to say.

movnt is posted to WC buffer, which is asynchronously evicted to memory
when each line is filled.

clflush, on the other hand, must be serialized.  So, it has to synchronously evict
line-by-line.  clflushopt, when supported by new CPUs, should be a lot faster as
it can execute simultaneously and does not have to wait line-by-line.  It'd be still
slower than uncached copy, though. 

-Toshi 
