From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Don't dereference NULL upon slashless module
	dependency line.
Date: Sun, 8 Mar 2009 20:41:09 -0400
Message-ID: <20090309004109.GD9903@mit.edu>
References: <87fxi5dt0g.fsf@meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jim Meyering <jim@meyering.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44157 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432AbZCIDPn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 Mar 2009 23:15:43 -0400
Content-Disposition: inline
In-Reply-To: <87fxi5dt0g.fsf@meyering.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 23, 2009 at 05:20:47PM +0100, Jim Meyering wrote:
> 
> * probe.c (check_for_modules): Skip current line if it has no slash.

Thanks for pointing this out; I've used Eric's patch to fix this
issue.

						- Ted
