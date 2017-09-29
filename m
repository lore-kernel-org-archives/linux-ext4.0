From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 0/5] ext4: DAX data corruption fixes
Date: Fri, 29 Sep 2017 11:37:52 -0600
Message-ID: <20170929173752.GA6155@linux.intel.com>
References: <20170912050526.7627-1-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170912050526.7627-1-ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

On Mon, Sep 11, 2017 at 11:05:21PM -0600, Ross Zwisler wrote:
> This series prevents a pair of data corruptions with ext4 + DAX.  The first
> such corruption happens when combining the inline data feature with DAX,
> and the second happens when combining data journaling with DAX.
> 
> Both can be reliably reproduced with the fstests that I have posted here:
> 
> https://patchwork.kernel.org/patch/9948377/
> https://patchwork.kernel.org/patch/9948381/
> 
> My opinion is that the first three patches in this series should be applied
> to the v4.14 RC series and backported to stable.  The last two patches in
> this series are just cleanup and can probably wait until v4.15.
> 
> Ross Zwisler (5):
>   ext4: prevent data corruption with inline data + DAX
>   ext4: prevent data corruption with journaling + DAX
>   ext4: add sanity check for encryption + DAX
>   ext4: add ext4_should_use_dax()
>   ext4: remove duplicate extended attributes defs
> 
>  fs/ext4/ext4.h   | 37 -------------------------------------
>  fs/ext4/inline.c | 10 ----------
>  fs/ext4/inode.c  | 24 ++++++++++++++++--------
>  fs/ext4/ioctl.c  | 16 +++++++++++++---
>  fs/ext4/super.c  |  8 ++++++++
>  5 files changed, 37 insertions(+), 58 deletions(-)

Hey Ted,

I just wanted to ping this series, and see if at least the data corruption
fixes were headed for v4.14?  I don't think these have been merged into any of
the ext4 branches yet.

Thanks,
- Ross
