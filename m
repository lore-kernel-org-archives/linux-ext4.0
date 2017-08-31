From: Ashlie Martinez <ashmrtn@utexas.edu>
Subject: [RFC][PATCH] fstest: regression test for ext4 crash consistency bug
Date: Wed, 30 Aug 2017 20:28:16 -0500
Message-ID: <7f4519d6-9e3f-c036-b72d-8a387bf657d3@utexas.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tytso@mti.edu, eguan@redhat.com, jbacik@fb.com, vvijay03@gmail.com,
        fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: amir73il@gmail.com
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: 
Content-Language: en-US
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Amir,

I have been working on CrashMonkey more and I have jerry-rigged together 
a test in CrashMonkey that calls into `fsx` with the minimal test case 
you made. I am able to reproduce the ext4 error that you found along 
with a few other potential errors.

A quick point, I run fsck with `-yf` instead of `-nf` that xfstests runs 
with. The reason for this is that CrashMonkey would like to report on 
fixable and unfixable errors in the future.

Running the ported test case, I find that CrashMonkey encounters the 
following errors:
1. Incorrect inode size and incorrect free data block and inode counts 
(fixable)
2. incorrect free data block and inode counts (fixable)
3. `Superblock needs_recovery flag is clear, but journal has data` 
notice along with errors present in case 1
4. `Superblock needs_recovery flag is clear, but journal has data` 
notice with no other errors

For the incorrect i_size errors, I get the output `Inode 12, i_size is 
147456, should be 163840.` which I can also reproduce with your 501 
xfstests test case.

When free data blocks and inode errors occur, the message is `Free 
blocks count wrong (8795, counted=8714).` and `Free inodes count wrong 
(2549, counted=2546).`

I have not had a chance to look into the above errors to find their root 
causes.

In total, CrashMonkey ran 1000 different tests. Of those, 344 passed 
without fsck complaining. The remaining 656 tests saw fsck complain 
about something. All of these tests consisted of unique sequences of 
bios, but may contain equivalent crash states.

The larger range of test results is due to the fact that CrashMonkey 
runs many tests from just the single workload you made. These tests 
consist of replaying some number of bio write operations, so it tests 
states different than you 500 xfstest which I believe only replays to 
sync operations (i.e. it never stops replay before a recorded fsync).

If you're interested, you can find the CrashMonkey code (and branch) at 
https://github.com/utsaslab/crashmonkey/tree/ext4_regression_bug. If you 
would like to run it, you should clone and build you xfstest in your 
home directory so that the jerry-rigged CrashMonkey test case can find 
it. Directions for running this test case in CrashMonkey should be at 
the top of the README.
