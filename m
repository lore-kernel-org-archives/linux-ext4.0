From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V5 00/23] ext4: Add inline data support.
Date: Tue, 14 Aug 2012 11:19:26 -0400
Message-ID: <20120814151926.GA19364@thunk.org>
References: <1341070917-4889-1-git-send-email-tm@tao.ma>
 <20120813150445.GC13072@thunk.org>
 <5029F88F.7090106@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44652 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380Ab2HNPTd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Aug 2012 11:19:33 -0400
Content-Disposition: inline
In-Reply-To: <5029F88F.7090106@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 14, 2012 at 03:04:47PM +0800, Tao Ma wrote:
> As andreas said in another e-mail, that would make the codes a little
> complex. So in general, in my previous version, I just tried to refactor
> most of the codes so that they can work for both inline inode and dir
> blocks. But if these changes are merged, we have to re-write all of the
> codes that are currently shared, such as ext4_find_entry, empty_dir,
> ext4_add_entry etc.

Well, we may not need to rewrite as much as you think.  For one thing,
as I mentioned, I don't think the VFS passes '.' and '..' lookup
requests down to the file system anyway, and even if it did, you could
just have a function which checks for '.' and '..' and returns the
correct value if necessary.  So I think you wouldn't need to rewrite
all of these functions, since the fundamental layout of the directory
wouldn't be changing.  It's just that we're skipping the '.' and '..'
entries, and the "standard" directory layout would be starting 4 bytes
later (after the '..' inode number).

So it's probably worth taking a look to see how much of an increase in
complexity would actually be involved.

Regards,

					- Ted
