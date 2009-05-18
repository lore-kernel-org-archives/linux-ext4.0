From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] down i_data_sem only for read when walking tree for
	fiemap
Date: Sun, 17 May 2009 23:37:03 -0400
Message-ID: <20090518033703.GG32019@mit.edu>
References: <4A0DD994.1090200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49681 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbZERDhH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 May 2009 23:37:07 -0400
Content-Disposition: inline
In-Reply-To: <4A0DD994.1090200@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 15, 2009 at 04:07:32PM -0500, Eric Sandeen wrote:
> Not sure why I put this in as down_write originally; all we are
> doing is walking the tree, nothing will change under us and
> concurrent reads should be no problem.

Applied, thanks.

					- Ted
