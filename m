From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] e2fsprogs: Tidy up mmp handling in debugfs
Date: Fri, 11 Nov 2011 21:12:59 -0500
Message-ID: <20111112021259.GD4055@thunk.org>
References: <4EBC5524.3000105@redhat.com>
 <4EBC55E2.3080600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35106 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab1KLFQI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Nov 2011 00:16:08 -0500
Content-Disposition: inline
In-Reply-To: <4EBC55E2.3080600@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 10, 2011 at 04:53:22PM -0600, Eric Sandeen wrote:
> Several small fixes:
> 
> * Gracefully fail mmp commands if fs is not open
> * Show magic number in dump_mmp command
> * Fix header in output for set_mmp_value -l
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

						- Ted
