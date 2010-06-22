From: tytso@mit.edu
Subject: Re: Updated ext4 quota design document
Date: Tue, 22 Jun 2010 17:52:00 -0400
Message-ID: <20100622215200.GE6843@thunk.org>
References: <E1OQg7e-0001mI-AB@closure.thunk.org>
 <20100622142047.GF3338@quack.suse.cz>
 <20100622200853.GD6843@thunk.org>
 <20100622202927.GA9413@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:55223 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938Ab0FVVwE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jun 2010 17:52:04 -0400
Content-Disposition: inline
In-Reply-To: <20100622202927.GA9413@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 22, 2010 at 10:29:27PM +0200, Jan Kara wrote:
>   With metadata which get journaled it should be quite easy. JBD already
> must know before you go and modify buffer contents - that's why
> journal_get_write_access and friends exist. It also makes sure that your
> data cannot be modified from the moment the buffer enters commit upto the
> moment the commit is finished. So you can use buffer commit hook to compute
> and store block checksum safely.

True, but we're also interested in making sure this feature can be
used in the non-journal case as well....

     						- Ted
