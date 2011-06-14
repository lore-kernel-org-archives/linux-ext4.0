From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: xfstests 252 failure
Date: Tue, 14 Jun 2011 08:41:27 -0700
Message-ID: <4DF78127.40505@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: xfs-oss <xfs@oss.sgi.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all,

I just wanted to get some ideas moving on this question before too much 
time goes by.  Ext4 is currently failing xfstest 252, test number 12. 
Currently test 12 is:

	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
		-c "$alloc_cmd 0 20k" \	
		-c "pwrite 8k 4k" -c "fsync" \		
		-c "$zero_cmd 4k 12k" \
		-c "$map_cmd -v" $testfile | $filter_cmd
	[ $? -ne 0 ]&&  die_now

and the output is:

         12. unwritten -> data -> unwritten
0: [0..7]: unwritten
1: [8..31]: hole
2: [32..39]: unwritten

Ext4 gets data extents here instead of unwritten extents.  I did some 
investigating and it looks like the fsync command causes the extents to 
be written out before the punch hole operation starts.  It looks like 
what happens is that when an unwritten extent gets written to, it doesnt 
always split the extent.  If the extent is small enough, then it just 
zeros out the portions that are not written to, and the whole extent 
becomes a written extent.  Im not sure if that is incorrect or if we 
need to change the test to not compare the extent types.

It looks to me that the code in ext4 that does this is supposed to be an 
optimization to help reduce fragmentation.  We could change the filters 
to print just "extent" instead of "unwritten" or "data", but I realize 
that probably makes the test a lot less effective for xfs.  If anyone 
can think of some more elegant fixes, please let me know.  Thx!

Allison Henderson

