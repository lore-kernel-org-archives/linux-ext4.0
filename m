From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Re: 64-bit e2fsprogs patch queue
Date: Fri, 6 Feb 2009 20:10:03 -0500
Message-ID: <20090207011003.GA18400@shell>
References: <20090203155231.GP14762@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbZBGBKJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Feb 2009 20:10:09 -0500
Content-Disposition: inline
In-Reply-To: <20090203155231.GP14762@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 03, 2009 at 10:52:31AM -0500, Theodore Tso wrote:
> I thought you were out due to your shoulder surgery, so I've already
> rebased your patches; to see what I've done, take a look at:
> 
> 	http://github.com/tytso/e2fsprogs-64bit/tree/master
> 	git://github.com/tytso/e2fsprogs-64bit.git

[Instructions for applying these patches with guilt]

I've exported the rebased series as a git branch in my repo:

git://git.kernel.org/pub/scm/fs/ext2/val/e2fsprogs.git

Branch "shared-64bit".

The commit that introduces the failing regression test is:

commit de119e26eb2cf041a8365994dc3a32efc080682e
Author: Valerie Aurora Henson <vaurora@redhat.com>
Date:   Tue Feb 3 13:15:19 2009 -0800

    e2fsck: Miscellaneous e2fsck-related 64-bit fixes.
    
    With this change, e2fsck runs to completion on a minimal 33-bit file system.
    
    Signed-off-by: Valerie Aurora Henson <vaurora@redhat.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

I won't be able to get to this for another week or so, so if anyone
else wants to take a whack at it, I'd be grateful.

-VAL
