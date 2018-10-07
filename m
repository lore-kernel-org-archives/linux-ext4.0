Return-Path: <SRS0=d5+7=MT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49202 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727517AbeJHBSC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 7 Oct 2018 21:18:02 -0400
Date: Sun, 7 Oct 2018 14:09:53 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH RESEND v2 19/25] vfs: Handle case-exact lookup in d_add_ci
Message-ID: <20181007180953.GA10662@thunk.org>
References: <20180924215655.3676-1-krisman@collabora.co.uk>
 <20180924215655.3676-20-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180924215655.3676-20-krisman@collabora.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 24, 2018 at 05:56:49PM -0400, Gabriel Krisman Bertazi wrote:
> This prevents a soft hang if called d_add_ci is called from the FS
> layer, when doing a CI search but the result dentry is the exact match.

This isn't the right way to fix this problem.  Take a look at how xfs
handles this in fs/xfs/xfs_iops.c:xfs_vn_ci_lookup().  This logic
should be in the file system, not in d_add_ci().  Also, we don't want
to use d_same_name(), since that is *not* guaranteed to do an exact
match.  It happens to do so for ext4 since we don't provide d_compare,
but it's better just check for an exact match and call
d_splice_alias() instead of d_add_ci() in ext4_lookup().

Also note that d_same_name() is *not* guaranteeed to do an exact
match, in particular if the file system provides d_compare (which
granted, ext4 doesn't right now).  It's simpler to just do a direct
strcmp in ext4_lookup.

					- Ted

P.S.  Apologies for not having a chance to look at this series in
detail until now.  It's been a crazy month...
