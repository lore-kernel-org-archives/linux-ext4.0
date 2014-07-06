From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] mke2fs: add get_uint_from_profile to mke2fs.c
Date: Sat, 5 Jul 2014 22:35:11 -0400
Message-ID: <20140706023511.GF19036@thunk.org>
References: <28989C0C9F1C0A428470D967B5FCED372A7E91@BPXM22GP.gisp.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47181 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbaGFCfP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Jul 2014 22:35:15 -0400
Content-Disposition: inline
In-Reply-To: <28989C0C9F1C0A428470D967B5FCED372A7E91@BPXM22GP.gisp.nec.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 11, 2014 at 08:37:54AM +0000, Akira Fujita wrote:
> We can set flex_bg count only up to 2^30 with profile
> because get_int_from_profile can handle it to 2^31-1.
> Add get_uint_from_profile to read unsigned int value
> so that mke2fs with profile can handle up to 2^31 flex_bg same as -G option.
> 
> Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>

Thanks, applied.

						- Ted
