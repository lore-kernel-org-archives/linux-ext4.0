From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v5 3/3] xfs: reject removal of realtime flag when datadev
 doesn't support DAX
Date: Thu, 15 Feb 2018 14:48:39 -0800
Message-ID: <20180215224839.GA16073@infradead.org>
References: <151873070632.53899.3320294279108510082.stgit@djiang5-desk3.ch.intel.com>
 <151873085471.53899.4916392112937742603.stgit@djiang5-desk3.ch.intel.com>
 <20180215214708.GA10446@infradead.org>
 <7657c80b-412b-e280-f126-a7d735a0a730@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org,
 Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7657c80b-412b-e280-f126-a7d735a0a730-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

On Thu, Feb 15, 2018 at 03:44:48PM -0700, Dave Jiang wrote:
> > 
> > Except for that the whole series looks fine to me.
> > 
> 
> Can I add your reviewed-by? Thanks for reviewing.

Yes:

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
