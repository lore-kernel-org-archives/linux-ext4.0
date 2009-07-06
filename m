From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH V2] naturally align struct ext4_allocation_request
Date: Sun, 5 Jul 2009 22:24:12 -0400
Message-ID: <20090706022412.GD6706@mit.edu>
References: <4A4254C2.8000609@redhat.com> <170fa0d20906251750u697b32e3yb92eab53b51556a3@mail.gmail.com> <4A441FD4.9020403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mike Snitzer <snitzer@gmail.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36335 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbZGFCYL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Jul 2009 22:24:11 -0400
Content-Disposition: inline
In-Reply-To: <4A441FD4.9020403@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 25, 2009 at 08:09:40PM -0500, Eric Sandeen wrote:
> As Ted noted, the ext4_allocation_request isn't well aligned.
> 
> Looking at it with pahole we're wasting space on 64-bit
> arches...
> grouping 32-bit members together closes these holes and shrinks
> the structure by 12 bytes.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>


Thanks, added to the ext4 patch queue.

						- Ted

