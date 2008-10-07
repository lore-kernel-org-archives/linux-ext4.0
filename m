From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Improve buffered streaming write ordering
Date: Tue, 7 Oct 2008 09:36:51 -0400
Message-ID: <20081007133651.GA19895__29562.7124411569$1223386772$gmane$org@infradead.org>
References: <1222950054.6745.18.camel@think.oraclecorp.com> <20081002181856.GB29613@skywalker> <20081002234309.GH30001@disturbed> <1223063155.13375.64.camel@think.oraclecorp.com> <20081006101605.GA15881@skywalker> <1223302903.16546.58.camel@think.oraclecorp.com> <20081007084531.GB15881@skywalker> <20081007090554.GA23811@infradead.org> <20081007100257.GA30745@skywalker> <20081007132911.GA6905@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Christoph Hellwig <hch@infradead.org>,
	Chris Mason <chris.mason@oracle.com>,
	Dave Chinner <david@f
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48833 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbYJGNhP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Oct 2008 09:37:15 -0400
Content-Disposition: inline
In-Reply-To: <20081007132911.GA6905@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 07, 2008 at 09:29:11AM -0400, Theodore Tso wrote:
> That's true, but there is a lot of code duplication, which means that
> bugs or changes in write_cache_pages() would need to be fixed in
> ext4_write_cache_pages().  So another approach that might be better
> from a long-term code maintenance point of view is to add a flag in
> struct writeback_control that tells write_cache_pages() not to update
> those fields, and avoid duplicating approximately 95 lines of code.
> It means a change in a core mm function, though, so if folks thinks
> its too ugly, we can make our own copy in fs/ext4.
> 
> Opinions?  Andrew, as someone who often weighs in on fs and mm issues,
> what do you think?  My preference would be to make the change to
> mm/page-writeback.c, controlled by a flag which ext4 would set be set
> by fs/ext4 before it calls write_cache_pages().

I agree.  But I'm still not quite sure if that requirement is unique to
ext4 anyway.  Give me some time to dive into the writeback code again,
haven't been there for quite a while.

