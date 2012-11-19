From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Issue with bad file system
Date: Mon, 19 Nov 2012 14:36:46 -0500
Message-ID: <20121119193646.GB30091@thunk.org>
References: <20121119184107.GA29487@thunk.org>
 <20121119191505.24680.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sandeen@redhat.com, dreusser@gmail.com, linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33620 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311Ab2KSTgu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Nov 2012 14:36:50 -0500
Content-Disposition: inline
In-Reply-To: <20121119191505.24680.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 19, 2012 at 02:15:05PM -0500, George Spelvin wrote:
> 
> Oh, more enthusiastic users are *already* trying out metadata_csum
> on production file systems.  And finding lots of bugs doing so!
> 
> My latest is a file system where e2fsck can find the problem, but
> can't fix it.

Is this a file system suffering from the aftermath of the off-line
resizing with the 64-bit file system feature?  Or is this some other
unrelated problem?

Thanks,

						- Ted


