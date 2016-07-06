From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] fuse2fs: needs SYSLIBS
Date: Tue, 5 Jul 2016 23:03:20 -0400
Message-ID: <20160706030320.GN15193@thunk.org>
References: <1466639933-8892-1-git-send-email-gustavo@zacarias.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Gustavo Zacarias <gustavo@zacarias.com.ar>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46630 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbcGFDDW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Jul 2016 23:03:22 -0400
Content-Disposition: inline
In-Reply-To: <1466639933-8892-1-git-send-email-gustavo@zacarias.com.ar>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 22, 2016 at 08:58:53PM -0300, Gustavo Zacarias wrote:
> It otherwise leads to build failure when using an unbundled libintl.
> 
> Signed-off-by: Gustavo Zacarias <gustavo@zacarias.com.ar>

Thanks, applied.

						- Ted
