From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix spinlock assertions on UP systems
Date: Fri, 15 May 2009 08:32:32 -0400
Message-ID: <20090515123232.GB9173@mit.edu>
References: <1242381325-10307-1-git-send-email-vincent@vincent-minet.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Vincent Minet <vincent@vincent-minet.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44008 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401AbZEOMcd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 May 2009 08:32:33 -0400
Content-Disposition: inline
In-Reply-To: <1242381325-10307-1-git-send-email-vincent@vincent-minet.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 15, 2009 at 11:55:25AM +0200, Vincent Minet wrote:
> On UP systems without DEBUG_SPINLOCK, ext4_is_group_locked always fails
> which triggers a BUG_ON() call.
> This patch fixes it by using assert_spin_locked instead.
> 
> Signed-off-by: Vincent Minet <vincent@vincent-minet.net>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Thanks, I'll include this in the ext4 patch queue to send to Linus.

	     	     	     	      - Ted
