From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC] Add new "development flag" to the ext4 filesystem
Date: Wed, 23 Jan 2008 11:04:35 -0600
Message-ID: <479773A3.9000106@redhat.com>
References: <20080122231707.GA21968@mit.edu> <4796BAB9.7000502@redhat.com> <20080123165307.GA32663@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbYAWRE6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jan 2008 12:04:58 -0500
In-Reply-To: <20080123165307.GA32663@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:

> If we do that, then the only downside of having ext3 filesystems run
> under ext4 is the test matrix concern.  Since I'm still hoping that
> some point in the future, fs/ext4 could subsume fs/ext3 so we don't
> have to worry about bug fixes going into fs/ext2 AND fs/ext3 AND
> fs/ext4, I have my own reasons for wanting that.  But I do understand
> the concerns that maybe in the short term some distro's don't want to
> do that.  So in that case I could see adding a "you must have extents"
> test into ext4, if I distro has specific support concerns. But for
> people who are running mainline kernel, I think it's actually a *good*
> thing if fs/ext4 can mount and read and write to an ext3 filesystem
> --- as long as it doesn't automatically turn on features behind the
> user's back.

Well, sure, the ability of ext4 code to mount,read,write ext3
filesystems is fine, esp. if ext4.ko stops doing things which makes it
hard to go back to ext3.  And, I do like the long-term plan of ext4
replacing ext3, it's a bit of a pain to keep this all in sync.

I just think that ext4.ko running ext3 filesystems needs to be under
explicit control, and not something that happens, occasionally,
accidentally, without the user/administrator requesting it.  Least
surprise, and all that...

-Eric
