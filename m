From: Andreas Friedrich Berendsen <afberendsen@gmail.com>
Subject: Re: kernel BUG at fs/ext4/extents.c:2738!
Date: Sun, 22 Feb 2009 17:21:59 +1300
Message-ID: <1235276519.7599.7.camel@localhost.localdomain>
References: <1235115642.22702.2.camel@localhost.localdomain>
	 <499ECF5C.7020509@redhat.com>
	 <1235155713.22702.25.camel@localhost.localdomain>
	 <20090220193013.GA28530@mini-me.lan>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.184]:42335 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbZBVEWL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 21 Feb 2009 23:22:11 -0500
Received: by ti-out-0910.google.com with SMTP id d10so1058342tib.23
        for <linux-ext4@vger.kernel.org>; Sat, 21 Feb 2009 20:22:09 -0800 (PST)
In-Reply-To: <20090220193013.GA28530@mini-me.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Tso,

I used fsck many times but an error as identified at a certain block and
fsck was aborting with a Segment fault error. I had to fix all the
errors manually (not using -p or -y), skipping this specific problem.

After that I used reszie2fs -pM for just the first step. Mounting the
filesystem, removing many files (which triggered the BUG), I was able to
run fsck with -y many times.

Anyway, the problem seems to be under control but I'm not sure. The new
kernel (2.6.28.7) has a long list of ext4 errors corrected and I'm
compiling it right now. Let's see what happens next :)

Thanks anyway

-- Andreas


-----Original Message-----
From: Theodore Tso <tytso@mit.edu>
To: Andreas Friedrich Berendsen <afberendsen@gmail.com>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
Bcc: tytso@mit.edu
Subject: Re: kernel BUG at fs/ext4/extents.c:2738!
Date: Fri, 20 Feb 2009 14:30:13 -0500

On Sat, Feb 21, 2009 at 07:48:32AM +1300, Andreas Friedrich Berendsen wrote:
> ...I haven't noticed  before, but before that message few more lines
> where recorded, which makes sense with the BUG line. Also, running
> fsck.ext4 on that filesystem I always got a Segment fault at an specific
> point, which it is impossible to fix. I'm in a process to remove files
> from that filesystem, as soon it finish I can run fsck again and send
> the result. Meanwhile, when removing files, rm stuck at a certain inode,
> which caused the first BUG message.

Have you tried running e2fsck?  It sounds like a filesystem corruption
is triggering a BUG() message, which is obviously a bug in and of
itself.  :-)

						- Ted

-- 
__________________________________________
Andreas Friedrich Berendsen
SCA OCP MSCA A+ Linux+ Network+ HpMASE

