From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/6] ext4: Pack ioend structure better
Date: Tue, 8 Mar 2016 22:39:01 -0500
Message-ID: <20160309033901.GA3150@thunk.org>
References: <1455897582-13292-1-git-send-email-jack@suse.cz>
 <1455897582-13292-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49116 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbcCIDjG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Mar 2016 22:39:06 -0500
Content-Disposition: inline
In-Reply-To: <1455897582-13292-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 19, 2016 at 04:59:37PM +0100, Jan Kara wrote:
> On 64-bit architectures we have two 4-byte holes in struct ext4_io_end.
> Order entries better to avoid this and thus make the structure occupy
> 64 instead of 72 bytes for 64-bit architectures.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
