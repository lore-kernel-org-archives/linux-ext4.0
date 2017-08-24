From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 13/13] ext4: Support for synchronous DAX faults
Date: Thu, 24 Aug 2017 05:34:52 -0700
Message-ID: <20170824123452.GB21282@infradead.org>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-14-jack@suse.cz>
 <20170824123126.GA21282@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Boaz Harrosh <boazh-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>,
 linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170824123126.GA21282-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
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

On Thu, Aug 24, 2017 at 05:31:26AM -0700, Christoph Hellwig wrote:
> On Thu, Aug 17, 2017 at 06:08:15PM +0200, Jan Kara wrote:
> > We return IOMAP_F_NEEDDSYNC flag from ext4_iomap_begin() for a
> > synchronous write fault when inode has some uncommitted metadata
> > changes. In the fault handler ext4_dax_fault() we then detect this case,
> > call vfs_fsync_range() to make sure all metadata is committed, and call
> > dax_pfn_mkwrite() to mark PTE as writeable. Note that this will also
> > dirty corresponding radix tree entry which is what we want - fsync(2)
> > will still provide data integrity guarantees for applications not using
> > userspace flushing. And applications using userspace flushing can avoid
> > calling fsync(2) and thus avoid the performance overhead.
> 
> Why is this only wiered up for the huge_fault handler and not the
> regular?

Ah, turns out ext4 implements ->fault in terms of ->huge_fault.

We'll really need to sort out this mess of fault handlers before
doing too much surgery here..
