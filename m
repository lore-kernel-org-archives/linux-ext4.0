From: Denis Karpov <ext-denis.2.karpov@nokia.com>
Subject: Re: Error testing ext3 on brd ramdisk
Date: Fri, 20 Mar 2009 15:35:11 +0200
Message-ID: <20090320133511.GK21564@smart.research.nokia.com>
References: <49AFAFD9.9050805@dti2.net> <49AFC1A9.90501@dti2.net> <20090310161247.GA19352@wotan.suse.de> <20090310163002.GC19352@wotan.suse.de> <49B69A09.3080408@dti2.net> <20090311021920.GA16561@wotan.suse.de> <49BA927F.8020701@dti2.net> <20090317094019.GA10360@smart.research.nokia.com> <20090318121116.GC14622@wotan.suse.de> <20090318134202.GB11965@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="gMR3gsNFwZpnI/Ts"
Cc: Nick Piggin <npiggin@suse.de>,
	"ext Jorge Boncompte [DTI2]" <jorge@dti2.net>,
	"Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: ext Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:42495 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbZCTNf5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Mar 2009 09:35:57 -0400
Content-Disposition: inline
In-Reply-To: <20090318134202.GB11965@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--gMR3gsNFwZpnI/Ts
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 18, 2009 at 02:42:02PM +0100, ext Jan Kara wrote:
> > On Tue, Mar 17, 2009 at 11:40:19AM +0200, Denis Karpov wrote:
> > Jan's fixes are here:
> > http://marc.info/?l=linux-ext4&m=123731584711382&w=2
> > It would be interesting to try them, and if they don't work maybe
> > he's also interested so I cc'ed him.

Hello, 

I've re-run the tests (with Jan's patches and also Nick's "fs: new inode
i_state corruption fix" patch).

> > > In both cases I saw some complains from JBD/JBD2:
> > >  JBD: Detected IO errors while flushing file data on
>   Yes, my patches fix exactly this problem. So please try running with
> them. I'm not sure about that HTREE corruption you see during fsck. That
> seems to be a separate issue.

The issue with JBD seems to be gone. But problem with HTREE being corrupted
still remains (see attached logs).

Denis

--gMR3gsNFwZpnI/Ts
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ext3.htree.1.txt"

-------------------------------------------------------------                   
Cycle 26                                                                        
Fri Mar 20 09:23:50 EDT 2009                                                    
Mounting                                                                        
[  907.443733] EXT3 FS on ram0, internal journal                                
[  907.448199] EXT3-fs: mounted filesystem with ordered data mode.              
[  907.448529] kjournald starting.  Commit interval 5 seconds                   
Removing old fsstress data                                                      
Starting fsstress                                                               
Sleeping 30 seconds                                                             
seed = 1237468251                                                               
Stopping fsstress                                                               
 5656 ttyS0    00:00:00 fsstress_ext3                                           
 5659 ttyS0    00:00:26 fsstress_ext3                                           
 5660 ttyS0    00:00:25 fsstress_ext3                                           
 5661 ttyS0    00:00:25 fsstress_ext3                                           
./brd_test_ext3.sh: line 37:  5656 Terminated              `pwd`/fsstress_ext3 -
d $TESTDIR/work -p 3 -l 0 -n 100000000                                          Unmounting                                                                      
Checking                                                                        
/dev/ram0: HTREE directory inode 82 has an invalid root node.                   
HTREE INDEX CLEARED.                                                            
/dev/ram0: Entry 'c17e8' in /work/p1/d2/d99 (82) has an incorrect filetype (was 
3, should be 1).                                                                
                                                                                
                                                                                
/dev/ram0: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.                         
        (i.e., without -a or -p options)                                        

# fsck.ext3 /dev/ram0                                 
e2fsck 1.41.3 (12-Oct-2008)                                                     
/dev/ram0 contains a file system with errors, check forced.                     
Pass 1: Checking inodes, blocks, and sizes                                      
Pass 2: Checking directory structure                                            
Entry 'c17e8' in /work/p1/d2/d99 (82) has an incorrect filetype (was 3, should b
e 1).                                                                           
Fix<y>? yes                                                                     
                                                                                
