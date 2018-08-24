From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v4 1/2] dax: dax_layout_busy_page() warn on !exceptional
Date: Fri, 24 Aug 2018 17:44:43 +0200
Message-ID: <20180824154443.GA26549@quack2.suse.cz>
References: <20180710191031.17919-1-ross.zwisler@linux.intel.com>
 <20180710191031.17919-2-ross.zwisler@linux.intel.com>
 <6ca60cf6-f1dc-27d5-fb79-7547aea39dfa@redhat.com>
 <20180810203349.GH627@thunk.org> <20180811021053.GB14368@thunk.org>
 <20180813101252.GC8927@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
 "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>,
 Lukas Czerner <lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Theodore Y. Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180813101252.GC8927-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
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

On Mon 13-08-18 12:12:52, Jan Kara wrote:
> On Fri 10-08-18 22:10:53, Theodore Y. Ts'o wrote:
> > The generic/344 failure seems to be caused by a WARNING triggered in
> > the nvdimm code:
> 
> OK, apparently this is nothing new for you as generic/344 fails for you
> even with 3.17. But it should not :). I'll try to see if I can reproduce
> this in my test setup during more test runs (I don't remember seeing it
> during occasional runs I do) and debug it further.

I could reproduce this relatively easily but it took me quite a while to
figure out how to best fix this. I'll send the fix shortly (mm: Fix warning
in insert_pfn()).

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
