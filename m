From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4: ext23 support leaks buffer pages
Date: Mon, 10 Jan 2011 12:52:34 -0500
Message-ID: <20110110175234.GD3128@thunk.org>
References: <alpine.LSU.2.00.1101100242530.2000@sister.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Amir Goldstein <amir73il@users.sf.net>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Hugh Dickins <hughd@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:45448 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358Ab1AJRwn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Jan 2011 12:52:43 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1101100242530.2000@sister.anvils>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 10, 2011 at 02:54:26AM -0800, Hugh Dickins wrote:
> I switched to CONFIG_EXT4_USE_FOR_EXT23=y with 2.6.37, but was
> then surprised by OOM kills: 2.6.36 and current are also bad.

Oops.  Yeah, the problem was when ext4_forget() was moved out of
ext4_free_branches, we needed to replace it with a call to brelse().
Thanks for pointing this out.

Patch follows...

					- Ted
