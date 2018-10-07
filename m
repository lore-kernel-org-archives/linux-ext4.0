Return-Path: <SRS0=d5+7=MT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49488 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726976AbeJHCam (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 7 Oct 2018 22:30:42 -0400
Date: Sun, 7 Oct 2018 15:22:21 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH RESEND v2 21/25] ext4: Add encoding mount options
Message-ID: <20181007192221.GB10662@thunk.org>
References: <20180924215655.3676-1-krisman@collabora.co.uk>
 <20180924215655.3676-22-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180924215655.3676-22-krisman@collabora.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 24, 2018 at 05:56:51PM -0400, Gabriel Krisman Bertazi wrote:
> This patch implements two new mount options for ext4: encoding and
> encoding_flags.
> 
> The encoding option receives a string that identifies the NLS encoding
> to be used when mounting the filesystem.  The user can optionally ask
> for a specific version by appending the version string after a dash.
> 
> The encoding_flags argument allows the user to specify how the NLS
> charset must behave.  The exact behavior of the flags are defined at
> ext4.h.
> 
> encoding_flags is ignored if the user didn't provide an encoding.
> 
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

It seems to me that adding support for setting the encoding parameters
via mount options is a bad idea.  The encoding is going to impact
directory hash; which means if the file system has directories created
using, say, ASCII as its encoding, and then the encoding changes to
UTF-8, directory lookups won't work correctly.  So I think this commit
needs to be dropped, and support for setting the encoding needs to be
added to e2fsprogs as the primary way encoding settings are made.

We need e2fsprogs support before this feature is ready for production
use, since e2fsck needs to be able to properly rebuild directories.

Do you agree?

						- Ted
