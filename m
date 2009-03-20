From: Denis Karpov <ext-denis.2.karpov@nokia.com>
Subject: Re: Error testing ext3 on brd ramdisk
Date: Fri, 20 Mar 2009 14:24:05 +0200
Message-ID: <20090320122405.GI21564@smart.research.nokia.com>
References: <49AFAFD9.9050805@dti2.net> <49AFC1A9.90501@dti2.net> <20090310161247.GA19352@wotan.suse.de> <20090310163002.GC19352@wotan.suse.de> <49B69A09.3080408@dti2.net> <20090311021920.GA16561@wotan.suse.de> <49BA927F.8020701@dti2.net> <20090317094019.GA10360@smart.research.nokia.com> <20090318121116.GC14622@wotan.suse.de> <20090318134202.GB11965@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="xB0nW4MQa6jZONgY"
Cc: Nick Piggin <npiggin@suse.de>,
	Denis Karpov <ext-denis.2.karpov@gmail.com>,
	"ext Jorge Boncompte [DTI2]" <jorge@dti2.net>,
	"Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: ext Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754697AbZCTMYm@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090318134202.GB11965@atrey.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--xB0nW4MQa6jZONgY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> > Jan's fixes are here:
> > http://marc.info/?l=linux-ext4&m=123731584711382&w=2
> > It would be interesting to try them, and if they don't work maybe
> > he's also interested so I cc'ed him.

Hi, 

thank you reppl. I re-run the tests with this patch.

> > > 
> > > In both cases I saw some complains from JBD/JBD2:
> > >  JBD: Detected IO errors while flushing file data on
>   Yes, my patches fix exactly this problem. So please try running with
> them. I'm not sure about that HTREE corruption you see during fsck. That
> seems to be a separate issue.
Unfortunately it looks like the problem is not fixed - JBD still complains
and in the end HTREE is getting damaged, in both ext3 and ext4 tests (see
attached logs).

Denis

--xB0nW4MQa6jZONgY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ext3.htree.txt"

-------------------------------------------------------------                   
Cycle 34                                                                        
Fri Mar 20 08:06:06 EDT 2009                                                    
Mounting                                                                        
[ 1128.228621] EXT3 FS on ram0, internal journal                                
[ 1128.232046] kjournald starting.  Commit interval 5 seconds                   
[ 1128.238557] EXT3-fs: mounted filesystem with ordered data mode.              
Removing old fsstress data                                                      
Starting fsstress                                                               
Sleeping 30 seconds                                                             
seed = 1238324876                                                               
[ 1139.101289] JBD: Detected IO errors while flushing file data on ram0         
[ 1139.116050] JBD: Detected IO errors while flushing file data on ram0         
[ 1139.124125] JBD: Detected IO errors while flushing file data on ram0         
[ 1140.100787] JBD: Detected IO errors while flushing file data on ram0         
[ 1140.375989] JBD: Detected IO errors while flushing file data on ram0         
[ 1141.313458] JBD: Detected IO errors while flushing file data on ram0         
[ 1142.387028] JBD: Detected IO errors while flushing file data on ram0         
[ 1142.668047] JBD: Detected IO errors while flushing file data on ram0         [ 1143.035936] JBD: Detected IO errors while flushing file data on ram0         
[ 1143.160422] JBD: Detected IO errors while flushing file data on ram0         
Stopping fsstress                                                               
 3974 ttyS0    00:00:00 fsstress_ext3                                           
 3977 ttyS0    00:00:20 fsstress_ext3                                           
 3978 ttyS0    00:00:20 fsstress_ext3                                           
 3979 ttyS0    00:00:20 fsstress_ext3                                           
./brd_test_ext3.sh: line 37:  3974 Terminated              `pwd`/fsstress_ext3 -
d $TESTDIR/work -p 3 -l 0 -n 100000000                                          
Unmounting                                                                      
Checking                                                                        
/dev/ram0: HTREE directory inode 42 has an invalid root node.                   HTREE INDEX CLEARED.                                                            
/dev/ram0: Entry 'c302b' in /work/p1/da (42) has an incorrect filetype (was 3, s
hould be 1).                                                                    
                                                                                
                                                                                
/dev/ram0: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.                         
        (i.e., without -a or -p options)                                        

3# fsck /dev/ram0                                      
fsck 1.41.3 (12-Oct-2008)                                                       
e2fsck 1.41.3 (12-Oct-2008)                                                     
/dev/ram0 contains a file system with errors, check forced.                     
Pass 1: Checking inodes, blocks, and sizes                                      
Pass 2: Checking directory structure                                            
Entry 'c302b' in /work/p1/da (42) has an incorrect filetype (was 3, should be 1)
.                                                                               
Fix<y>? yes                                                                     
                                                                                
Entry 'd3699' in /work/p1/da (42) is a link to directory /work/p1/da/d18a/d3874/
d278f/d2401/d3e6a/d4380/d33e8/d2a30/d3ad4/d45f3 (968).                          
Clear<y>? yes                                                                   
                                                                                
Entry 'd3ad4' in /work/p1/da/d18a/d3874/d278f/d2401/d3e6a/d4380/d33e8/d2a30 (192
) is a link to directory /work/p1/da/d207a (811).                               Clear<y>? yes                                                                   
                                                                                
Entry 'd18a' in /work/p1/da (42) is a link to directory /work/p1/da/d18a (491). 
Clear<y>? yes                                                                   
                                                                                
