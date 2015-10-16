From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsprogs: Richacl support
Date: Fri, 16 Oct 2015 19:16:15 -0400
Message-ID: <20151016231615.GF15011@thunk.org>
References: <CAHc6FU5s7-t3+jtKDusVFqc542Ag7pEOTUqp1LSxg8_uCPyF=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Gruenbacher <agruenba@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55579 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbbJPXQS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Oct 2015 19:16:18 -0400
Content-Disposition: inline
In-Reply-To: <CAHc6FU5s7-t3+jtKDusVFqc542Ag7pEOTUqp1LSxg8_uCPyF=A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 16, 2015 at 06:03:29PM +0200, Andreas Gruenbacher wrote:
> 
> could the richacl feature flag please be added to e2fsprogs so that we
> won't end up with incompatible file systems?
> 
>   https://github.com/andreas-gruenbacher/e2fsprogs
> 
> Also, should this really be an incompatible feature flag? With a
> read-only compatibility flag, mounting a richacl filesystem on a
> kernel without richacl support would work but it's not safe --- it
> could grant unwanted access to files. (The same applies to the xfs
> support, etc.)

Richacl's are represented using just extended attributes, right?  So
why would this result in incompatible file systems?  For similar
reasons we never had a feature flag for Posix ACL's.

Suppose we mounted a file system with richacl's on a kernel that
didn't understand it, and we write to from that non-richacl kernel.
What's the worse that could happen?

					- Ted
					
