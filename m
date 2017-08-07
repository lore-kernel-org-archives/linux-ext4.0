From: Sodagudi Prasad <psodagud@codeaurora.org>
Subject: variable length array in structure
Date: Mon, 07 Aug 2017 11:41:41 -0700
Message-ID: <905bed7660ebcd6c81c2f7e1a01384a4@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: arnd@arndb.de, tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Arnd Bergmann,

Following commit have introduced compilation issue.
commit 2df2c3402fc81918a888e1ec711369f6014471f2
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Sat Aug 5 21:57:46 2017 -0400
     ext4: fix warning about stack corruption

Observed following error -
/fs/ext4/mballoc.c:2303:17: error: fields must have a constant size: 
'variable length array in structure' extension will never be supported
                 ext4_grpblk_t counters[blocksize_bits + 2];

-Thanks, Prasad
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum,
Linux Foundation Collaborative Project
