From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Improve buffered streaming write ordering
Date: Tue, 7 Oct 2008 05:05:54 -0400
Message-ID: <20081007090554.GA23811@infradead.org>
References: <1222886451.9158.34.camel@think.oraclecorp.com> <20081001215239.ee2ae63f.akpm@linux-foundation.org> <1222950054.6745.18.camel@think.oraclecorp.com> <20081002181856.GB29613@skywalker> <20081002234309.GH30001@disturbed> <1223063155.13375.64.camel@think.oraclecorp.com> <20081006101605.GA15881@skywalker> <1223302903.16546.58.camel@think.oraclecorp.com> <20081007084531.GB15881@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755423AbYJGJGl@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081007084531.GB15881@skywalker>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 07, 2008 at 02:15:31PM +0530, Aneesh Kumar K.V wrote:
> +static int ext4_write_cache_pages(struct address_space *mapping,
> +		      struct writeback_control *wbc, writepage_t writepage,
> +		      void *data)
> +{

Looking at this functions the only difference is killing the
writeback_index and range_start updates.  If they are bad why would we
only remove them from ext4?