Pass 3: Checking directory connectivity                                         
'..' in /work/p1/da/d207a (811) is /work/p1/da/d18a/d3874/d278f/d2401/d3e6a/d438
0/d33e8/d2a30 (192), should be /work/p1/da (42).                                
Fix<y>? yes                                                                     
                                                                                
Pass 4: Checking reference counts                                               
Inode 53 ref count is 1, should be 2.  Fix<y>? yes                                                                                                              
Inode 67 ref count is 1, should be 2.  Fix<y>? yes                              
                                                                                
Inode 86 ref count is 3, should be 4.  Fix<y>? yes                              
                                                                                
...

Inode 945 ref count is 1, should be 2.  Fix<y>? yes                             
                                                                                
Inode 993 ref count is 7, should be 8.  Fix<y>? yes                             
                                                                                
Pass 5: Checking group summary information                                      
                                                                                
/dev/ram0: ***** FILE SYSTEM WAS MODIFIED *****                                 /dev/ram0: 1024/1024 files (18.4% non-contiguous), 4094/4096 blocks             


--xB0nW4MQa6jZONgY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ext4.htree.txt"

-------------------------------------------------------------                   
Cycle 9                                                                         
Fri Mar 20 08:18:28 EDT 2009                                                    
Mounting                                                                        
[ 1870.516310] EXT4-fs: barriers enabled                                        
[ 1870.520359] kjournald2 starting: pid 5729, dev ram1:8, commit interval 5 seco
nds                                                                             
Removing old fss[ 1870.520396] EXT4 FS on ram1, internal journal on ram1:8      
tress data                                                                      
[ 1870.520399] EXT4-fs: delayed allocation enabled                              
[ 1870.520401] EXT4-fs: file extents enabled                                    
[ 1870.520553] EXT4-fs: mballoc enabled                                         
[ 1870.520556] EXT4-fs: mounted filesystem ram1 with ordered data mode          
[ 1870.570047] JBD: barrier-based sync failed on ram1:8 - disabling barriers    
Starting fsstress                                                               
Sleeping 30 seconds                                                             
seed = 1237467072                                                               
Stopping fsstress                                                                5732 ttyS0    00:00:00 fsstress_ext4                                           
 5735 ttyS0    00:00:28 fsstress_ext4                                           
 5736 ttyS0    00:00:28 fsstress_ext4                                           
 5737 ttyS0    00:00:28 fsstress_ext4                                           
./brd_test_ext4.sh: line 36:  5732 Terminated              `pwd`/fsstress_ext4 -
d $TESTDIR/work -p 3 -l 0 -n 100000000                                          
Unmounting                                                                      
[ 1901.751383] EXT4-fs: mballoc: 7905 blocks 4022 reqs (13 success)             
[ 1901.757443] EXT4-fs: mballoc: 8495 extents scanned, 341 goal hits, 6 2^N hits
, 4 breaks, 38 lost                                                             
[ 1901.766253] EXT4-fs: mballoc: 1 generated and it took 2140                   
[ 1901.771755] EXT4-fs: mballoc: 18857 preallocated, 11619 discarded            
Checking                                                                        
/dev/ram1: HTREE directory inode 20 has an invalid root node.                   
HTREE INDEX CLEARED.                                                            
/dev/ram1: HTREE directory inode 40 has an invalid root node.                   
HTREE INDEX CLEARED.                                                            
/dev/ram1: Entry 'f15e2' in /work/p0/d5/db/d934 (20) has an incorrect filetype (
was 1, should be 3).                                                            
                                                                                
                                                                                
/dev/ram1: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.                         
        (i.e., without -a or -p options)                                        
# fsck /dev/ram1                                      
fsck 1.41.3 (12-Oct-2008)                                                       
e2fsck 1.41.3 (12-Oct-2008)                                                     
/dev/ram1 contains a file system with errors, check forced.                     
Pass 1: Checking inodes, blocks, and sizes                                      
Pass 2: Checking directory structure                                            
Entry 'f15e2' in /work/p0/d5/db/d934 (20) has an incorrect filetype (was 1, shou
ld be 3).                                                                       
Fix<y>? yes                                                                     
                                                                                
Entry 'd51' in /work/p0/d5/db/d934 (20) is a link to directory /work/p0/d5/db/d9
34/d51 (110).                                                                   Clear<y>? yes                                                                   
                                                                                
Entry 'd1cba' in /work/p0/d5/db/d934 (20) is a link to directory /work/p0/d5/db/
d934/d1cba (918).                                                               
Clear<y>? yes                                                                   
                                                                                
Entry 'd17f8' in /work/p0/d5/db/d203c (40) is a link to directory /work/p0/d5/db
/d203c/d17f8 (392).                                                             
Clear<y>? yes                                                                   
                                                                                
Pass 3: Checking directory connectivity                                         
Pass 4: Checking reference counts                                               
Inode 36 ref count is 2, should be 3.  Fix<y>? yes                              
                                                                                
Inode 37 ref count is 2, should be 3.  Fix<y>? yes                              
                                                                                
Inode 55 ref count is 2, should be 3.  Fix<y>? yes                              
                                                                                
.....
                                                                                
Inode 655 ref count is 4, should be 5.  Fix<y>? yes                             
                                                                                Inode 1024 ref count is 4, should be 5.  Fix<y>? yes                            
                                                                                
Pass 5: Checking group summary information                                      
                                                                                
/dev/ram1: ***** FILE SYSTEM WAS MODIFIED *****                                 
/dev/ram1: 1024/1024 files (24.2% non-contiguous), 4096/4096 blocks             

--xB0nW4MQa6jZONgY--
