From: Shehjar Tikoo <shehjart@cse.unsw.edu.au>
Subject: ext4 fallocate related crash on 2.6.26
Date: Tue, 15 Jul 2008 14:06:21 +1000
Message-ID: <487C223D.6060704@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:53015 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751406AbYGOEUn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jul 2008 00:20:43 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all

I've observed the following kernel crash during tests against ext4 
fallocate'ion support on 2.6.26.

Stack trace is at:
http://www.gelato.unsw.edu.au/~shehjart/docs/ext4_fallocate_test_trace_2.6.26.txt

The test involved running the following program which fallocates a 
given length in bytes then writes to it. The above crash was seen when 
writing to an ext4 disk, 2G file, in blocks of 64k with fallocate 
requests of 1mb. After each 1mb of data is written to the fallocated 
space, another 1mb is requested. This write-fallocate cycle continues 
till the requested file size is reached. The trace is from one of the 
crashes from the various runs(all crashed). I must emphasise that 
after one of the runs, the test disk could not be mounted as the 
filesystem was unrecognized. ext4dev was mounted in data=ordered mode.

See the test code at:
http://www.gelato.unsw.edu.au/~shehjart/docs/writefallocate.c

The command line arguments are self-explanatory. Run without any 
arguments to see the usage message. Do change the _NR_fallocate define 
at the beginning of the file to your architecture's syscall number for 
sys_fallocate.

I can run a few more tests if more info is needed.

Shehjar
PS: I am only on linux-fsdevel. So please CC if replying from another 
list.
