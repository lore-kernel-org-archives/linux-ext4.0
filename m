From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC 01/12] ext4: read-only support for bigalloc file
 systems
Date: Tue, 22 Mar 2011 13:02:20 -0400
Message-ID: <20110322170220.GC3907@thunk.org>
References: <1300570117-24048-1-git-send-email-tytso@mit.edu>
 <1300570117-24048-2-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1103212024460.3724@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57118 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab1CVRCY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Mar 2011 13:02:24 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103212024460.3724@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 21, 2011 at 08:35:20PM +0100, Lukas Czerner wrote:
> 
> Maybe this is a bit nitpicky, but should not this be rather done in
> separate commit as it has nothing to do with bigalloc ?

Perhaps.  The reason why I had it was because I wanted to see the
blocks per group information when I was testing a read-only bigalloc
mount.  I'll grant this is tenuous; I suppose I could separate out
these two patch hunks into a separate patch, but I didn't think it was
really worth it.

> 
> I wonder if we should continue at this point, because something
> definitely went wrong as it has not biballoc feature but yet
> s_log_cluster_size does not match s_log_block_size which means
> definitely corruption or an error somewhere.

I considered this, but I was just paranoid because I didn't want to
change anything in the !bigalloc case.  There was one or two users who
reported that somehow the second 512 byte sector was containing
garbage, and nothing had cared in the past, but when we first broke
into the second 512 bytes of the superblock we did have some
complaints, so that's why I decided to err on the side of
conservatism.

						- Ted
