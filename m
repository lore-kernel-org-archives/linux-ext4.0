From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: XFS Tests Punch Hole v3 Change Summary
Date: Wed, 18 May 2011 13:58:30 -0700
Message-ID: <4DD432F6.7010308@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: xfs-oss <xfs@oss.sgi.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi All,

Here is v3 for XFS Tests Punch Hole.  The first patch for fsx has not 
changed, but I've added another test (test number 254).  This test is 
based off the scripts that I used to test and develop punch hole for 
ext4.  It is not done yet, but I am sending it anyway because I need 
feed back.  Right now the test works for ext4, but if I run it on xfs, 
it fails, and Im not sure if it is because it found a bug in xfs, or if 
the test is just too ext4 specific.

The test runs through various corner cases, and each time a hole is 
punched, the file is analyzed to make sure the punch was successful. 
This includes looking at the number of free/used blocks and making sure 
the correct number of blocks are released.  It also looks at the 
filefrag to make sure there are no extents where the new hole is.

The failure happens on the test that punches out the last two blocks of 
a 10 block file.  The test shows that one extra block is released.  But 
may be this is because the block accounting for xfs is different?  I 
looked at the filefrag after the test, and I noticed that there appears 
to be an extra extent after the file.  So that made me think that maybe 
there is a problem going on.

If I modify the test to stop where it fails on the xfs file system , I 
can get the filefrag as it appears on the ext4 file system:
Filesystem type is: ef53
File size of /mnt/ext4MntPt2/254.11546 is 40960 (10 blocks, blocksize 4096)
  ext logical physical expected length flags
    0       0    32850               8
/mnt/ext4MntPt2/254.11546: 1 extent found

on the xfs filesystem, it looks like this:
Filesystem type is: 58465342
File size of /mnt/ext4MntPt2/254.5916 is 40960 (10 blocks, blocksize 4096)
  ext logical physical expected length flags
    0       0       28               8
    1      11       39       35      5 eof
/mnt/ext4MntPt2/254.5916: 2 extents found

Can someone help me figure out if I need to change my test, or if I need 
to report an xfs bug?  Thx!

Allison Henderson
