From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC PATCH 7/9][e2fsprogs] Add new blk64_t handling inline
	functions
Date: Mon, 12 May 2008 10:49:03 -0400
Message-ID: <20080512144903.GE7029@mit.edu>
References: <20080509163928.15484.22146.stgit@gara> <20080509164012.15484.60952.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:45063 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751897AbYELOtE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 May 2008 10:49:04 -0400
Content-Disposition: inline
In-Reply-To: <20080509164012.15484.60952.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 09, 2008 at 11:40:12AM -0500, Jose R. Santos wrote:
> From: Jose R. Santos <jrs@us.ibm.com>
> 
> Add new blk64_t handling inline functions
> 
> Introduce inline fuctions to handle blk64_t and low/high values in
> super blocks and inodes.

If you do this patch first, then you can address some of the FIXME's
earlier in the patch series...

And as I mentioned, we probably want to avoid making them INLINE
functions.  It's always easier to inline a function later if we find
that it shows up on profiles for performance reasons, but if we find
out we need to make changes and it is inline already, it's much harder
to deal with the backwards compatibility issues.

						- Ted
