From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 0/9] add ext4 per-inode DAX flag
Date: Fri, 8 Sep 2017 11:39:13 -0400
Message-ID: <20170908153913.jjhzogjs5zpeea5v@thunk.org>
References: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
 <f856f8fd-3697-adb1-198b-a9ae2fce405f@redhat.com>
 <20170906170754.GB17663@linux.intel.com>
 <CAPcyv4hfhDT9NFRXL+MT5epiqWHJ0RLraV4P3CZ4EJM6L-s0Nw@mail.gmail.com>
 <20170907211303.GA23212@linux.intel.com>
 <5F58D3F5-D93B-4648-AE01-8A46956FBB4B@dilger.ca>
 <20170907215148.GA12669@linux.intel.com>
 <20170907221201.GZ17782@dastard>
 <20170907221900.GB12669@linux.intel.com>
 <20170907232543.GB17782@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
 "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>,
 "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, xfs <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Lukas Czerner <lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170907232543.GB17782@dastard>
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

On Fri, Sep 08, 2017 at 09:25:43AM +1000, Dave Chinner wrote:
> > Okay, so other ideas (which you have also probably already though of) include:
> > 
> > 1) Just return -EBUSY if anyone tries to change the DAX flag of an inode with
> > open mappings or any open file handles.
> 
> You have to have an open fd to change the flag. :)

What if we only allow the S_DAX flag to be *set*, when i_size and
i_blocks is zero?  We could also require that only one file descriptor
be open against the inode, and that it be opened O_RDONLY.

						- Ted
