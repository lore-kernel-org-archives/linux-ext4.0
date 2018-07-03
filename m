From: "Theodore Y. Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH v2 1/2] dax: dax_layout_busy_page() warn on !exceptional
Date: Tue, 3 Jul 2018 13:44:02 -0400
Message-ID: <20180703174402.GD4384@thunk.org>
References: <20180627212252.31032-1-ross.zwisler@linux.intel.com>
 <20180627212252.31032-2-ross.zwisler@linux.intel.com>
 <20180702221503.GA12830@thunk.org>
 <20180703154137.GB13019@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180703154137.GB13019-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

On Tue, Jul 03, 2018 at 09:41:37AM -0600, Ross Zwisler wrote:
> 
> It looks like you only picked up patch 1/2?  (I'm looking at the 'dev' branch
> in your repo.)  Was that intentional?

Actually, it was a mistake, in that if you looked at the commit, it's
currently an empty commit.  The patch failed to apply because the ext4
tree is still based on v4.17-rc4.

My current plan is to hold the two patches until I get the current
patch of fixes pushed to Linus (probably in the next day or two; I'll
drop the empty commit before I send a pull request to reduce
confusion).  I'll then reset the ext4 tree to be based on v4.17 (or
possibly v4.18-rcX if that is necessary) and then apply the two
patches in this series.

Apologies for the confusion....

						- Ted
