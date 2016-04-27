From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove trailing \n from ext4_warning/ext4_error
 calls
Date: Wed, 27 Apr 2016 01:12:42 -0400
Message-ID: <20160427051242.GF30021@thunk.org>
References: <1460988589-8606-1-git-send-email-jwilk@jwilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: Jakub Wilk <jwilk@jwilk.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45926 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbcD0FMp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Apr 2016 01:12:45 -0400
Content-Disposition: inline
In-Reply-To: <1460988589-8606-1-git-send-email-jwilk@jwilk.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 18, 2016 at 04:09:49PM +0200, Jakub Wilk wrote:
> Messages passed to ext4_warning() or ext4_error() don't need trailing
> newlines, because these function add the newlines themselves.
> 
> Signed-off-by: Jakub Wilk <jwilk@jwilk.net>

Thanks, applied.

						- Ted
