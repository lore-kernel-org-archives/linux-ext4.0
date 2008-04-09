From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: e2fsck (git) on ext4: unsupported feature(s): huge_file
Date: Wed, 9 Apr 2008 14:59:38 -0400
Message-ID: <20080409185938.GE26924@mit.edu>
References: <47FBB24D.90807@yahoo.de> <47FBBB13.7060501@redhat.com> <47FBCB44.1050500@yahoo.de> <20080408210048.GA16108@mit.edu> <47FC892C.5080000@yahoo.de> <20080409161117.GB26924@mit.edu> <47FD02A6.9090708@yahoo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: supersud501 <supersud501@yahoo.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:58742 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756939AbYDITAG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Apr 2008 15:00:06 -0400
Content-Disposition: inline
In-Reply-To: <47FD02A6.9090708@yahoo.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 09, 2008 at 07:53:42PM +0200, supersud501 wrote:
> Theodore Tso wrote:
>> That patch which I just sent out passes the regression test suite, but
>> it hasn't been extensively tested for actual *huge* files.
>> (Specifically, files with the EXT4_HUGE_FILE_FL because they are
>> larger than 2TB and so i_blocks had to be specified in units of
>> filesystem blocksize, instead of units of 512 bytes.)
>> If you could apply the patch I just sent out and then run "e2fsck -nf
>> /dev/sdXXX" and let me know you get, that would be much appreciated.
>
> I'll do when the patch arrives in git (or where do i get it from?)

I mailed it to the linux-ext4 list for reiview, I'll send it to you
directly.

> Yeah, i'm getting some (~80) errors about i blocks being wrong (besides 
> errors that a fast symlink has extents_fl set), and the error is always 
> from the type: "i_blocks is x, should be x+8", so it always wants to add 8 
> to the existing number. is this the mentioned miscalculation?

x+8, or x*8?  I would have expected the latter.

> so i wonder why the flag is set on my drive and if the i_blocks errors i 
> get are because of some miscalculation (which shouldn't happen, because i 
> have no huge files, right?) or really are some errors (but it's weird 
> e2fsck wants to set them always to x+8). doesn't make much sense to me yet.


Using debugfs, can you use the stat command to dump out the inode, and
send the results?

i.e., if you get the message:

Inode 45994, i_blocks is 24, should be 192.  Fix? no

Then when you use debugfs, you might see:

debugfs 1.40.8 (13-Mar-2008)
debugfs:  features
Filesystem features: has_journal resize_inode dir_index filetype sparse_super large_file huge_file
debugfs:  stat <45994>
Inode: 45994   Type: regular    Mode:  0644   Flags: 0x0   Generation: 124890615
User:     0   Group:     0   Size: 90118
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 24
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x47ddb871 -- Sun Mar 16 20:16:49 2008
atime: 0x47fbd5d3 -- Tue Apr  8 16:30:11 2008
mtime: 0x47dca16f -- Sun Mar 16 00:26:23 2008
BLOCKS:
(0-11):140798-140809, (IND):140810, (12-22):140811-140821
TOTAL: 24

So with the huge file, note the Blockcount (i_blocks) of 24, and that
debugfs reports the total number of blocks is 24.  

Without the huge_file feature, you'll see this:

debugfs 1.40.8 (13-Mar-2008)
debugfs:  features
Filesystem features: has_journal resize_inode dir_index filetype sparse_super large_file
debugfs:   stat <45994>
Inode: 45994   Type: regular    Mode:  0644   Flags: 0x0   Generation: 124890615
User:     0   Group:     0   Size: 90118
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 192
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x47ddb871 -- Sun Mar 16 20:16:49 2008
atime: 0x47fbd5d3 -- Tue Apr  8 16:30:11 2008
mtime: 0x47dca16f -- Sun Mar 16 00:26:23 2008
BLOCKS:
(0-11):140798-140809, (IND):140810, (12-22):140811-140821
TOTAL: 24

Note that the blockcount (i.e., i_blocks) is 192 blocks (in Single
Unix Specification legacy 512-byte units).  Since this filesystem is
using a 4k filesystem blocksize, and there are 8 legacy SuS blocks per
filesystem block, when you take the 192 blockcount, and divide by 8,
you get 24 blocks --- which matches with the "TOTAL: 24" display.

       	   	 	      	  	  - Ted
