From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Wed, 25 Aug 2010 15:34:50 +0200
Message-ID: <1282743290.2605.3704.camel@laptop>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com>
	 <1282656558.2605.2742.camel@laptop> <4C73CA24.3060707@fusionio.com>
	 <alpine.DEB.2.00.1008241309170.21242@chino.kir.corp.google.com>
	 <20100825112433.GB4453@thunk.org> <1282736132.2605.3563.camel@laptop>
	 <20100825115709.GD4453@thunk.org>  <1282740516.2605.3644.camel@laptop>
	 <1282740778.2605.3652.camel@laptop>
	 <E25A6DCB-3188-4CF9-9DC4-631192B2F0E2@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: David Rientjes <rientjes@google.com>,
	Jens Axboe <jaxboe@fusionio.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"cluster-devel@redhat.com" <cluster-devel@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"reiserfs-devel@vger.kernel.org" <reiserfs-devel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48989 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab0HYNfP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Aug 2010 09:35:15 -0400
In-Reply-To: <E25A6DCB-3188-4CF9-9DC4-631192B2F0E2@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2010-08-25 at 09:20 -0400, Theodore Tso wrote:
> Well, if all of these users start having their own private pools of
> emergency memory, I'm not sure that's such a great idea either.

That's a secondary problem, and could be reduced by something like the
memory reservation system I provided in the swap-over-nfs patches. Of
course, when all these users can actually happen concurrently there's
really nothing much you can do about it.


