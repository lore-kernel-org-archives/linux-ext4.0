From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] ext4: Don't send extra barrier during fsync if there are
	no dirty pages.
Date: Tue, 4 May 2010 11:45:53 -0400
Message-ID: <20100504154553.GA22777@infradead.org>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com> <1272934667.2544.3.camel@mingming-laptop> <4BE02C45.6010608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>, djwong@us.ibm.com,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46485 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab0EDPpz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 May 2010 11:45:55 -0400
Content-Disposition: inline
In-Reply-To: <4BE02C45.6010608@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 04, 2010 at 10:16:37AM -0400, Ric Wheeler wrote:
> Checking per inode is actually incorrect - we do not want to short cut  
> the need to flush the target storage device's write cache just because a  
> specific file has no dirty pages.  If a power hit occurs, having sent  
> the pages from to the storage device is not sufficient.

As long as we're only using the information for fsync doing it per inode
is the correct thing.  We only want to flush the cache if the inode
(data or metadata) is dirty in some way.  Note that this includes writes
via O_DIRECT which are quite different to track - I've not found the
original patch in my mbox so I can't comment if this is done right.

It might be good idea to track this information directly in the
writeback/direct I/O code so that we don't have to reimplement it for
every filesystems, btw.

