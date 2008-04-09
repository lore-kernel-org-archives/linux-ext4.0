From: supersud501 <supersud501@yahoo.de>
Subject: Re: e2fsck (git) on ext4: unsupported feature(s): huge_file
Date: Wed, 09 Apr 2008 21:19:56 +0200
Message-ID: <47FD16DC.1090502@yahoo.de>
References: <47FBB24D.90807@yahoo.de> <47FBBB13.7060501@redhat.com> <47FBCB44.1050500@yahoo.de> <20080408210048.GA16108@mit.edu> <47FC892C.5080000@yahoo.de> <20080409161117.GB26924@mit.edu> <47FD0724.4060307@yahoo.de> <20080409190634.GA9430@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from n20.bullet.mail.ukl.yahoo.com ([87.248.110.137]:42727 "HELO
	n20.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751432AbYDITbF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Apr 2008 15:31:05 -0400
In-Reply-To: <20080409190634.GA9430@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Wed, Apr 09, 2008 at 08:12:52PM +0200, supersud501 wrote:
>> with this patch (and huge_files enabled) i get much more errors (>1000++) 
>> of the following type:
>>
>> inode x, i_blocks is y, should be y/8
>> inoda x+1, iblocks is z, should be z/8
>> .....
>>
>> for example:
>>
>> Inode 32538663, i_blocks is 8, should be 1.  Fix? no
>> Inode 32538664, i_blocks is 8, should be 1.  Fix? no
> 
> Can you send me the output of debugfs's "stat <32538663>", "stat
> <32538664>", etc?   And also the output of dumpe2fs -h for the filesystem?
> 
> 	     	    	     	 	   - Ted
> 


Inode: 32538663   Type: regular    Mode:  0640   Flags: 0x80000 
Generation: 1807877460
User:  1000   Group:  1000   Size: 3902
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 8
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x47dead07 -- Mon Mar 17 18:40:23 2008
atime: 0x47dead07 -- Mon Mar 17 18:40:23 2008
mtime: 0x45a5e96b -- Thu Jan 11 08:38:19 2007
BLOCKS:
(0):75131957
TOTAL: 1

Inode: 32538664   Type: regular    Mode:  0640   Flags: 0x80000 
Generation: 1807877461
User:  1000   Group:  1000   Size: 2984
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 8
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x47dead07 -- Mon Mar 17 18:40:23 2008
atime: 0x47dead07 -- Mon Mar 17 18:40:23 2008
mtime: 0x45a5e96b -- Thu Jan 11 08:38:19 2007
BLOCKS:
(0):75131958
TOTAL: 1


dumpe2fs:

dumpe2fs 1.40.8 (13-Mar-2008)
Filesystem volume name:   <none>
Last mounted on:          <not available>
Filesystem UUID:          4021e5ea-b06d-45c9-8c53-28b0565bb834
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal resize_inode dir_index filetype 
extents sparse_super large_file huge_file
Filesystem flags:         signed_directory_hash test_filesystem
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              58114048
Block count:              116207103
Reserved block count:     5810355
Free blocks:              11485206
Free inodes:              57967276
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      996
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         16384
Inode blocks per group:   512
Filesystem created:       Wed Oct  3 01:15:34 2007
Last mount time:          Wed Apr  9 19:30:26 2008
Last write time:          Wed Apr  9 20:02:38 2008
Mount count:              14
Maximum mount count:      27
Last checked:             Thu Feb 28 23:21:45 2008
Check interval:           15552000 (6 months)
Next check after:         Wed Aug 27 00:21:45 2008
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:		  128
Journal inode:            8
Default directory hash:   tea
Directory Hash Seed:      89709093-0816-4385-a3fa-164c8564e7d2
Journal backup:           inode blocks
Journal size:             128M

