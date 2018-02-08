From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] chattr/lsattr: update obsolete attribute support
Date: Wed, 7 Feb 2018 23:35:14 -0500
Message-ID: <20180208043514.GE6182@thunk.org>
References: <1517870730-20883-1-git-send-email-tgnottingham@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tyson Nottingham <tgnottingham@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48842 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751153AbeBHEfQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 7 Feb 2018 23:35:16 -0500
Content-Disposition: inline
In-Reply-To: <1517870730-20883-1-git-send-email-tgnottingham@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 05, 2018 at 02:45:30PM -0800, Tyson Nottingham wrote:
> * Remove description of and printing of h, which was never visible to
>   clients of the EXT4_IOC_GETFLAGS ioctl, including chattr and lsattr.
> 
> * Remove descriptions of X and Z, whose support was removed in
>   4a05268cf86f713 (Remove compression support).
> 
> * Update a brief description of E, whose meaning was changed in
>   22f22ab1d2bc5ae (Reserve the codepoints for the new INCOMPAT
>   feature ENCRYPT).
> 
> * Add P to symbolic mode format string.
> 
> Signed-off-by: Tyson Nottingham <tgnottingham@gmail.com>

Applied, thanks.

					- Ted
