From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/4]ext4: Add null extent check to ext_get_path()
Date: Wed, 16 Sep 2009 14:18:20 -0400
Message-ID: <20090916181820.GE15451@mit.edu>
References: <4AADFC13.4070101@rs.jp.nec.com> <4AB09692.6070701@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37823 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbZIPSSS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Sep 2009 14:18:18 -0400
Content-Disposition: inline
In-Reply-To: <4AB09692.6070701@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 16, 2009 at 04:41:06PM +0900, Akira Fujita wrote:
> Hi Ted,
> 
> This is V2 patch.
> (I forgot to release path structure in error case. :-! )
> 
> Akira Fujita wrote:
> > ext4: Add null extent check to ext_get_path
> > 
> > From: Akira Fujita <a-fujita@rs.jp.nec.com>
> > 
> > There is the possibility that path structure which is taken
> > by ext4_ext_find_extent() indicates null extents.
> > Because during data block exchanging in ext4_move_extents(),
> > constitution of an extent tree may be changed.
> > As a solution, the patch adds null extent check
> > to ext_get_path().

Applied, thanks!

					- Ted
