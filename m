From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH v2 5/5] ext4: remove duplicate extended attributes defs
Date: Thu, 12 Oct 2017 12:18:53 -0400
Message-ID: <20171012161853.4y4p3u5lsla2wqzx@thunk.org>
References: <20170912050526.7627-1-ross.zwisler@linux.intel.com>
 <20170912050526.7627-6-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
 linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Li Xi <lixi-LfVdkaOWEx8@public.gmane.org>,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170912050526.7627-6-ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

On Mon, Sep 11, 2017 at 11:05:26PM -0600, Ross Zwisler wrote:
> The following commit:
> 
> commit 9b7365fc1c82 ("ext4: add FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR
> interface support")
> 
> added several defines related to extended attributes to ext4.h.  They were
> added within an #ifndef FS_IOC_FSGETXATTR block with the comment:
> 
> /* Until the uapi changes get merged for project quota... */
> 
> Those uapi changes were merged by this commit:
> 
> commit 334e580a6f97 ("fs: XFS_IOC_FS[SG]SETXATTR to FS_IOC_FS[SG]ETXATTR
> promotion")
> 
> so all the definitions needed by ext4 are available in
> include/uapi/linux/fs.h.  Remove the duplicates from ext4.h.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> Cc: Li Xi <lixi-LfVdkaOWEx8@public.gmane.org>
> Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
> Cc: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
> Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> Cc: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks, applied.

					- Ted
