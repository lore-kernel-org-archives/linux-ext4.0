From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] debugfs: document htree-related commands in man page
Date: Sat, 14 May 2011 23:39:28 -0400
Message-ID: <20110515033928.GH21165@thunk.org>
References: <4DCABE03.7040300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49912 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851Ab1EODja (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 May 2011 23:39:30 -0400
Content-Disposition: inline
In-Reply-To: <4DCABE03.7040300@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 11, 2011 at 11:49:07AM -0500, Eric Sandeen wrote:
> The debugfs commands dirsearch, dx_hash, and htree_dump were
> never documented in the man page.  Do so.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, added to the e2fsprogs "next" branch.

					- Ted
