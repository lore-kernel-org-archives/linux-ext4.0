From: Theodore Tso <tytso@mit.edu>
Subject: Re: Enabling h-trees too early?
Date: Thu, 20 Sep 2007 11:14:40 -0400
Message-ID: <20070920151440.GE30221@thunk.org>
References: <20070919150715.GH9232@duck.suse.cz> <20070919182450.GF25497@thunk.org> <20070920133350.GH2689@duck.suse.cz> <20070920142800.GC30221@thunk.org> <20070920145839.GD1986@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:37955 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756117AbXITPOm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Sep 2007 11:14:42 -0400
Content-Disposition: inline
In-Reply-To: <20070920145839.GD1986@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 20, 2007 at 04:58:39PM +0200, Jan Kara wrote:
>   Hmm, strange - I've just looked at my computer and dir_index is set
> just for 5 directories in my tree.

I looked at a tree that had object files, which is probably why I had
8 directories; I'm guessing you probably just had kernel sources and
no build files.

> If I try deleting just them, I also
> see some performance decrease but it's less than if I try deleting the
> whole tree (and that result seems to be quite consistent)... There's something
> fishy there. Maybe I could try seekwatcher or something similar to see
> what's really happening.

That is very strange.....

						- Ted
