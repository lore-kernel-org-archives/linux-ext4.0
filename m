From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] mke2fs: prevent creation of unmountable ext4 with
 large flex_bg count
Date: Sat, 5 Jul 2014 22:43:58 -0400
Message-ID: <20140706024358.GG19036@thunk.org>
References: <28989C0C9F1C0A428470D967B5FCED372A7EA3@BPXM22GP.gisp.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47188 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbaGFCn7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Jul 2014 22:43:59 -0400
Content-Disposition: inline
In-Reply-To: <28989C0C9F1C0A428470D967B5FCED372A7EA3@BPXM22GP.gisp.nec.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 11, 2014 at 08:38:10AM +0000, Akira Fujita wrote:
> In mke2fs command, if flex_bg count is too large to filesystem blocks count,
> unmountable ext4 which has the out of filesystem block offset is created (Case1).
> Moreover this large flex_bg count causes an unintentional metadata layout
> (bmap-imap-itable-bmap-imap-itable .. in block group) (Case2).
> 
> To fix these issues and keep healthy flex_bg layout, disallow creating ext4
> with obviously large flex_bg count to filesystem blocks count.

Applied, thanks.

							- Ted
