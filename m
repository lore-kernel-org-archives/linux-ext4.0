From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: add large_file to base mkfs features
Date: Wed, 1 Oct 2014 08:34:11 -0400
Message-ID: <20141001123411.GB2903@thunk.org>
References: <542B744B.3070602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58682 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbaJAMeO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Oct 2014 08:34:14 -0400
Content-Disposition: inline
In-Reply-To: <542B744B.3070602@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 30, 2014 at 10:26:03PM -0500, Eric Sandeen wrote:
> large_file (> 2G) support has been around since at least kernel 2.4;
> mkfs of any sufficiently large filesystem sets it "accidentally"
> when the resize inode exceeds 2G.  This leaves very small
> filesystems lacking the feature, which potentially changes
> their behavior & codepaths the first time a > 2G file gets
> written.
> 
> There's really no reason to be making fresh filesystems which
> strive to keep compatibility with 10 year old kernels; just
> enable large_file at mkfs time.  This is particularly obvious
> for ext4 fielsystems, which set huge_file by default, but not
> necessarily large_file.
> 
> If old-kernel compatibility is desired, mke2fs.conf can be
> modified locally to remove the feature.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
