From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: e2fsck (git) on ext4: unsupported feature(s): huge_file
Date: Wed, 9 Apr 2008 12:11:17 -0400
Message-ID: <20080409161117.GB26924@mit.edu>
References: <47FBB24D.90807@yahoo.de> <47FBBB13.7060501@redhat.com> <47FBCB44.1050500@yahoo.de> <20080408210048.GA16108@mit.edu> <47FC892C.5080000@yahoo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: supersud501 <supersud501@yahoo.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61029 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752980AbYDIQLl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Apr 2008 12:11:41 -0400
Content-Disposition: inline
In-Reply-To: <47FC892C.5080000@yahoo.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 09, 2008 at 11:15:24AM +0200, supersud501 wrote:
>
> ah ok, so i know what's up - seems i've to wait until fixing it. just 
> wanted to do it, because syslog said "maximum mount time reached, running 
> is recommended". so no need to hurry ;)

That patch which I just sent out passes the regression test suite, but
it hasn't been extensively tested for actual *huge* files.
(Specifically, files with the EXT4_HUGE_FILE_FL because they are
larger than 2TB and so i_blocks had to be specified in units of
filesystem blocksize, instead of units of 512 bytes.)

If you could apply the patch I just sent out and then run "e2fsck -nf
/dev/sdXXX" and let me know you get, that would be much appreciated.

In answer to question of how to determine if you actually *have* any
large files, the simplest thing to do is to use debugfs to temporarily
remove huge_file feature:

debugfs -w /dev/sdXXX               <------- disable the huge_file feature
debugfs: features ^huge_file
debugfs: quit

e2fsck -nf /dev/sdXXX

debugfs -w /dev/sdXXX               <------- re-enable the huge_file feature
debugfs: features huge_file
debugfs: quit

If you see error messages about i_blocks values being wrong (with the
huge_file feature disabled), then the inodes that are referenced are
the ones that have the huge_file flag set.

						- Ted
