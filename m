From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [fstests PATCH v2 2/2] generic/999: test DAX DMA vs
 truncate/hole-punch
Date: Mon, 16 Jul 2018 10:07:49 -0600
Message-ID: <20180716160749.GB2287@linux.intel.com>
References: <20180710220942.21074-1-ross.zwisler@linux.intel.com>
 <20180710220942.21074-3-ross.zwisler@linux.intel.com>
 <20180714014105.GY2234@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180714014105.GY2234@dastard>
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

On Sat, Jul 14, 2018 at 11:41:05AM +1000, Dave Chinner wrote:
> On Tue, Jul 10, 2018 at 04:09:42PM -0600, Ross Zwisler wrote:
> > This adds a regression test for the following series:
> > 
> > https://lists.01.org/pipermail/linux-nvdimm/2018-July/016842.html
> > 
> > which adds synchronization between DAX DMA in ext4 and truncate/hole-punch.
> > The intention of the test is to test those specific changes, but it runs
> > fine both with XFS and without DAX so I've put it in the generic tests
> > instead of ext4 and not restricted it to only DAX configurations.
> > 
> > When run with v4.18-rc4 + DAX + ext4, this test will hit the following
> > WARN_ON_ONCE() in dax_disassociate_entry():
> > 
> > 	WARN_ON_ONCE(trunc && page_ref_count(page) > 1);
> > 
> > If you change this to a WARN_ON() instead, you can see that each of the
> > four paths being exercised in this test hits that condition many times in
> > the one second that the subtest is being run.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> 
> just a FWIW:
> 
> > +int main(int argc, char *argv[])
> > +{
> > +	int err;
> > +
> > +	if (argc != 3) {
> > +		printf("Usage: %s <dax file> <non-dax file>\n",
> > +				basename(argv[0]));
> > +		exit(0);
> > +	}
> 
> This is an example of why we should be supporting per-inode DAX
> enablement in all filesystems, not a global mount option....
> 
> > +_supported_fs generic
> > +_supported_os Linux
> > +_require_test
> > +_require_test_program "t_mmap_collision"
> > +
> > +# To get the failure we turn off DAX on our SCRATCH_MNT so we can get O_DIRECT
> > +# behavior.  We will continue to use unmodified mount options for the test
> > +# TEST_DIR.  The failures fixed by the above mentioned kernel patch trigger
> > +# when those mount options include "-o dax", but the test runs fine without
> > +# that option so we don't require it.
> > +export MOUNT_OPTIONS=""
> > +_scratch_unmount >> $seqres.full 2>&1
> > +_scratch_mount >> $seqres.full 2>&1
> 
> And then all this crap would go away....

Yep, I totally agree. :)
