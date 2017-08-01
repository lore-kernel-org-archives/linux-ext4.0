From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC PATCH 0/7] dax, ext4: Synchronous page faults
Date: Tue, 1 Aug 2017 13:26:03 +0200
Message-ID: <20170801112603.GG4215@quack2.suse.cz>
References: <20170727131245.28279-1-jack@suse.cz>
 <x49zibq3rb0.fsf@segfault.boston.devel.redhat.com>
 <20170727215713.GA22000@linux.intel.com>
 <CALCETrVzxrQ76BXEfo4kcRFyQmxbrMwCLE17yPyTJzz0tUs+Dg@mail.gmail.com>
 <20170728093821.GB29433@quack2.suse.cz>
 <20170801110241.GE6742@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170801110241.GE6742-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
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

On Tue 01-08-17 04:02:41, Christoph Hellwig wrote:
> On Fri, Jul 28, 2017 at 11:38:21AM +0200, Jan Kara wrote:
> > Well, you are right I can make the implementation work with struct file
> > flag as well - let's call it O_DAXDSYNC. However there are filesystem
> > operations where you may need to answer question: Is there any fd with
> > O_DAXDSYNC open against this inode (for operations that change file offset
> > -> block mapping)? And in that case inode flag is straightforward while
> > file flag is a bit awkward (you need to implement counter of fd's with that
> > flag in the inode).
> 
> We can still keep and inode flag as the internal implementation
> detail.  As mentioned earlier the right flag to control behavior
> of a mapping is an mmap flag.  And the initial naive implementation
> would simply mark the inode as sync once the first MAP_SYNC open happens
> on it.  We could then move to more precise tracking if/when needed.

OK, makes sense and I like the MAP_SYNC proposal. I'll change it in my
implementation.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
