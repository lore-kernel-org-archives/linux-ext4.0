From: "George Spelvin" <linux@horizon.com>
Subject: Exciting :-( adventures in metadata checksumming
Date: 3 Aug 2012 15:55:08 -0400
Message-ID: <20120803195508.18583.qmail@science.horizon.com>
Cc: linux@horizon.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:17497 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752496Ab2HCUBu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Aug 2012 16:01:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(Search for "Not Good" to see the report of FILE SYSTEM CORRUPTION by
e2fsck 1.43-WIP (git 9f0dbd24f8af) with -O metadata_csum.)

I've been having some problems recently with a large ext4 RAID-6
array.  The FS suddenly switched to read-only after finding some
problems:

[635067.851004] EXT4-fs error (device md0): ext4_ext_check_inode:398: inode #98205884: comm updatedb.mlocat: bad header/extent: invalid magic - magic a, entries 1, max 4(0), depth 0(0)
[635067.851015] Aborting journal on device md0-8.
[635067.886082] EXT4-fs (md0): Remounting filesystem read-only
[635257.672659] EXT4-fs error (device md0): ext4_ext_check_inode:398: inode #98205885: comm updatedb.mlocat: bad header/extent: invalid magic - magic a, entries 1, max 4(0), depth 0(0)
[635274.620679] EXT4-fs error (device md0): ext4_ext_check_inode:398: inode #133478411: comm updatedb.mlocat: bad header/extent: invalid magic - magic 400a, entries 1, max 4(0), depth 0(0)
[635274.621006] EXT4-fs error (device md0): ext4_ext_check_inode:398: inode #133478403: comm updatedb.mlocat: bad header/extent: invalid magic - magic a, entries 1, max 4(0), depth 0(0)
[635274.693563] EXT4-fs error (device md0): ext4_ext_check_inode:398: inode #133478417: comm updatedb.mlocat: bad header/extent: invalid magic - magic a, entries 1, max 4(0), depth 0(0)
[635274.741286] EXT4-fs error (device md0): ext4_ext_check_inode:398: inode #133478407: comm updatedb.mlocat: bad header/extent: invalid magic - magic 20a, entries 1, max 4(0), depth 0(0)
[635274.741683] EXT4-fs error (device md0): ext4_ext_check_inode:398: inode #133478401: comm updatedb.mlocat: bad header/extent: invalid magic - magic 800a, entries 1, max 4(0), depth 0(0)
[635274.778130] EXT4-fs error (device md0): ext4_ext_check_inode:398: inode #133478415: comm updatedb.mlocat: bad header/extent: invalid magic - magic 630a, entries 1, max 4(0), depth 0(0)
[635274.785982] EXT4-fs error (device md0): ext4_ext_check_inode:398: inode #133478405: comm updatedb.mlocat: bad header/extent: invalid magic - magic a, entries 1, max 4(0), depth 0(0)
[635274.789177] EXT4-fs error (device md0): ext4_ext_check_inode:398: inode #133478419: comm updatedb.mlocat: bad header/extent: invalid magic - magic a, entries 1, max 4(0), depth 0(0)
[635274.791153] EXT4-fs error (device md0): ext4_ext_check_inode:398: inode #133478413: comm updatedb.mlocat: bad header/extent: invalid magic - magic c30a, entries 1, max 4(0), depth 0(0)
[635274.808709] EXT4-fs error (device md0): ext4_ext_check_inode:398: inode #133478409: comm updatedb.mlocat: bad header/extent: invalid magic - magic f00a, entries 1, max 4(0), depth 0(0)

I notice that the msbyte (the second byte) of the macig number appears to
be corrupted.  In particular, some subset of the bits that should be set
(the magic number is 0xf30a) have been cleared.

I'd suspect memory corruption, but any hardware problem that would clear
*that* many bits would not have left the machine running for a month
at a time.  It's been stably running Ubuntu 12.04 LTS and providing a
Samba server for some months now.

The abobe errors were from the precompiled 3.2.0-26 Ubunti kernel.

Anyway, after unmounting the file system and running e2fsck, I got a
large number of errors of the form

Extended attribute in inode 70975811 has a value size (0) which is invalid
Extended attribute in inode 70975820 has a value size (0) which is invalid
Extended attribute in inode 70975821 has a value size (0) which is invalid
Extended attribute in inode 70975822 has a value size (0) which is invalid
Extended attribute in inode 70975823 has a value size (0) which is invalid

however, the inode numbers affected do not overlap the set the kernel was
complaining about.

I let e2fsck fix those probleme (they were almost all Thumbs.db files on
Samba directories, so I wasn't too worried) and remounted the file system.

Three days later, more of the same!

[1038734.464464] EXT4-fs error (device md0): ext4_ext_check_inode:398: inode #143395710: comm chmod: bad header/extent: invalid magic - magic 510a, entries 1, max 4(0), depth 0(0)
[1038734.464474] Aborting journal on device md0-8.
[1038734.518844] EXT4-fs (md0): Remounting filesystem read-only
[1038734.519809] EXT4-fs error (device md0): ext4_ext_check_inode:398: inode #143395702: comm chmod: bad header/extent: invalid magic - magic 730a, entries 1, max 4(0), depth 0(0)
[1038734.521094] EXT4-fs error (device md0): ext4_ext_check_inode:398: inode #143395703: comm chmod: bad header/extent: invalid magic - magic d30a, entries 1, max 4(0), depth 0(0)
[1038734.526998] EXT4-fs error (device md0): ext4_ext_check_inode:398: inode #143395712: comm chmod: bad header/extent: invalid magic - magic d10a, entries 1, max 4(0), depth 0(0)
[1038734.527912] EXT4-fs error (device md0): ext4_ext_check_inode:398: inode #143395704: comm chmod: bad header/extent: invalid magic - magic f10a, entries 1, max 4(0), depth 0(0)
[1038734.529935] EXT4-fs error (device md0): ext4_ext_check_inode:398: inode #143395706: comm chmod: bad header/extent: invalid magic - magic 510a, entries 1, max 4(0), depth 0(0)
[1038734.531899] EXT4-fs error (device md0): ext4_ext_check_inode:398: inode #143395709: comm chmod: bad header/extent: invalid magic - magic d10a, entries 1, max 4(0), depth 0(0)
[1038734.532839] EXT4-fs error (device md0): ext4_ext_check_inode:398: inode #143395700: comm chmod: bad header/extent: invalid magic - magic 710a, entries 1, max 4(0), depth 0(0)
[1038734.536454] EXT4-fs error (device md0): ext4_ext_check_inode:398: inode #143395711: comm chmod: bad header/extent: invalid magic - magic d10a, entries 1, max 4(0), depth 0(0)

Same e2fsck results.  But I'm getting concerned.

So I think that the (mostly) successful e2fsck results show that the
*disk* data appears to be valid, and some form of corruption appears
to be affecting the read data.  Metadata checksums should catch the
problem sooner.

So let me try that!

But look, it's not supported by the Ubuntu 3.2.0 kernel.  No problem,
Quantal Quetzal has a 3.5 kernel that I can install that's already
configured properly.

But damn, even Quantal only has e2fsprogs 1.42.4, which does have -O
metadata_csum support.

git clone, compile... damn!  git master is 1.42.5, which doesn't have
it either!

But 1.43-WIP has it, so let me compile the "next" branch... success!

/root/ewfsprogs# misc/tune2fs -O metadata_csum /dev/md0
tune2fs 1.43-WIP (1-Aug-2012)

Please run e2fsck -D on the filesystem.
/root/e2fsprogs#

Oh, wait a minute... that better be the *new* e2fsck; the system one
doesn't have metadata_csum support!  I ought to install the new utilities
so that the system won't get stuck booting.  (Fortunately, the
RAID is not the root file system.)

A considerable amount of time trying to run "debuild -b -us -uc" and
"debian/rules binary" elapses.  I am unable to build a .deb.  Damn.
And debian/rules files are a complete maze of layers of helper
utilities that I have no idea how to debug. :-(

I'll have to just install local versions in /usr/local/sbin and ensure
they get used until Ubuntu catches up.

But in the meantime, let me run that e2fsck that's suggested...

/root/e2fsprogs# e2fsck/e2fsck -D -v -C0 /dev/md0
e2fsck 1.43-WIP (1-Aug-2012)
/dev/md0 was not cleanly unmounted, check forced.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure                                           
Directory inode 1660934, block #0, offset 4076: directory passes checks but fails checksum
Fix<y>? yes
Directory inode 3547141, block #0, offset 4076: directory passes checks but fails checksum
Fix<y>? yes
Directory inode 80533520, block #0, offset 4076: directory passes checks but fails checksum
Fix<y>? yes
Directory inode 100868100, block #0, offset 4076: directory passes checks but fails checksum
Fix<y>? yes
Directory inode 103686159, block #0, offset 4076: directory passes checks but fails checksum
Fix<y>? yes
Directory inode 107098118, block #0, offset 4076: directory passes checks but fails checksum
Fix<y>? yes
Directory inode 107530256, block #0, offset 4076: directory passes checks but fails checksum
Fix<y>? yes
Directory inode 112592908, block #0, offset 4076: directory passes checks but fails checksum
Fix<y>? yes
Directory inode 114372621, block #0, offset 4076: directory passes checks but fails checksum
Fix<y>? yes
Directory inode 119973900, block #0, offset 4076: directory passes checks but fails checksum
Fix<y>? yes
Directory inode 120281096, block #0, offset 4076: directory passes checks but fails checksum
Fix<y>? yes
Directory inode 122302465, block #0, offset 4076: directory passes checks but fails checksum
Fix<y>? yes
Directory inode 124215315, block #0, offset 4076: directory passes checks but fails checksum
Fix<y>? yes
Directory inode 127861088, block #0, offset 4076: directory passes checks but fails checksum
Fix<y>? yes
Directory inode 131426306, block #0, offset 4076: directory passes checks but fails checksum
Fix<y>? yes
Directory inode 133816331, block #0, offset 4076: directory passes checks but fails checksum
Fix<y>? yes
Directory inode 140457985, block #0, offset 4076: directory passes checks but fails checksum
Fix<y>? yes
Directory inode 141527045, block #0, offset 4076: directory passes checks but fails checksum
Fix<y>? yes
Directory inode 142325769, block #0, offset 4076: directory passes checks but fails checksum
Fix<y>? yes
Directory inode 143130951, block #0, offset 4076: directory passes checks but fails checksum
Fix<y>? yes
Pass 3: Checking directory connectivity                                        
Pass 3A: Optimizing directories                                                
Pass 4: Checking reference counts                                              
Pass 5: Checking group summary information                                     
Free blocks count wrong for group #46928 (7000, counted=7001).                 
Fix<y>? yes
Free blocks count wrong for group #53136 (30333, counted=30334).
Fix<y>? yes
Free blocks count wrong (856654909, counted=856654911).
Fix<y>? yes
                                                                               
/dev/md0: ***** FILE SYSTEM WAS MODIFIED *****

     1564799 inodes used (1.03%, out of 152619008)
        9199 non-contiguous files (0.6%)
         691 non-contiguous directories (0.0%)
             # of inodes with ind/dind/tind blocks: 0/0/0
             Extent depth histogram: 1559941/4838
  1585236769 blocks used (64.92%, out of 2441891680)
           0 bad blocks
         370 large files

      580404 regular files
      984376 directories
           0 character device files
           0 block device files
           0 fifos
     1655417 links
           9 symbolic links (9 fast symbolic links)
           1 socket
------------
     3220207 files
/root/e2fsprogs# 

I'm not sure what's supposed to happen, but those seem like reasonably
harmless errors that tune2fs might have left behind.

I'm also not sure why
/backuppc/pc/localhost/{66..80}/f%2f/fusr/fshare/fman/fman1
had some lingering checksum problems, and no other directories.

But let me run e2fsck once more, just to be safe...

Oh, shit!  This is Not Good!

/root/e2fsprogs# e2fsck/e2fsck -v -C0 /dev/md0
e2fsck 1.43-WIP (1-Aug-2012)
/dev/md0: clean, 1564799/152619008 files, 1585236769/2441891680 blocks
/root/e2fsprogs# e2fsck/e2fsck -f -v -C0 /dev/md0
e2fsck 1.43-WIP (1-Aug-2012)
Pass 1: Checking inodes, blocks, and sizes
Inode 96108844 has an invalid extent node (blk 1537738982, lblk 0)             
Clear<y>? no
HTREE directory inode 96108844 has an invalid root node.
Clear HTree index<y>? no
Inode 96108844 is a zero-length directory.  Clear<y>? no
Inode 96108844, i_size is 24576, should be 0.  Fix<y>? no
Inode 96108844, i_blocks is 56, should be 0.  Fix<y>? no
Inode 108822615 has an invalid extent node (blk 1741162561, lblk 0)            
Clear<y>? no
HTREE directory inode 108822615 has an invalid root node.
Clear HTree index<y>? no
Inode 108822615 is a zero-length directory.  Clear<y>? no
Inode 108822615, i_size is 24576, should be 0.  Fix<y>? no
Inode 108822615, i_blocks is 56, should be 0.  Fix<y>? no
Pass 2: Checking directory structure                                           
Pass 3: Checking directory connectivity                                        
'..' in /backuppc/pc/localhost/57/f%2f/fusr/flib/fi386-linux-gnu (96108844) is <The NULL inode> (0), should be /backuppc/pc/localhost/57/f%2f/fusr/flib (96043127).
Fix<y>? no
Unconnected directory inode 96108845 (???)
Connect to /lost+found<y>? no
'..' in ... (96108845) is ??? (96108844), should be <The NULL inode> (0).
Fix<y>? no
Unconnected directory inode 96108846 (???)
Connect to /lost+found<y>? no
'..' in ... (96108846) is ??? (96108844), should be <The NULL inode> (0).
Fix<y>? no
Unconnected directory inode 96108847 (???)
Connect to /lost+found<y>? no
'..' in ... (96108847) is ??? (96108844), should be <The NULL inode> (0).
Fix<y>? no
Unconnected directory inode 96108848 (???)
Connect to /lost+found<y>? no
'..' in ... (96108848) is ??? (96108844), should be <The NULL inode> (0).
Fix<y>? no
Unconnected directory inode 96108850 (???)
Connect to /lost+found<y>? no
'..' in ... (96108850) is ??? (96108844), should be <The NULL inode> (0).
Fix<y>? no
Unconnected directory inode 96108852 (???)
Connect to /lost+found<y>? no
'..' in ... (96108852) is ??? (96108844), should be <The NULL inode> (0).
Fix<y>? no
Unconnected directory inode 96108853 (???)
Connect to /lost+found<y>? no
'..' in ... (96108853) is ??? (96108844), should be <The NULL inode> (0).
Fix<y>? 
/dev/md0: e2fsck canceled.

/dev/md0: ********** WARNING: Filesystem still has errors **********

/root/e2fsprogs# 


Eek!  Doubleplusungood.  Repeating the e2fsck, the errors seem to be
consistent.  For the record I did *nothing* to the file system between
the two runs except used debugfs in read-only mode to ncheck the inodes
that generated complaints.

In fact, I ran debugfs *during* the e2fsck directory optimize pass, and
it complained about some corruption, but I figured that was just e2fsck
at work, and debugfs (without -w) couldn't affect the e2fsck in any way.

If I let e2fsck fix the problems (fortunately, the trashed directory is
just an old backup), they appear to actually go away; another run comes
up clean.


For now, I have e2fsck manually installed, while I work on compiling a
kernel with Ted's ext4_for_linus fixes, especially that directory rename
checksum issue.


I'm not quite sure what's going on (I still haven't figured out the
original corruption problem), but I figured this was worth sharing anyway.

I can compile a kernel without error, so my RAM can't be in *that* bad
a shape.  (Ted, at least, will remember that from the days of 0.99pl13j.)
