From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ext4: Add generic writepage callback
Date: Wed, 3 Jun 2009 18:57:33 -0400
Message-ID: <20090603225733.GB21314@mit.edu>
References: <1243439888-22680-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1243439888-22680-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1243439888-22680-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090603225308.GA21314@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, jack@suse.cz,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:39055 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989AbZFCW5f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Jun 2009 18:57:35 -0400
Content-Disposition: inline
In-Reply-To: <20090603225308.GA21314@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 03, 2009 at 06:53:08PM -0400, Theodore Tso wrote:
> Hi Aneesh,
> 
> In the future, *please* give me patches versus the patch queue.  This
> patch moves functions around, so applying it is painful in the
> extreme, and it's very painful to check and see whether it undoes
> patches later in the patch.
> 
> In fact, can you redo these patches (2/3 and 3/3), versus the latest
> in the patch queue?

P.S.  And if you can avoid making the patch move functions around,
it'll make it a lot more likely that I'll be able to backport it to
the -stable series.  In its current form it's essentially impossible
that I would ever consider trying to backport it to 2.6.29, or
(goodness help us, 2.6.27).

						- Ted
