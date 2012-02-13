From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Mark possibly unused variable in
 ext4_mb_normalize_request()
Date: Mon, 13 Feb 2012 17:23:18 -0500
Message-ID: <20120213222318.GE21641@thunk.org>
References: <1324336212-19700-1-git-send-email-curtw@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47821 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962Ab2BMWXV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Feb 2012 17:23:21 -0500
Content-Disposition: inline
In-Reply-To: <1324336212-19700-1-git-send-email-curtw@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 19, 2011 at 03:10:12PM -0800, Curt Wohlgemuth wrote:
> The 'orig_size' local variable is only used in a call to
> mb_debug().  Mark it with '__maybe_unused'.
> 
> Signed-off-by: Curt Wohlgemuth <curtw@google.com>

Thanks, applied.

					- Ted
