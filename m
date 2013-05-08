From: "Stephen Elliott" <techweb@ntlworld.com>
Subject: RE: 2nd Attempt - FSCK Errors
Date: Wed, 8 May 2013 15:45:23 +0100
Message-ID: <001401ce4bfa$ac382170$04a86450$@ntlworld.com>
References: <007b01ce45ab$0ffc24f0$2ff46ed0$@ntlworld.com> <CAFB1F4E-F086-4712-B70D-74F85F3BFDAE@dilger.ca> <000f01ce47ec$ca7767c0$5f663740$@ntlworld.com> <20130503131421.GC32297@thunk.org> <002701ce4802$8c4e4fc0$a4eaef40$@ntlworld.com> <20130503152914.GE32297@thunk.org> <001601ce482e$07282510$15786f30$@ntlworld.com> <20130503213132.GA6032@thunk.org>
Reply-To: <techweb@ntlworld.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "'Andreas Dilger'" <adilger@dilger.ca>,
	<linux-ext4@vger.kernel.org>
To: "'Theodore Ts'o'" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:47231 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab3EHOp2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 May 2013 10:45:28 -0400
Received: by mail-wi0-f182.google.com with SMTP id m6so2018400wiv.15
        for <linux-ext4@vger.kernel.org>; Wed, 08 May 2013 07:45:26 -0700 (PDT)
In-Reply-To: <20130503213132.GA6032@thunk.org>
Content-Language: en-gb
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Well... I have some new and interesting information. 

After deleting the file, and re-creating from backup, the file system got
mounted read only and the following errors were logged:

May  8 14:58:15 despair kernel: EXT4-fs error (device dm-0):
mb_free_blocks:1411: group 5124block 167904376:freeing already freed block
(bit 1144)
May  8 14:58:15 despair kernel: Aborting journal on device dm-0-8.
May  8 14:58:15 despair kernel: EXT4-fs (dm-0): Remounting filesystem
read-only
May  8 14:58:15 despair kernel: EXT4-fs error (device dm-0):
mb_free_blocks:1411: group 5124block 167904377:freeing already freed block
(bit 1145)
May  8 14:58:15 despair kernel: EXT4-fs error (device dm-0):
mb_free_blocks:1411: group 5124block 167904378:freeing already freed block
(bit 1146)
May  8 14:58:15 despair kernel: EXT4-fs error (device dm-0):
mb_free_blocks:1411: group 5124block 167904379:freeing already freed block
(bit 1147)
May  8 14:58:15 despair kernel: EXT4-fs error (device dm-0):
mb_free_blocks:1411: group 5124block 167904380:freeing already freed block
(bit 1148)
May  8 14:58:15 despair kernel: EXT4-fs error (device dm-0):
mb_free_blocks:1411: group 5124block 167904381:freeing already freed block
(bit 1149)
May  8 14:58:15 despair kernel: EXT4-fs error (device dm-0):
mb_free_blocks:1411: group 5124block 167904382:freeing already freed block
(bit 1150)
May  8 14:58:16 despair kernel: EXT4-fs error (device dm-0):
mb_free_blocks:1411: group 5124block 167904383:freeing already freed block
(bit 1151)
May  8 14:58:16 despair kernel: EXT4-fs error (device dm-0):
mb_free_blocks:1411: group 5124block 167904384:freeing already freed block
(bit 1152)
May  8 14:58:16 despair kernel: EXT4-fs error (device dm-0):
mb_free_blocks:1411: group 5124block 167904385:freeing already freed block
(bit 1153)
May  8 14:58:16 despair kernel: EXT4-fs error (device dm-0):
mb_free_blocks:1411: group 5124block 167904386:freeing already freed block
(bit 1154)
May  8 14:58:16 despair kernel: EXT4-fs error (device dm-0):
mb_free_blocks:1411: group 5125block 167949296:freeing already freed block
(bit 13296)
May  8 14:58:16 despair kernel: EXT4-fs error (device dm-0):
mb_free_blocks:1411: group 5125block 167949297:freeing already freed block
(bit 13297)
May  8 14:58:16 despair kernel: EXT4-fs error (device dm-0):
mb_free_blocks:1411: group 5125block 167949298:freeing already freed block
(bit 13298)
May  8 14:58:16 despair kernel: EXT4-fs error (device dm-0):
mb_free_blocks:1411: group 5125block 167949299:freeing already freed block
(bit 13299)
May  8 14:58:17 despair kernel: EXT4-fs error (device dm-0):
mb_free_blocks:1411: group 5125block 167949300:freeing already freed block
(bit 13300)
May  8 14:58:17 despair kernel: EXT4-fs error (device dm-0):
mb_free_blocks:1411: group 5125block 167949301:freeing already freed block
(bit 13301)
May  8 14:58:17 despair kernel: EXT4-fs error (device dm-0):
mb_free_blocks:1411: group 5125block 167949302:freeing already freed block
(bit 13302)
May  8 14:58:17 despair kernel: EXT4-fs error (device dm-0):
mb_free_blocks:1411: group 5125block 167949303:freeing already freed block
(bit 13303)
May  8 14:58:17 despair kernel: EXT4-fs error (device dm-0):
mb_free_blocks:1411: group 5125block 167949304:freeing already freed block
(bit 13304)
May  8 14:58:17 despair kernel: EXT4-fs error (device dm-0):
mb_free_blocks:1411: group 5125block 167949305:freeing already freed block
(bit 13305)
May  8 14:58:17 despair kernel: EXT4-fs error (device dm-0):
mb_free_blocks:1411: group 5125block 167949306:freeing already freed block
(bit 13306)

