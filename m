From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] jbd2: replace potentially false assertion with if
	block
Date: Sat, 8 Mar 2008 13:45:43 -0500
Message-ID: <20080308184543.GA4284@infradead.org>
References: <5e28cd633c71f6354a203a43000cbe5fef045589.1204844851.git.duaneg@dghda.com> <48afbb3a44aa24dc1e31835c14e86c3c6c1c3b0a.1204844851.git.duaneg@dghda.com> <20080307212336.GE1881@webber.adilger.int> <20080308150229.GA22430@infradead.org> <e9e943910803080840u251ade36j92612f6150de6cf9@mail.gmail.com> <20080308164258.GA30512@infradead.org> <e9e943910803081037w5e7a8743p449b999001b94281@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	sct@redhat.com, akpm@linux-foundation.org
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38995 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbYCHSpq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Mar 2008 13:45:46 -0500
Content-Disposition: inline
In-Reply-To: <e9e943910803081037w5e7a8743p449b999001b94281@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 08, 2008 at 06:37:08PM +0000, Duane Griffin wrote:
> Sorry if I'm missing something here, but I think the caches do need to
> be checked. If jbd/ext3 are not modular then even if initialisation
> fails the journal code may still be called later. I noticed this when
> testing the failure modes after making my original fix.

Doh, I think you're right.  Just because jbd initialization fails
ext3 could succeed later on.   We probably want to make ext3
initialization fail early in that case through an exported flag.

> I've modified my changes to match the way you suggested doing things
> in your earlier reply (and thanks for the review, BTW). If you would
> prefer I'll rework my changes as a separate patch on top. Just let me
> know.

I don't really care how it's delivered.  Just consider my patches a 
scetch and do whatever you think is best with them.

