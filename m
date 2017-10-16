From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] debugfs: print "Xst" bits of file mode via stat
Date: Sun, 15 Oct 2017 22:27:58 -0400
Message-ID: <20171016022758.35wh7jw5vh4q7ezw@thunk.org>
References: <1507675130-69955-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49694 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751708AbdJPC2B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 15 Oct 2017 22:28:01 -0400
Content-Disposition: inline
In-Reply-To: <1507675130-69955-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 10, 2017 at 04:38:50PM -0600, Andreas Dilger wrote:
> Currently, debugfs does not print the Xst high-order mode bits
> in the "stat" output.  While "ls -l" shows these bits are set:
> 
>   # ls -il /mnt/tmp/O/0/d2/406306
>   1588 0 -rwSrwSrw- 1 root root 0 Dec 31  1969 /mnt/tmp/O/0/d2/406306
> 
> debugfs currently only prints the low nine "ugo" mode bits:
> 
>   # debugfs -c -R "stat O/0/d2/406306" /dev/vgmyth/lvmythost4
>   Inode: 1588   Type: regular    Mode:  0666   Flags: 0x80000
> 
> Fix debugfs so that the high-order mode bits are also printed,
> if available, otherwise only print the standard low mode bits.
> 
>   # debugfs -c -R "stat O/0/d2/406306" /dev/vgmyth/lvmythost4
>   Inode: 1588   Type: regular    Mode:  06666   Flags: 0x80000
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

					- Ted
