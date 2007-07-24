From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 1/3] ext2: show all mount options
Date: Tue, 24 Jul 2007 07:11:19 +0200
Message-ID: <E1IDCg3-0007OH-00@dorka.pomaz.szeredi.hu>
References: <E1ID4H0-00065Q-00@dorka.pomaz.szeredi.hu> <20070723135642.9d87178a.akpm@linux-foundation.org> <20070723232110.GE30165@thunk.org>
Cc: akpm@linux-foundation.org, miklos@szeredi.hu,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:39467 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbXGXFLh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jul 2007 01:11:37 -0400
In-reply-to: <20070723232110.GE30165@thunk.org> (message from Theodore Tso on
	Mon, 23 Jul 2007 19:21:10 -0400)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> The idea is to allow /proc/mounts to display all of the mount options
> that were used to mount a particular filesystem.  This is useful if
> you want /proc/mounts to replace /etc/mtab.
> 
> I keep thinking that this is really the wrong approach, though, since
> it means adding a lot of coding to every single filesystem to
> reconstruct the mount options, and in some cases it will still never
> be enough to reconstruct exactly what was in /etc/mtab.  (For example,
> the fully qualified domain named passed into some remote filesystem.)
> 
> It seems to me the right answer would be to enhance the mount(2)
> system call with a new mount operation which would allow the user
> space mount command can stash exactly the options used to mount the
> filesystem.

Well, that would be good for emulating /etc/mtab.  But the problem is
that that's wrong a lot of times.  For example in ext* "mount
-oremount,opt" doesn't reset all options, it just changes "opt".  And
this is different from fs to fs, so there's no easy way to handle it
from generic code.

I think it shouln't be hard to keep the shown mount options in sync
with the parsed options.  The problem is just that people have been
lazy to do that, because /etc/mtab was good enough.

Miklos
