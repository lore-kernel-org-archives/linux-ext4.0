From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] JBD slab cleanups
Date: Mon, 17 Sep 2007 20:34:43 +0100
Message-ID: <20070917193443.GA32013@infradead.org>
References: <1188605538.3837.51.camel@localhost.localdomain> <20070901183922.GA12907@infradead.org> <Pine.LNX.4.64.0709020438490.28046@schroedinger.engr.sgi.com> <20070902152801.GA19962@infradead.org> <Pine.LNX.4.64.0709030051370.31366@schroedinger.engr.sgi.com> <20070903134043.GB28962@infradead.org> <Pine.LNX.4.64.0709031230190.2131@schroedinger.engr.sgi.com> <20070903193308.GA7771@infradead.org> <1189796027.3841.6.camel@localhost.localdomain> <1190057391.3845.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, pbadari@us.ibm.com,
	Christoph Lameter <clameter@sgi.com>,
	linux-fsdevel@vger.kernel.org,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759408AbXIQTfA@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1190057391.3845.22.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Sep 17, 2007 at 12:29:51PM -0700, Mingming Cao wrote:
> The problem with this patch, as Andreas Dilger pointed today in ext4
> interlock call, for 1k,2k block size ext2/3/4, get_free_pages() waste
> 1/3-1/2 page space. 
> 
> What was the originally intention to set up slabs for committed_data(and
> frozen_buffer) in JBD? Why not using kmalloc?

kmalloc is using slabs :)

The intent was to avoid the wasted memory, but as we've repeated a gazillion
times wasted memory on a rather rare codepath doesn't really matter when
you just crash random storage drivers otherwise.
