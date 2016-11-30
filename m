From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 1/6] dax: fix build breakage with ext4, dax and !iomap
Date: Wed, 30 Nov 2016 12:04:31 -0700
Message-ID: <20161130190431.GA11793@linux.intel.com>
References: <1479926662-21718-1-git-send-email-ross.zwisler@linux.intel.com>
 <1479926662-21718-2-git-send-email-ross.zwisler@linux.intel.com>
 <20161124090239.GA24138@quack2.suse.cz>
 <20161128191504.GB6637@linux.intel.com>
 <20161129085303.GA7550@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>,
 linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161129085303.GA7550-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
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

On Tue, Nov 29, 2016 at 09:53:03AM +0100, Jan Kara wrote:
> On Mon 28-11-16 12:15:04, Ross Zwisler wrote:
> > On Thu, Nov 24, 2016 at 10:02:39AM +0100, Jan Kara wrote:
> > > On Wed 23-11-16 11:44:17, Ross Zwisler wrote:
> > > > With the current Kconfig setup it is possible to have the following:
> > > > 
> > > > CONFIG_EXT4_FS=y
> > > > CONFIG_FS_DAX=y
> > > > CONFIG_FS_IOMAP=n	# this is in fs/Kconfig & isn't user accessible
> > > > 
> > > > With this config we get build failures in ext4_dax_fault() because the
> > > > iomap functions in fs/dax.c are missing:
> > > > 
> > > > fs/built-in.o: In function `ext4_dax_fault':
> > > > file.c:(.text+0x7f3ac): undefined reference to `dax_iomap_fault'
> > > > file.c:(.text+0x7f404): undefined reference to `dax_iomap_fault'
> > > > fs/built-in.o: In function `ext4_file_read_iter':
> > > > file.c:(.text+0x7fc54): undefined reference to `dax_iomap_rw'
> > > > fs/built-in.o: In function `ext4_file_write_iter':
> > > > file.c:(.text+0x7fe9a): undefined reference to `dax_iomap_rw'
> > > > file.c:(.text+0x7feed): undefined reference to `dax_iomap_rw'
> > > > fs/built-in.o: In function `ext4_block_zero_page_range':
> > > > inode.c:(.text+0x85c0d): undefined reference to `iomap_zero_range'
> > > > 
> > > > Now that the struct buffer_head based DAX fault paths and I/O path have
> > > > been removed we really depend on iomap support being present for DAX.  Make
> > > > this explicit by selecting FS_IOMAP if we compile in DAX support.
> > > > 
> > > > Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > > 
> > > I've sent the same patch to Ted yesterday and he will probably queue it on
> > > top of ext4 iomap patches. If it doesn't happen for some reason, feel free
> > > to add:
> > > 
> > > Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> > 
> > Cool, looks like Ted has pulled in your patch.
> > 
> > I think we still eventually want this patch because it cleans up our handling
> > of FS_IOMAP.  With your patch we select it separately in both ext4 & ext2
> > based on whether we include DAX, and we still have #ifdefs in fs/dax.c for
> > FS_IOMAP.
> 
> Actually, based on Dave's request I've also sent Ted updated version which
> did select FS_IOMAP in CONFIG_DAX section. However Ted didn't pull that
> patch (yet?). Anyway, I don't care whose patch gets merged, I just wanted
> to notify you of possible conflict.

Can you please CC me on these patches in the future?  I also don't care whose
patches end up fixing this, but I want to make sure we end up in a world where
the "select FS_IOMAP" just happens directly for FS_DAX in fs/Kconfig so that
I can get rid of the unnecessary #ifdefs in fs/dax.c for CONFIG_FS_IOMAP.
