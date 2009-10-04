From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] debugfs: add matching fclose
Date: Sat, 3 Oct 2009 22:30:58 -0400
Message-ID: <20091004023058.GF15688@mit.edu>
References: <1254135113-28212-1-git-send-email-bergwolf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52849 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874AbZJDCbf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 3 Oct 2009 22:31:35 -0400
Content-Disposition: inline
In-Reply-To: <1254135113-28212-1-git-send-email-bergwolf@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 28, 2009 at 06:51:53PM +0800, Peng Tao wrote:
> If the cmd_file is not stdin, we should close the file handle via fclose().
> Thanks David Binderman to point this out.
> 
> Addresses-Novell-Bugzilla: #524526
> 
> Signed-off-by: Peng Tao <bergwolf@gmail.com>

Applied to the maint branch, thanks.

					- Ted
