From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: Simple man page nodiscard option correction
Date: Sun, 20 Feb 2011 21:58:31 -0500
Message-ID: <20110221025831.GB23822@thunk.org>
References: <1296579401-27203-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53403 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524Ab1BUDe2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Feb 2011 22:34:28 -0500
Content-Disposition: inline
In-Reply-To: <1296579401-27203-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, merged into the next branch.

-- Ted

On Tue, Feb 01, 2011 at 05:56:41PM +0100, Lukas Czerner wrote:
> It is not true that 'nodiscard' is set as default, so remove this
> sentence. The default is 'discard' and it is properly documented in man
> page.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

