From: supersud501 <supersud501@yahoo.de>
Subject: Re: e2fsck (git) on ext4: unsupported feature(s): huge_file
Date: Wed, 09 Apr 2008 20:12:52 +0200
Message-ID: <47FD0724.4060307@yahoo.de>
References: <47FBB24D.90807@yahoo.de> <47FBBB13.7060501@redhat.com> <47FBCB44.1050500@yahoo.de> <20080408210048.GA16108@mit.edu> <47FC892C.5080000@yahoo.de> <20080409161117.GB26924@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from n44.bullet.mail.ukl.yahoo.com ([87.248.110.177]:41153 "HELO
	n44.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751634AbYDIStd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Apr 2008 14:49:33 -0400
In-Reply-To: <20080409161117.GB26924@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> That patch which I just sent out passes the regression test suite, but
> it hasn't been extensively tested for actual *huge* files.
> (Specifically, files with the EXT4_HUGE_FILE_FL because they are
> larger than 2TB and so i_blocks had to be specified in units of
> filesystem blocksize, instead of units of 512 bytes.)
> 
> If you could apply the patch I just sent out and then run "e2fsck -nf
> /dev/sdXXX" and let me know you get, that would be much appreciated.
> 


with this patch (and huge_files enabled) i get much more errors 
(>1000++) of the following type:

inode x, i_blocks is y, should be y/8
inoda x+1, iblocks is z, should be z/8
.....

for example:

Inode 32538663, i_blocks is 8, should be 1.  Fix? no
Inode 32538664, i_blocks is 8, should be 1.  Fix? no
Inode 32538665, i_blocks is 8, should be 1.  Fix? no
Inode 32538666, i_blocks is 40, should be 5.  Fix? no
Inode 32538667, i_blocks is 32, should be 4.  Fix? no
Inode 32538668, i_blocks is 8, should be 1.  Fix? no
Inode 32538669, i_blocks is 8, should be 1.  Fix? no
Inode 32538670, i_blocks is 8, should be 1.  Fix? no
....
Inode 32587785, i_blocks is 17320, should be 2165.  Fix? no
Inode 32587786, i_blocks is 16936, should be 2117.  Fix? no
Inode 32587787, i_blocks is 120, should be 15.  Fix? no 
<------------ there are also gaps, not always x+1
Inode 32604181, i_blocks is 8, should be 1.  Fix? no
Inode 32604161, i_blocks is 18624, should be 2328.  Fix? no
Inode 32604162, i_blocks is 19400, should be 2425.  Fix? no
Inode 32604163, i_blocks is 18800, should be 2350.  Fix? no
Inode 32604164, i_blocks is 16488, should be 2061.  Fix? no
Inode 32604165, i_blocks is 17832, should be 2229.  Fix? no
Inode 32604166, i_blocks is 17880, should be 2235.  Fix? no
Inode 32604167, i_blocks is 20560, should be 2570.  Fix? no
Inode 32604168, i_blocks is 20480, should be 2560.  Fix? no
Inode 32604169, i_blocks is 18224, should be 2278.  Fix? no

not good?

