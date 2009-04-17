From: Jeremy Sanders <jss@ast.cam.ac.uk>
Subject: Re: fsck.ext4: Group descriptors look bad... trying backup blocks...
Date: Fri, 17 Apr 2009 12:26:28 +0100
Message-ID: <gs9p14$brn$1@ger.gmane.org>
References: <gs9nm5$8m1$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:43421 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759937AbZDQL0p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Apr 2009 07:26:45 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LumDP-0007WG-MC
	for linux-ext4@vger.kernel.org; Fri, 17 Apr 2009 11:26:39 +0000
Received: from xpc17.ast.cam.ac.uk ([131.111.69.96])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 17 Apr 2009 11:26:39 +0000
Received: from jss by xpc17.ast.cam.ac.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 17 Apr 2009 11:26:39 +0000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Some more information about the device:

root@xback2 ~]# dumpe2fs /dev/md0| head -100                                                              
dumpe2fs 1.41.4 (27-Jan-2009)                                                                              
Filesystem volume name:   <none>                                                                           
Last mounted on:          <not available>                                                                  
Filesystem UUID:          508aee62-79af-4b4c-95a6-222b3868834c                                             
Filesystem magic number:  0xEF53                                                                           
Filesystem revision #:    1 (dynamic)                                                                      
Filesystem features:      has_journal ext_attr resize_inode dir_index 
filetype extent flex_bg sparse_super large_file huge_file uninit_bg 
dir_nlink extra_isize                                                         
Filesystem flags:         signed_directory_hash                                                             
Default mount options:    (none)                                                                            
Filesystem state:         clean                                                                             
Errors behavior:          Continue                                                                          
Filesystem OS type:       Linux                                                                             
Inode count:              549314560                                                                         
Block count:              2197239840                                                                        
Reserved block count:     0                                                                                 
Free blocks:              1508301443                                                                        
Free inodes:              545311753                                                                         
First block:              0                                                                                 
Block size:               4096                                                                              
Fragment size:            4096                                                                              
Reserved GDT blocks:      500                                                                               
Blocks per group:         32768                                                                             
Fragments per group:      32768                                                                             
Inodes per group:         8192                                                                              
Inode blocks per group:   512                                                                               
RAID stride:              8                                                                                 
RAID stripe width:        72                                                                                
Flex block group size:    16                                                                                
Filesystem created:       Fri Apr 10 17:13:08 2009                                                          
Last mount time:          Mon Apr 13 11:00:22 2009                                                          
Last write time:          Fri Apr 17 11:53:05 2009                                                          
Mount count:              1                                                                                 
Maximum mount count:      -1                                                                                
Last checked:             Fri Apr 10 17:13:08 2009                                                          
Check interval:           0 (<none>)                                                                        
Reserved blocks uid:      0 (user root)                                                                     
Reserved blocks gid:      0 (group root)                                                                    
First inode:              11                                                                                
Inode size:               256                                                                               
Required extra isize:     28                                                                                
Desired extra isize:      28                                                                                
Journal inode:            8                                                                                 
Default directory hash:   half_md4                                                                          
Directory Hash Seed:      9c9b9fd6-5af2-4ee0-bceb-25827cb008f9                                              
Journal backup:           inode blocks                                                                      
Journal size:             128M                                                                              


Group 0: (Blocks 0-32767) [ITABLE_ZEROED]
  Checksum 0xd3b2, unused inodes 4032    
  Primary superblock at 0, Group descriptors at 1-524
  Reserved GDT blocks at 525-1024                    
  Block bitmap at 1025 (+1025), Inode bitmap at 1041 (+1041)
  Inode table at 1057-1568 (+1057)                          
  856 free blocks, 4032 free inodes, 268 directories, 4032 unused inodes
Group 1: (Blocks 32768-65535) [INODE_UNINIT, ITABLE_ZEROED]             
  Checksum 0xc586, unused inodes 8192
  Backup superblock at 32768, Group descriptors at 32769-33292
  Reserved GDT blocks at 33293-33792
  Block bitmap at 1026 (+4294935554), Inode bitmap at 1042 (+4294935570)
  Inode table at 1569-2080 (+4294936097)
  939 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
Group 2: (Blocks 65536-98303) [INODE_UNINIT, ITABLE_ZEROED]
...



