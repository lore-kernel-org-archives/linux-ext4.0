From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs/filefrag: print shared extent flag
Date: Sat, 26 Apr 2014 20:24:03 -0400
Message-ID: <20140427002403.GB25172@thunk.org>
References: <20140417214146.GD27178@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
To: Mark Fasheh <mfasheh@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34756 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbaD0AYF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Apr 2014 20:24:05 -0400
Content-Disposition: inline
In-Reply-To: <20140417214146.GD27178@wotan.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 17, 2014 at 02:41:46PM -0700, Mark Fasheh wrote:
> Filefrag doesn't catch and print the shared extent flag. Add this for
> users of filefrag on file systems with shared extents (such as btrfs).
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>

Thanks, applied.

					- Ted