These are the same blocks slated as multiply claimed :)

 And then running an FSCK, we got the following:

***** File system check forced at Wed May  8 15:16:50 WEST 2013 ***** fsck
1.41.14 (22-Dec-2010) e2fsck 1.42.3 (14-May-2012)
/dev/c/c: recovering journal
Pass 1: Checking inodes, blocks, and sizes Pass 2: Checking directory
structure Pass 3: Checking directory connectivity Pass 4: Checking reference
counts Pass 5: Checking group summary information Free blocks count wrong
for group #5124 (28170, counted=28159).
Fix? yes

Free blocks count wrong for group #5125 (25861, counted=25850).
Fix? yes

Free blocks count wrong (420683133, counted=420644972).
Fix? yes

Free inodes count wrong (29595347, counted=29595271).
Fix? yes


/dev/c/c: ***** FILE SYSTEM WAS MODIFIED *****
/dev/c/c: 616825/30212096 files (13.6% non-contiguous), 62748564/483393536
blocks

Volume seems clean now after reboot and keeps coming back clean.

Any ideas based on this? The old Database was over 1.6 GB in size. The
re-created one from backup is much smaller 33MB (as it was compacted before
restoring). Once these DB files grow they don't get smaller until compacted.
Although I'm sure file size should not have a bearing on this.

Many Thanks
Stephen Elliott


-----Original Message-----
From: Theodore Ts'o [mailto:tytso@mit.edu] 
Sent: 03 May 2013 22:32
To: Stephen Elliott
Cc: 'Andreas Dilger'; linux-ext4@vger.kernel.org
Subject: Re: 2nd Attempt - FSCK Errors

On Fri, May 03, 2013 at 07:42:55PM +0100, Stephen Elliott wrote:
> One thing maybe you could explain (and Andreas gave me his take too) 
> is how you can multiply assigned blocks shared with "0" files. Andreas 
> offered the suggestion that they may be in the same file. If this were 
> really the case, I would suspect there to be some file corruption issues
etc...

It could be that the blocks appear multiple times in the file; or it could
be the storage system is returning different data on subsequent reads from
the device.

What we need is a debugfs dump of the inode on the file system that is
having trouble.  A debugfs dump of the inode from a completely underlated
file system is not useful....

						- Ted

