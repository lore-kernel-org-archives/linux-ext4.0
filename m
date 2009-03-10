From: Kevin Shanahan <kmshanah@ucwb.org.au>
Subject: Re: Possible ext4 corruption - ACL related?
Date: Tue, 10 Mar 2009 22:45:47 +1030
Message-ID: <1236687347.30280.42.camel@kulgan.wumi.org.au>
References: <1236642197.30280.18.camel@kulgan.wumi.org.au>
	 <49B5D71D.1030802@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bowden.ucwb.org.au ([203.122.237.119]:43523 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbZCJMP4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Mar 2009 08:15:56 -0400
In-Reply-To: <49B5D71D.1030802@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2009-03-09 at 21:57 -0500, Eric Sandeen wrote:
> > I think we have some minor corruption happening with a new (about two
> > weeks old) ext4 file system. Our backup script spat out bunch of errors
> > last night while trying to read the file ACLs:
> > 
> > getfacl: apps/Gestalt.Net/SetupCD/program\040files/Business\040Objects/Common/3.5/bin/Cdo32sv.dll: Input/output error
> > getfacl: apps/Gestalt.Net/SetupCD/program\040files/Business\040Objects/Common/3.5/bin/U3520chs.dll: Input/output error
> > getfacl: apps/Gestalt.Net/SetupCD/program\040files/Business\040Objects/Common/3.5/bin/ReportRenderer.dll: Input/output error
> > getfacl: apps/Gestalt.Net/SetupCD/program\040files/Business\040Objects/Common/3.5/bin/ParameterDesigner.dll: Input/output error
> > ...
> > 
> > And in syslog I see these warnings from the kernel:
> > 
> > Mar 10 00:06:01 hermes /USR/SBIN/CRON[10875]: (root) CMD (   /usr/local/bin/rsync-backup-all.sh)
> > Mar 10 00:06:24 hermes kernel: init_special_inode: bogus i_mode (53253)
> > Mar 10 00:06:24 hermes kernel: attempt to access beyond end of device
> > Mar 10 00:06:24 hermes kernel: dm-0: rw=0, want=1312475392770056, limit=2147483648
> > Mar 10 00:06:25 hermes kernel: attempt to access beyond end of device
> > Mar 10 00:06:25 hermes kernel: dm-0: rw=0, want=1312475392770056, limit=2147483648
> > 
> > The filesystem is still in use (and working okay, AFAICT), but I'll need
> > to fsck this tonight. Is there any useful data I can gather from the fs
> > before (or while) I do that which might help track down the cause?
> 
> an e2image of the filesystem before fsck might help, and be sure to save
> fsck output.

Okay, I grabbed the e2image file first.
Huge, but full of holes of course.

hermes:~# stat lv_samba.e2image 
  File: `lv_samba.e2image'
  Size: 17222082560     Blocks: 227456     IO Block: 4096   regular file
Device: 901h/2305d      Inode: 1058747     Links: 1
Access: (0600/-rw-------)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2009-03-10 22:22:49.000000000 +1030
Modify: 2009-03-10 22:25:18.000000000 +1030
Change: 2009-03-10 22:25:18.000000000 +1030

fsck is not happy, wants to be run manually.

hermes:~# e2fsck -pfv /dev/dm-0 
/dev/dm-0: Inode 865 is in use, but has dtime set.  FIXED.
/dev/dm-0: Inode 865 has a extra size (33096) which is invalid
FIXED.
/dev/dm-0: Inode 865 has INDEX_FL flag set but is not a directory.
HTREE INDEX CLEARED.
/dev/dm-0: Inode 865, i_size is 11708523728200260508, should be 0.  FIXED.
/dev/dm-0: Inode 865, i_blocks is 3851901040, should be 0.  FIXED.
/dev/dm-0: Inode 866 is in use, but has dtime set.  FIXED.
/dev/dm-0: Inode 867 is in use, but has dtime set.  FIXED.
/dev/dm-0: Inode 867 has imagic flag set.  

/dev/dm-0: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
        (i.e., without -a or -p options)

Full output from the manual run is below.

Cheers,
Kevin.
--

hermes:~# e2fsck -fv /dev/dm-0
e2fsck 1.41.3 (12-Oct-2008)
Pass 1: Checking inodes, blocks, and sizes
Inode 867 has imagic flag set.  Clear<y>? yes

Inode 867 has a extra size (3625) which is invalid
Fix<y>? yes

Inode 867 has a bad extended attribute block 141934744.  Clear<y>? yes

Inode 867, i_size is 1621929268641603925, should be 0.  Fix<y>? yes

Inode 867, i_blocks is 626447053, should be 0.  Fix<y>? yes

Inode 868 is in use, but has dtime set.  Fix<y>? yes

Inode 868 has a extra size (8206) which is invalid
Fix<y>? yes

Inode 869 is in use, but has dtime set.  Fix<y>? yes

Inode 869 has imagic flag set.  Clear<y>? yes

Inode 869 has a extra size (6152) which is invalid
Fix<y>? yes

Inode 870 is in use, but has dtime set.  Fix<y>? yes

Inode 870 has a extra size (37249) which is invalid
Fix<y>? yes

Inode 871 is in use, but has dtime set.  Fix<y>? yes

Inode 871 has imagic flag set.  Clear<y>? yes

Inode 871 has a extra size (25184) which is invalid
Fix<y>? yes

Inode 871 has compression flag set on filesystem without compression support.  Clear<y>? yes

Inode 871, i_size is 11354597595663089880, should be 0.  Fix<y>? yes

Inode 871, i_blocks is 3084592992, should be 0.  Fix<y>? yes

Inodes that were part of a corrupted orphan linked list found.  Fix<y>? yes

Inode 872 was part of the orphaned inode list.  FIXED.
Inode 872 has a extra size (49847) which is invalid
Fix<y>? yes

Inode 872 has compression flag set on filesystem without compression support.  Clear<y>? yes

Inode 872 has a bad extended attribute block 2621440.  Clear<y>? yes

Error while reading over extent tree in inode 872: Corrupt extent header
Clear inode<y>? yes

Inode 872 is a zero-length directory.  Clear<y>? yes

Inode 873 is in use, but has dtime set.  Fix<y>? yes

Inode 873 has imagic flag set.  Clear<y>? yes

Inode 873 has a extra size (18362) which is invalid
Fix<y>? yes

Inode 873 has compression flag set on filesystem without compression support.  Clear<y>? yes

Error while reading over extent tree in inode 873: Corrupt extent header
Clear inode<y>? yes

Inode 873, i_blocks is 750551612, should be 0.  Fix<y>? yes

Inode 874 is in use, but has dtime set.  Fix<y>? yes

Inode 874 has a extra size (3840) which is invalid
Fix<y>? yes

Inode 875 is in use, but has dtime set.  Fix<y>? yes

Inode 875 has imagic flag set.  Clear<y>? yes

Inode 875 has a extra size (18005) which is invalid
Fix<y>? yes

Inode 875 has a bad extended attribute block 21679127.  Clear<y>? yes

Inode 875 has INDEX_FL flag set but is not a directory.
Clear HTree index<y>? yes

Inode 875, i_size is 2269162663506877006, should be 0.  Fix<y>? yes

Inode 875, i_blocks is 2538914224, should be 0.  Fix<y>? yes

Inode 876 is in use, but has dtime set.  Fix<y>? yes

Inode 876 has imagic flag set.  Clear<y>? yes

Inode 876 has a extra size (27586) which is invalid
Fix<y>? yes

Inode 876 has compression flag set on filesystem without compression support.  Clear<y>? yes

Inode 876, i_size is 8678493212014404941, should be 0.  Fix<y>? yes

Inode 876, i_blocks is 86534675801319, should be 0.  Fix<y>? yes

Inode 877 is in use, but has dtime set.  Fix<y>? yes

Inode 877 has a extra size (50847) which is invalid
Fix<y>? yes

Error while reading over extent tree in inode 877: Corrupt extent header
Clear inode<y>? yes

Inode 877, i_blocks is 3392462386, should be 0.  Fix<y>? yes

Inode 878 is in use, but has dtime set.  Fix<y>? yes

Inode 878 has imagic flag set.  Clear<y>? yes

Inode 878 has a extra size (26132) which is invalid
Fix<y>? yes

Inode 878 has a bad extended attribute block 16842752.  Clear<y>? yes

Error while reading over extent tree in inode 878: Corrupt extent header
Clear inode<y>? yes

Inode 878, i_blocks is 2763914436, should be 0.  Fix<y>? yes

Inode 879 is in use, but has dtime set.  Fix<y>? yes

Inode 879 has imagic flag set.  Clear<y>? yes

Inode 879 has a extra size (7719) which is invalid
Fix<y>? yes

Inode 880 is in use, but has dtime set.  Fix<y>? yes

Inode 880 has imagic flag set.  Clear<y>? yes

Inode 880 has a extra size (20011) which is invalid
Fix<y>? yes

Inode 880, i_size is 15560619716461179914, should be 0.  Fix<y>? yes

Inode 880, i_blocks is 131913893443436, should be 0.  Fix<y>? yes


Inode 868 has compression flag set on filesystem without compression support.  Clear<y>? yes

Inode 868, i_size is 4028226676621914086, should be 0.  Fix<y>? yes

Inode 868, i_blocks is 134639139614610, should be 0.  Fix<y>? yes

Inode 866 has a bad extended attribute block 263323648.  Clear<y>? yes

Inode 866, i_size is 2427760314128421, should be 0.  Fix<y>? yes

Inode 866, i_blocks is 11426071, should be 0.  Fix<y>? yes

Inode 874, i_size is 22524735385517479, should be 0.  Fix<y>? yes

Inode 874, i_blocks is 279313060335481, should be 0.  Fix<y>? yes

Inode 869 has a bad extended attribute block 185417860.  Clear<y>? yes

Inode 869 has INDEX_FL flag set but is not a directory.
Clear HTree index<y>? yes

Inode 869, i_size is 288707807517097708, should be 0.  Fix<y>? yes

Inode 869, i_blocks is 4014035729, should be 0.  Fix<y>? yes

Inode 870, i_size is 4369557840038834079, should be 0.  Fix<y>? yes

Inode 870, i_blocks is 2905973680, should be 0.  Fix<y>? yes

Inode 879 has compression flag set on filesystem without compression support.  Clear<y>? yes

Inode 879 has INDEX_FL flag set but is not a directory.
Clear HTree index<y>? yes

Inode 879, i_size is 15592687770754169968, should be 0.  Fix<y>? yes

Inode 879, i_blocks is 86032481815687, should be 0.  Fix<y>? yes

Extended attribute block 8626 has reference count 1024, should be 1008.  Fix<y>? yes

Pass 2: Checking directory structure
Inode 867 (/local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/Cdo32sv.dll) has invalid mode (0152404).
Clear<y>? yes

Inode 871 (/local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/ParameterDesigner.dll) has invalid mode (0135566).
Clear<y>? yes

Entry 'ReportRenderer.dll' in /local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin (136) has deleted/unused inode 873.  Clear<y>? yes

Inode 876 (/local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/U25dts.dll) has invalid mode (0171451).
Clear<y>? yes

Entry 'U3520chs.dll' in /local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin (136) has deleted/unused inode 877.  Clear<y>? yes

i_faddr for inode 875 (/local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/RptControllers.dll) is 734152772, should be zero.
Clear<y>? yes

Entry 'RptControllers.dll' in /local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin (136) has an incorrect filetype (was 1, should be 5).
Fix<y>? yes

Entry 'ReportPromptEMF.dll' in /local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin (136) has deleted/unused inode 872.  Clear<y>? yes

Inode 879 (/local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/U3520de.dll) has invalid mode (0114355).
Clear<y>? yes

Inode 869 (/local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/Implode.dll) is an illegal FIFO.
Clear<y>? yes

Entry 'U3520cht.dll' in /local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin (136) has deleted/unused inode 878.  Clear<y>? yes

Inode 868 (/local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/ExportModeller.dll) is an illegal block device.
Clear<y>? yes

Inode 880 (/local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/U3520en.dll) has invalid mode (073230).
Clear<y>? yes

Inode 866 (/local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/Cdo32ru.dll) has invalid mode (053253).
Clear<y>? yes

Inode 874 (/local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/ReportSourceBridge.dll) is an illegal socket.
Clear<y>? yes

Inode 870 (/local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/License_xerces-c_2_1_0.txt) has invalid mode (077332).
Clear<y>? yes

Inode 865 (/local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/Cdo32pt.dll) is an illegal FIFO.
Clear<y>? yes

Pass 3: Checking directory connectivity
Pass 3A: Optimizing directories
Error reading block 2705859237 (Invalid argument).  Ignore error<y>? yes

Force rewrite<y>? yes

Error writing block 2705859237 (Invalid argument).  Ignore error<y>? yes

Failed to optimize directory ??? (872): EXT2 directory corruptedPass 4: Checking reference counts
Inode 875 ref count is 38039, should be 1.  Fix<y>? yes

Pass 5: Checking group summary information
Block bitmap differences:  -(27296--27306) -(62051--62062) -(135936--136113) -(137216--137390) -(137472--137520) -(137728--138033) -(138240--138409) -(138752--139065)
Fix<y>? yes

Free blocks count wrong for group #0 (3435, counted=3446).
Fix<y>? yes

Free blocks count wrong for group #1 (804, counted=816).
Fix<y>? yes

Free blocks count wrong for group #4 (2203, counted=3395).
Fix<y>? yes

Free blocks count wrong (227860452, counted=227861667).
Fix<y>? yes

Inode bitmap differences:  -(872--873) -(877--878)
Fix<y>? yes

Free inodes count wrong for group #0 (11, counted=15).
Fix<y>? yes

Free inodes count wrong (66820124, counted=66820128).
Fix<y>? yes


/dev/dm-0: ***** FILE SYSTEM WAS MODIFIED *****

  288736 inodes used (0.43%)
   11724 non-contiguous inodes (4.1%)
         # of inodes with ind/dind/tind blocks: 5/5/5
         Extent depth histogram: 288384/287
40573789 blocks used (15.11%)
       0 bad blocks
       2 large files

  262926 regular files
   25742 directories
       0 character device files
       0 block device files
       0 fifos
       0 links
      58 symbolic links (54 fast symbolic links)
       0 sockets
--------
  288727 files


