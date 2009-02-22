From: Andreas Friedrich Berendsen <afberendsen@gmail.com>
Subject: Re: kernel BUG at fs/ext4/extents.c:2738!
Date: Sun, 22 Feb 2009 18:22:21 +1300
Message-ID: <1235280141.7599.37.camel@localhost.localdomain>
References: <1235115642.22702.2.camel@localhost.localdomain>
	 <499ECF5C.7020509@redhat.com>
	 <1235155713.22702.25.camel@localhost.localdomain>
	 <20090220193013.GA28530@mini-me.lan>
	 <1235276519.7599.7.camel@localhost.localdomain>
	 <20090222043126.GE17066@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.185]:38902 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZBVFWy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 22 Feb 2009 00:22:54 -0500
Received: by ti-out-0910.google.com with SMTP id d10so1066845tib.23
        for <linux-ext4@vger.kernel.org>; Sat, 21 Feb 2009 21:22:52 -0800 (PST)
In-Reply-To: <20090222043126.GE17066@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Tso,

If you look my previous e-mails, you will see that I included an output
fro my fsck program, which is version 1.41.4 (second output bewlo):

# fsck
fsck 1.41.4 (27-Jan-2009)
e2fsck 1.41.4 (27-Jan-2009)

My first action when the problem happened was to check the efsprog page,
new kernel version (chancgelog), Google (of course), and friends. After
all those resources where exausted I decided to send a message to this
e-mail group.

Right now, after running efsck.ext4 program many times over that
filesystem, seems that no corruptions where identified.

-- Andreas

-----Original Message-----
From: Theodore Tso <tytso@mit.edu>
To: Andreas Friedrich Berendsen <afberendsen@gmail.com>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
Bcc: tytso@mit.edu
Subject: Re: kernel BUG at fs/ext4/extents.c:2738!
Date: Sat, 21 Feb 2009 23:31:26 -0500

On Sun, Feb 22, 2009 at 05:21:59PM +1300, Andreas Friedrich Berendsen wrote:
> Tso,
> 
> I used fsck many times but an error as identified at a certain block and
> fsck was aborting with a Segment fault error. I had to fix all the
> errors manually (not using -p or -y), skipping this specific problem.

What version of e2fsck were you using, and what was the failure?
*Please* don't ignore stuff like this.  Report it, and mention it when
you report kernel problems.  It really helps get to the bottom of
things.

I'm going to guess you were using something older than e2fsprogs
1.41.4, and you were running into the bug which was fixed in this
e2fsprogs commit.

commit 7518c176867099eb529502103106501861a71280
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Dec 25 22:42:38 2008 -0500

    e2fsck: Fix an unhandled corruption case in scan_extent_node()
    
    A corrupted interior node in an extent tree would cause e2fsck to
    crash with the error message:
    
    Error1: Corrupt extent header on inode 107192
    Aborted (core dumped)
    
    Handle this and related failures when scanning an inode's extent tree
    more robustly.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>


A corrupted extent could very easily have explained the symptoms you
reported.  (No, the kernel still shouldn't have flagged a BUG(), but
the fact of the matter is the filesystme was corrupted.)

> Anyway, the problem seems to be under control but I'm not sure. The new
> kernel (2.6.28.7) has a long list of ext4 errors corrected and I'm
> compiling it right now. Let's see what happens next :)

I'd recommend making sure you're running the latest version of
e2fsprogs and use e2fsck to make sure the filesystem is fully
consistent.

If e2fsck ever core dumps, please report it as a bug.  The e2fsck man
page has a section, REPORTING BUGS, that goes into details about how
to send a useful bug report about an e2fsck failure.

   	  	     	    	  - Ted
-- 
__________________________________________
Andreas Friedrich Berendsen
SCA OCP MSCA A+ Linux+ Network+ HpMASE

