From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3] Fix ext4 fault handling when mounted with -o dax,ro
Date: Fri, 25 Aug 2017 00:28:44 -0700
Message-ID: <20170825072843.GA4220@infradead.org>
References: <CAC9jV4pfQr=z9dHqtnTP8kAXGReeLDZWAAAfW2a7KRsK22UWkA@mail.gmail.com>
 <416a465a9fbe1d27085883dbf652c115cd195697.1503523424.git.dodgen@google.com>
 <20170824160144.GA14287@infradead.org>
 <20170824205727.yyhzblj372eyvkde@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, rdodgen@gmail.com,
        linux-ext4@vger.kernel.org, ross.zwisler@linux.intel.com,
        Randy Dodgen <dodgen@google.com>, linux-nvdimm@lists.01.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53378 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754403AbdHYH2t (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Aug 2017 03:28:49 -0400
Content-Disposition: inline
In-Reply-To: <20170824205727.yyhzblj372eyvkde@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 24, 2017 at 04:57:27PM -0400, Theodore Ts'o wrote:
> Yeah, agreed, that's the cleaner way of doing that.  It does mean
> we'll have sweep through all of the file systems so that they DTRT
> with this new FAULT_FLAG_ALLOC, though, right?

I think the only ones that it matters for for now are the DAX
fault handlers.  So we can add the new flag, check it in ext2, ext4
and xfs for now and we're done.  But if we eventually want to
phase out the ->page_mkwrite handler it would be useful for other
file systems as well.
