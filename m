From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC V3] ext4: limit block allocations for
	indirect-block files to < 2^32
Date: Thu, 10 Sep 2009 19:19:46 -0400
Message-ID: <20090910231946.GF6705@mit.edu>
References: <4AA1920C.9040406@redhat.com> <4AA1D94F.8060703@redhat.com> <20090905164535.GL4197@webber.adilger.int> <4AA92307.4010304@redhat.com> <20090910211006.GF9372@webber.adilger.int> <4AA96CB0.3090309@redhat.com> <20090910215158.GI9372@webber.adilger.int> <4AA97652.4010802@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41900 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbZIJXTw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Sep 2009 19:19:52 -0400
Content-Disposition: inline
In-Reply-To: <4AA97652.4010802@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 10, 2009 at 04:57:38PM -0500, Eric Sandeen wrote:
> 
> Problem is I don't quite trust debugfs etc to get it right, so when I
> see < 32 bits, I'm not sure if it's really there, or if the
> reporting/debug tool wrapped it ;)

Debugfs from pu branch definitely does get it right --- I've checked.

	     	       		       	   - Ted