Entry 'fdab' in /work/p1/d2/d99 (82) has an incorrect filetype (was 1, should be
 7).                                                                            
Fix<y>? yes                                                                     
                                                                                
Entry 'c17fa' in /work/p1/d2/d99 (82) has an incorrect filetype (was 3, should be 1).                                                                           
Fix<y>? yes                                                                     
                                                                                
Entry 'da0' in /work/p1/d2/d99 (82) is a link to directory /work/p1/d2/d99/da0 (
238).                                                                           
Clear<y>? yes                                                                   
                                                                                
Pass 3: Checking directory connectivity                                         
Pass 4: Checking reference counts                                               
Inode 83 ref count is 9, should be 10.  Fix<y>? yes                             
                                                                                
Inode 94 ref count is 3, should be 4.  Fix<y>? yes                                                                                                              
Inode 99 ref count is 9, should be 10.  Fix<y>? yes                             
                                                                                ...

Inode 1018 ref count is 2, should be 3.  Fix<y>? yes                            
                                                                                
Inode 1024 ref count is 1, should be 2.  Fix<y>? yes                            
                                                                                
Pass 5: Checking group summary information                                      
                                                                                
/dev/ram0: ***** FILE SYSTEM WAS MODIFIED *****                                 
/dev/ram0: 1024/1024 files (12.0% non-contiguous), 4096/4096 blocks             

--gMR3gsNFwZpnI/Ts
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ext4.htree.1.txt"

-------------------------------------------------------------
Cycle 5
Fri Mar 20 09:17:50 EDT 2009
Mounting
Removing old fsstress data
Starting fsstress
Sleeping 30 seconds
seed = 1237604365
Stopping fsstress
 5370 pts/0    00:00:00 fsstress_ext4
 5373 pts/0    00:00:19 fsstress_ext4
 5374 pts/0    00:00:20 fsstress_ext4
 5375 pts/0    00:00:19 fsstress_ext4
./brd_test_ext4.sh: line 36:  5370 Terminated              `pwd`/fsstress_ext4 -d $TESTDIR/work -p 3 -l 0 -n 100000000
Unmounting
Checking
/dev/ram1: HTREE directory inode 165 has an invalid root node.
HTREE INDEX CLEARED.
/dev/ram1: HTREE directory inode 272 has an invalid root node.
HTREE INDEX CLEARED.
/dev/ram1: Entry 'c363' in /work/p2/d2/de/d5f/d80/d616 (272) has an incorrect filetype (was 3, should be 1).


/dev/ram1: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
        (i.e., without -a or -p options)
# fsck.ext4 /dev/ram1
e2fsck 1.41.3 (12-Oct-2008)
/dev/ram1 contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Entry 'c363' in /work/p2/d2/de/d5f/d80/d616 (272) has an incorrect filetype (was 3, should be 1).
Fix<y>? yes

Entry 'c10b5' in /work/p2/d2/de/d37 (165) has an incorrect filetype (was 3, should be 1).
Fix<y>? yes

Entry 'f164' in /work/p2/d2/de/d37 (165) has an incorrect filetype (was 1, should be 3).
Fix<y>? yes

Entry 'f104e' in /work/p2/d2/de/d37 (165) has an incorrect filetype (was 1, should be 2).
Fix<y>? yes

Entry 'deaa' in /work/p2/d2/de/d5f/d80/d616 (272) is a link to directory /work/p2/d2/de/d5f/d80/d616/deaa (819).
Clear<y>? yes

Entry 'd155a' in /work/p2/d2/de/d37 (165) is a link to directory /work/p2/d2/de/d37/d155a (434).
Clear<y>? yes

Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Inode 25 ref count is 6, should be 7.  Fix<y>? yes

Inode 48 ref count is 1, should be 2.  Fix<y>? yes

...

Inode 1003 ref count is 3, should be 4.  Fix<y>? yes

Inode 1004 ref count is 1, should be 2.  Fix<y>? yes

Pass 5: Checking group summary information

/dev/ram1: ***** FILE SYSTEM WAS MODIFIED *****
/dev/ram1: 1024/1024 files (20.5% non-contiguous), 4096/4096 blocks



--gMR3gsNFwZpnI/Ts--
