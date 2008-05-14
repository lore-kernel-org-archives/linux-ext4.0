From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] fix extent_goto for non-0 leaf levels
Date: Wed, 14 May 2008 13:32:30 -0400
Message-ID: <20080514173230.GB7054@mit.edu>
References: <4828CF2D.9010804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:59663 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751614AbYENRcg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 May 2008 13:32:36 -0400
Content-Disposition: inline
In-Reply-To: <4828CF2D.9010804@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 12, 2008 at 06:13:49PM -0500, Eric Sandeen wrote:
> The logic for stopping at the right level in extent_goto was wrong,
> so if you asked it to go to any level other than 0 (the leaf
> level) it would fail.
> 
> Also add this argument to the tst_extents goto command to test it.
> 
> (I thought this was a failure in my split code but it was this
> helper that was causing problems...)

Oops, thanks for catching this.  Applied.

							- Ted
