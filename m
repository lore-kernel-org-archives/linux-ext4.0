From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH v2 0/2] fs/ext4: mballoc.c: silence two UBSAN reports
Date: Sat, 19 Mar 2016 22:12:03 +0100
Message-ID: <1458421925-5481-1-git-send-email-nicstange@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Nicolai Stange <nicstange@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

v1 can be found here:

  http://lkml.kernel.org/g/1458417247-3164-1-git-send-email-nicstange@gmail.com


Unfortunately, I failed to recognize that the very same issue fixed by v1
appears again at another place in fs/ext4/mballoc.c.

Hence a v2 with the [2/2] addressing that second occurence.


Applicable to linux-next-20160318.


Changes to v1:

 [1/2] ("fs/ext4: mb_find_order_for_block(): silence UBSAN")
  - corrected GCC version from 4.6.0 to 6.0.0 in commit message 

 [2/2] ("fs/ext4: ext4_mb_init(): silence UBSAN")
  - new.


Nicolai Stange (2):
  fs/ext4: mb_find_order_for_block(): silence UBSAN
  fs/ext4: ext4_mb_init(): silence UBSAN

 fs/ext4/mballoc.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

-- 
2.7.3
