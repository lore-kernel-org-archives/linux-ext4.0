From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] filefrag: fix frag count in bmap case
Date: Sat, 15 Aug 2009 23:50:21 -0400
Message-ID: <20090816035021.GC17958@mit.edu>
References: <4A7A434B.9090007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41343 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867AbZHPDuW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Aug 2009 23:50:22 -0400
Content-Disposition: inline
In-Reply-To: <4A7A434B.9090007@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 05, 2009 at 09:43:23PM -0500, Eric Sandeen wrote:
> The fragmentation count in the bmap case seems to be
> off by one:
> 
> # echo foo > /mnt/test/bar
> # filefrag /mnt/test/bar
> /mnt/test/bar: 0 extents found

Thanks, applied.

					- Ted
