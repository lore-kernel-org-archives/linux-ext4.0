From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Improve buffered streaming write ordering
Date: Thu, 2 Oct 2008 12:44:33 -0700
Message-ID: <20081002124433.f6612036.akpm@linux-foundation.org>
References: <1222886451.9158.34.camel@think.oraclecorp.com>
	<20081001215239.ee2ae63f.akpm@linux-foundation.org>
	<1222950054.6745.18.camel@think.oraclecorp.com>
	<20081002181856.GB29613@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081002181856.GB29613@skywalker>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2 Oct 2008 23:48:56 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> > 
> > For a 4.5GB streaming buffered write, this printk inside
> > ext4_da_writepage shows up 37,2429 times in /var/log/messages.
> > 
> 
> Part of that can happen due to shrink_page_list -> pageout -> writepagee
> call back with lots of unallocated buffer_heads(blocks).

That workload shouldn't be using that code path much at all.  It's
supposed to be the case that pdflush and balance_dirty_pages() do most
of the writeback work.

And that _used_ to be the case, but we broke it.  It happened several
years ago and I wasn't able to provoke anyone into finding out why. 
iirc the XFS guys noticed it because their throughput was fairly badly
affected.

