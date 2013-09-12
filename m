From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: use kobj_completion in ext4_sb_info
Date: Wed, 11 Sep 2013 21:48:13 -0400
Message-ID: <20130912014813.GA12918@thunk.org>
References: <522F5A6D.50100@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Greg KH <gregkh@linux.com>
To: Jeff Mahoney <jeffm@suse.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58644 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab3ILBsV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Sep 2013 21:48:21 -0400
Content-Disposition: inline
In-Reply-To: <522F5A6D.50100@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 10, 2013 at 01:44:13PM -0400, Jeff Mahoney wrote:
> Now that we have the kobj_completion structure available, let's use it
> in ext4.
> 
> Note that we aggregate the del/put/wait_for_completion in one
> kobj_completion_del_and_wait call. Since the kobject isn't used for
> anything while the fs is shutting down and we wait until it's released
> before continuing anyway, this is safe.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

I don't have a huge objection to this, but given that it's not fixing
a bug, and it's not saving _that_ many lines of code, if you want to
run the first patch through Greg's tree (which is fine with me), I
might wait to merge this patch until 3.13, so it's not obvious that
it's worth dealing with the inter-tree dependency, since it
complicates testing on my end.

Does that sound reasonable?

						- Ted
