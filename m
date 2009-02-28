From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [GIT PULL] ext4 fixes
Date: Sat, 28 Feb 2009 09:41:16 -0600
Message-ID: <49A95B1C.9060008@redhat.com>
References: <E1LdQQ5-0004kd-OD@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57727 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbZB1PmA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Feb 2009 10:42:00 -0500
In-Reply-To: <E1LdQQ5-0004kd-OD@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> Hi Linus,
> 
> Please pull from:
> 
>         git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus
> 
> to grab two two more bug fixes for ext4.  Thanks!!
> 
>                                                 - Ted
> 
> Theodore Ts'o (2):
>       ext4: Remove duplicate call to ext4_commit_super() in ext4_freeze()
>       ext4: Reorder fs/Makefile so that ext2 root fs's are mounted using ext2
> 
>  fs/Makefile     |    6 ++++--
>  fs/ext4/super.c |    1 -
>  2 files changed, 4 insertions(+), 3 deletions(-)

Ted, might be good to get my nojournal fix in too?  It's an easy oopser.

-Eric
