From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V2] ext4: include journal blocks in df overhead calcs
Date: Tue, 25 Dec 2012 13:57:13 -0500
Message-ID: <20121225185713.GF5318@thunk.org>
References: <50B67949.60104@redhat.com>
 <50B686A8.2010101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Eric Whitney <enwlinux@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40302 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059Ab2LYS6G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Dec 2012 13:58:06 -0500
Content-Disposition: inline
In-Reply-To: <50B686A8.2010101@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 28, 2012 at 03:48:24PM -0600, Eric Sandeen wrote:
> To more accurately calculate overhead for "bsd" style
> df reporting, we should count the journal blocks as
> overhead as well.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Tested-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.

					- Ted
