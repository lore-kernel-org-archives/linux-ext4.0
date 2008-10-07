From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH][0/15] Lustre e2fsprogs patch series
Date: Tue, 7 Oct 2008 10:22:21 -0400
Message-ID: <20081007142221.GC7311@mit.edu>
References: <1223287812.4007.55.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Kalpak Shah <Kalpak.Shah@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:38489 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753370AbYJGOWY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Oct 2008 10:22:24 -0400
Content-Disposition: inline
In-Reply-To: <1223287812.4007.55.camel@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 06, 2008 at 03:40:12PM +0530, Kalpak Shah wrote:
> 
> This is the patchset containing the e2fsprogs patches that are used for
> Lustre e2fsprogs. The patches are based on e2fsprogs-1.41.2.
> 

Um, are you sure that the patches are based on e2fsprogs 1.41.2?  I
just tried applying e2fsprogs-fiemap.patch, and it did not apply
cleanly.  Looking at the rejects, it looks like part of the problem
was that patch was apparently against the version of filefrag that was
in v1.41.0, not v1.41.1 or v1.41.2?

						- Ted
