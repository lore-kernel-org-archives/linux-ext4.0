From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] ext4: Fix lost truncate due to race with writeback
Date: Wed, 28 Aug 2013 18:55:04 -0400
Message-ID: <20130828225504.GL27079@thunk.org>
References: <1375710744-29329-1-git-send-email-jack@suse.cz>
 <1375710744-29329-5-git-send-email-jack@suse.cz>
 <20130817141227.GG30769@thunk.org>
 <20130826190137.GA27768@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50924 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755171Ab3H1WzO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Aug 2013 18:55:14 -0400
Content-Disposition: inline
In-Reply-To: <20130826190137.GA27768@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 26, 2013 at 03:01:48PM -0400, Dave Jones wrote:
> 
> Is this queued for 3.11 ? 1k blocksize fs's are still broken in rc7.

These patches fixed races that have been around for a while; it's not
a regression.  Given that they are fairly involved, I was nervous
sending them to Linus for 3.11, given the late date.

They are queued for the next merge window, and I'll mark them cc:
stable@vger.kernel.org.

						- Ted
