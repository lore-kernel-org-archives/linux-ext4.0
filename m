From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Reorder ext4 and ext2 so that ext2 root filesystems
	are mounted using ext2
Date: Sat, 28 Feb 2009 09:52:00 -0500
Message-ID: <20090228145200.GA6935@mit.edu>
References: <1235831060-10086-1-git-send-email-tytso@mit.edu> <20090228143943.GD4894@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Fries <david@fries.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44640 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbZB1OwE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Feb 2009 09:52:04 -0500
Content-Disposition: inline
In-Reply-To: <20090228143943.GD4894@spacedout.fries.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 28, 2009 at 08:39:43AM -0600, David Fries wrote:
> 
> Try
> > +# We place ext4 after ext2 so plain ext2 root fs's aren't mounted using ext4
> > +# unless explicitly requested by rootfstype
> 

Oops, nice catch!  I changed it to be:

# We place ext4 after ext2 so plain ext2 root fs's are mounted using ext2
# unless explicitly requested by rootfstype

Thanks,

						- Ted
