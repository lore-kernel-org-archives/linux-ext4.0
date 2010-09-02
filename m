From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH V2 0/3] improve the performance of some memory copy functions
Date: Thu, 02 Sep 2010 13:46:14 +0800
Message-ID: <4C7F3A26.6020607@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Ext4 <linux-ext4@vger.kernel.org>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilg
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Changes from V1 to V2:
- change the version of GPL from version 2.1 to version 2

When I looked into the performance problem of the btrfs, I found some memory
copy functions of the kernel(such as: x86_64's memmove)is very inefficient,
but the glibc version is quite fast, in some cases it is 10 times faster than
the kernel version.

This patchset introduced some macros and functions of the glibc, and improved
memmove and memcpy of the generic version and memmove of x86_64 in the kernel.

I have tested this patchset by doing 500 bytes memory copy for 50000 times
on x86_64:
			memmove
2.6.36-rc1		2s 610445us	
2.6.36-rc1 + patch	0s 257358us

After appling this patchset, the performance of the file creation and deletion
on some filesystems also become better. I have tested the file creation and
deletion performance with the following benchmark tool on my x86_64 box.
  http://marc.info/?l=linux-btrfs&m=128212635122920&q=p3

Test steps:
# ./creat_unlink 50000

The result is following(Total time):
Ext4:
		2.6.36-rc1	2.6.36-rc1 + patchset
file creation	0.771240	0.698983		9.4%UP
file deletion	0.459065	0.425530		7.3%UP


Btrfs:
		2.6.36-rc1	2.6.36-rc1 + patchset
file creation	0.966807	0.947592		1.9%UP
file deletion	1.355671	1.217787		10.2%UP

BTW: I don't know the performance of the other architectures because I don't
have the machine of those architectures, so I just improved the generic vesion
and x86_64 version. 

Who can help me to test the performance on the other architectures and compare
it with the new generic version?
