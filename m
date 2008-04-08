From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsck (git) on ext4: unsupported feature(s): huge_file
Date: Tue, 8 Apr 2008 17:00:48 -0400
Message-ID: <20080408210048.GA16108@mit.edu>
References: <47FBB24D.90807@yahoo.de> <47FBBB13.7060501@redhat.com> <47FBCB44.1050500@yahoo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: supersud501 <supersud501@yahoo.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:47608 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752808AbYDHVBS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Apr 2008 17:01:18 -0400
Content-Disposition: inline
In-Reply-To: <47FBCB44.1050500@yahoo.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 08, 2008 at 09:45:08PM +0200, supersud501 wrote:
> Eric Sandeen wrote:
>> supersud501 wrote:
>>> i get this when trying to run e2fsck on my ext4dev filesystem (kernel 
>>> 2.6.25-rc8), extents enabled:
>>>
>>> e2fsck 1.40.8 (13-Mar-2008)
>>> /dev/loop2 has unsupported feature(s): huge_file
>>> e2fsck: Get a newer version of e2fsck!
>>>
>>> just updated to the git-version of e2fsprogs, same error. i know e2fsck 
>>> worked once with the drive (~2 months ago).
>>>
>>> what can i do?
>> Do you in fact have any very large files on the disk?
>
> yeah, i have (> 5.5gb).
>
> i know it worked a few months (1-2) ago, even with extents enabled. at this 
> time there where those large files too.

The old 1.39-interim-tyt3 e2fsprogs patch claimed it supported huge
files, but it didn't, actually.  It lied.  :-(

(So if you needed to repair a filesystem, e2fsck would screw up the
i_blocks field.)

I'm working on fixing that.

					- Ted
