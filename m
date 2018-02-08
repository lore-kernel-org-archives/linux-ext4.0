From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] debugfs: remove misplaced "MMP is unsupported" message.
Date: Wed, 7 Feb 2018 23:28:55 -0500
Message-ID: <20180208042855.GD6182@thunk.org>
References: <1516764797-27781-1-git-send-email-tgnottingham@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tyson Nottingham <tgnottingham@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48826 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750806AbeBHE26 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 7 Feb 2018 23:28:58 -0500
Content-Disposition: inline
In-Reply-To: <1516764797-27781-1-git-send-email-tgnottingham@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 23, 2018 at 07:33:17PM -0800, Tyson Nottingham wrote:
> This message was inadvertently copied from the version of do_dump_mmp
> that is used when CONFIG_MMP is disabled.
> 
> Signed-off-by: Tyson Nottingham <tgnottingham@gmail.com>

Thanks, applied.

					- Ted
