From: tytso@mit.edu
Subject: Re: [PATCH 2/3]ext4: Initialize moved_len before calling
 ext4_move_extents()
Date: Tue, 24 Nov 2009 10:31:22 -0500
Message-ID: <20091124153122.GK2183@thunk.org>
References: <4B03A192.5000201@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:42716 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757477AbZKXPbT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Nov 2009 10:31:19 -0500
Content-Disposition: inline
In-Reply-To: <4B03A192.5000201@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 18, 2009 at 04:26:10PM +0900, Akira Fujita wrote:
> ext4: initialize moved_len before calling ext4_move_extents()
> 
> From: Kazuya Mio <k-mio@sx.jp.nec.com>
> 
> moved_len of struct move_extent is used to notify
> exchanged blocks count to the user space.
> So at the beginning of the EXT4_IOC_MOVE_EXT,
> moved_len should be always zero.
> Without this patch, if wrong moved_len is passed from the user space,
> EXT4_IOC_MOVE_EXT will return wrong blocks count.

Applied with the following rewording of the patch description:

ext4: initialize moved_len before calling ext4_move_extents()

From: Kazuya Mio <k-mio@sx.jp.nec.com>

The move_extent.moved_len is used to pass back the number of exchanged
blocks count to user space.  Currently the caller must clear this
field; but we spend more code space checking for this requirement than
simply zeroing the field ourselves, so let's just make life easier for
everyone all around.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
