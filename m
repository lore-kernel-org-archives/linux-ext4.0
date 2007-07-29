From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [RFC] basic delayed allocation in VFS
Date: Sun, 29 Jul 2007 21:48:10 +0400
Message-ID: <46ACD2DA.20101@clusterfs.com>
References: <46A8628D.6070103@clusterfs.com> <46A87858.40005@garzik.org> <20070728195114.GA5952@infradead.org> <20070729173035.GU5992@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>,
	Jeff Garzik <jeff@garzik.org>, Alex Tomas <alex@clusterfs.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070729173035.GU5992@schatzie.adilger.int>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> Sigh, we HAVE a patch that was only adding delalloc to ext4, but it
> was rejected because "that functionality should go into the VFS".
> Since the performance improvement of delalloc is quite large, we'd
> like to get this into the kernel one way or another.  Can we make a
> decision if the ext4-specific delalloc is acceptable?

I think the latter one is better because it supports bs < pagesize
(though I'm not sure about data=ordered yet). I'm not against putting
most of the patch into fs/ext4/, but at least few bits to be changed
in fs/ - exports in  fs/mpage.c and one "if" in __block_write_full_page().

thanks, Alex

