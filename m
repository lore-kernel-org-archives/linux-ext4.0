From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: disable synchronous transaction batching if
 max_batch_time==0
Date: Sat, 5 Jul 2014 18:39:30 -0400
Message-ID: <20140705223930.GM11103@thunk.org>
References: <53964D05.6000009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47048 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbaGEWjb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Jul 2014 18:39:31 -0400
Content-Disposition: inline
In-Reply-To: <53964D05.6000009@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 09, 2014 at 07:10:45PM -0500, Eric Sandeen wrote:
> The mount manpage says of the max_batch_time option,
> 
> 	This optimization can be turned off entirely
> 	by setting max_batch_time to 0.
> 
> But the code doesn't do that.  So fix the code to do
> that.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

				- Ted
