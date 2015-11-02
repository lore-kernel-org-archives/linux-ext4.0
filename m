From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Corruption from interrupted e2fsck
Date: Mon, 2 Nov 2015 10:23:53 -0500
Message-ID: <20151102152353.GA4024@thunk.org>
References: <B9F63236-3539-492E-83EB-3377836C2FDB@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37395 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbbKBPX4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Nov 2015 10:23:56 -0500
Content-Disposition: inline
In-Reply-To: <B9F63236-3539-492E-83EB-3377836C2FDB@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 01, 2015 at 06:16:50PM -0700, Andreas Dilger wrote:
> Is there a reason not to have a cancel check right after the return from
> e2fsck_run() rather than trying to recover the journal and quota files?
> I can imagine that there is a desire to flush out modified inodes and such
> that have been repaired, so that restarting an interrupted e2fsck will make
> progress, but the quota file update is plain wrong unless at least pass1
> has finished, and the journal recreation is also dangerous if the block
> bitmaps have not been fully updated.

You're right.  My suggested fix would be in the case of
E2F_FLAG_CANCEL, we set the ctx->invalid_bitmaps flag, and then avoid
writing out the quota file if invalid_bitmaps is enabled.

Cheers,

					- Ted
