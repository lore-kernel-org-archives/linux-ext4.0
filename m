From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC] vm: Add an tuning knob for vm.max_writeback_pages
Date: Tue, 1 Sep 2009 16:30:22 -0400
Message-ID: <20090901203022.GD6996@mit.edu>
References: <1251600858-21294-1-git-send-email-tytso@mit.edu> <20090830165229.GA5189@infradead.org> <20090830181731.GA20822@mit.edu> <20090901180052.GA7885@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>,
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, jens
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:59114 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbZIAUaW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Sep 2009 16:30:22 -0400
Content-Disposition: inline
In-Reply-To: <20090901180052.GA7885@think>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 01, 2009 at 02:00:52PM -0400, Chris Mason wrote:
> 
> I haven't yet tried this without the max_writeback_pages patch, but the
> graphs clearly show a speed improvement, and that the mainline code is
> smearing writes across the drive while Jens' work is writing
> sequentially.

FYI, you don't need to revert the max_writebacks_pages patch; the
whole point of making it a tunable was to make it easier to run
benchmarks.  If you want to get the effects of the original setting of
MAX_WRITEBACK_PAGES before the patch, just run as root: 

    sysctl vm.max_writeback_pages=1024

						- Ted
