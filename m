From: supersud501 <supersud501@yahoo.de>
Subject: Re: e2fsck (git) on ext4: unsupported feature(s): huge_file
Date: Wed, 09 Apr 2008 19:53:42 +0200
Message-ID: <47FD02A6.9090708@yahoo.de>
References: <47FBB24D.90807@yahoo.de> <47FBBB13.7060501@redhat.com> <47FBCB44.1050500@yahoo.de> <20080408210048.GA16108@mit.edu> <47FC892C.5080000@yahoo.de> <20080409161117.GB26924@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from n29.bullet.mail.ukl.yahoo.com ([87.248.110.146]:47881 "HELO
	n29.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755482AbYDISIi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Apr 2008 14:08:38 -0400
In-Reply-To: <20080409161117.GB26924@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> 
> That patch which I just sent out passes the regression test suite, but
> it hasn't been extensively tested for actual *huge* files.
> (Specifically, files with the EXT4_HUGE_FILE_FL because they are
> larger than 2TB and so i_blocks had to be specified in units of
> filesystem blocksize, instead of units of 512 bytes.)
> 
> If you could apply the patch I just sent out and then run "e2fsck -nf
> /dev/sdXXX" and let me know you get, that would be much appreciated.
> 

I'll do when the patch arrives in git (or where do i get it from?)

> In answer to question of how to determine if you actually *have* any
> large files, the simplest thing to do is to use debugfs to temporarily
> remove huge_file feature:
> 
> debugfs -w /dev/sdXXX               <------- disable the huge_file feature
> debugfs: features ^huge_file
> debugfs: quit
> 
> e2fsck -nf /dev/sdXXX
> 
> debugfs -w /dev/sdXXX               <------- re-enable the huge_file feature
> debugfs: features huge_file
> debugfs: quit
> 
> If you see error messages about i_blocks values being wrong (with the
> huge_file feature disabled), then the inodes that are referenced are
> the ones that have the huge_file flag set.
> 

Yeah, i'm getting some (~80) errors about i blocks being wrong (besides 
errors that a fast symlink has extents_fl set), and the error is always 
from the type: "i_blocks is x, should be x+8", so it always wants to add 
8 to the existing number. is this the mentioned miscalculation?

however, as i read in the mail from eric, i didn't know that there is a 
difference between "large" and "huge" files and apparently meant "large" 
(>2gb) files. i've got no "huge" (~2TB) files on my drive (and never had).

so i wonder why the flag is set on my drive and if the i_blocks errors i 
get are because of some miscalculation (which shouldn't happen, because 
i have no huge files, right?) or really are some errors (but it's weird 
e2fsck wants to set them always to x+8). doesn't make much sense to me yet.

oh and: thanks for getting into my problem and trying to help me!

