From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC PATCH 7/9][e2fsprogs] Add new blk64_t handling inline
	functions
Date: Mon, 12 May 2008 15:22:52 -0400
Message-ID: <20080512192252.GI7029@mit.edu>
References: <20080509163928.15484.22146.stgit@gara> <20080509164012.15484.60952.stgit@gara> <20080512144903.GE7029@mit.edu> <20080512122521.4f9b270e@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:44336 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752284AbYELTXG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 May 2008 15:23:06 -0400
Content-Disposition: inline
In-Reply-To: <20080512122521.4f9b270e@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 12, 2008 at 12:25:21PM -0500, Jose R. Santos wrote:
> 
> I agree that making the not inline is the right thing to do, but now
> the question is where do we put these new functions.  Is it still
> appropriate to place them in ext2fs.h or do you prefer a new location?

Once they are no longer non-inline functions they obviously shouldnt
go in ext2fs.h.  So it would probably have to be a new file, maybe
miscfuncs.c or some such in lib/ext2fs.

					- Ted
