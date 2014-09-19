From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 35/34] e2fsck: free bh when descriptor block checksum
 fails
Date: Thu, 18 Sep 2014 21:46:48 -0400
Message-ID: <20140919014648.GG26995@thunk.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
 <20140914171935.GE10150@birch.djwong.org>
 <5415E85D.4070703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36708 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756460AbaISBqw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Sep 2014 21:46:52 -0400
Content-Disposition: inline
In-Reply-To: <5415E85D.4070703@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 14, 2014 at 02:11:25PM -0500, Eric Sandeen wrote:
> On 9/14/14 12:19 PM, Darrick J. Wong wrote:
> > Free the buffer head if the journal descriptor block fails checksum
> > verification.  This has been patched before (see "e2fsck: free bh on
> > csum verify error in do_one_pass") but apparently the patch was never
> > committed to jbd2 in the kernel, so when we resync'd the recovery code
> > with 3.16, the bug came back.  Sigh.
> 
> Cool. 
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> thanks for fixing up the kernel side... I hadn't thought about that,
> obviously.  :(

Applied, thanks.

					- Ted
