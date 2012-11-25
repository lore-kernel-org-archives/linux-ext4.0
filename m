From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH 0/6] Optimize e2fsck for large file systems
Date: Sun, 25 Nov 2012 00:09:13 -0500
Message-ID: <20121125050913.GA14506@thunk.org>
References: <1353803794-11593-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34523 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708Ab2KYFJQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 Nov 2012 00:09:16 -0500
Content-Disposition: inline
In-Reply-To: <1353803794-11593-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Oops, sorry, I screwed up the "before" numbers.  Here are the proper
(apples-to-apples) comparisons; the results are not quite as
eye-popping, but there is still a significant (3x in wall clock time)
improvement...

Before...

Pass 1: Checking inodes, blocks, and sizes
Pass 1: Memory used: 916k/31500k (719k/198k), time: 96.48/81.26/ 0.10
Pass 1: I/O read: 8MB, write: 0MB, rate: 0.08MB/s
Pass 2: Checking directory structure
Pass 2: Memory used: 916k/62064k (704k/212k), time:  0.46/ 0.01/ 0.03
Pass 2: I/O read: 4MB, write: 0MB, rate: 8.72MB/s
Pass 3: Checking directory connectivity
Peak memory: Memory used: 916k/62064k (705k/212k), time: 97.56/81.88/ 0.13
Pass 3A: Memory used: 916k/62064k (736k/181k), time:  0.00/ 0.00/ 0.00
Pass 3A: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 3: Memory used: 916k/62064k (693k/223k), time:  0.00/ 0.00/ 0.00
Pass 3: I/O read: 1MB, write: 0MB, rate: 1257.86MB/s
Pass 4: Checking reference counts
Pass 4: Memory used: 916k/936k (602k/315k), time:  6.59/ 6.55/ 0.02
Pass 4: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 5: Checking group summary information
Pass 5: Memory used: 1048k/936k (569k/480k), time: 93.39/80.92/ 0.69
Pass 5: I/O read: 117MB, write: 0MB, rate: 1.25MB/s
Memory used: 1048k/936k (569k/480k), time: 197.58/169.36/ 0.84
I/O read: 129MB, write: 0MB, rate: 0.65MB/s
169.36user 0.90system 3:17.66elapsed 86%CPU (0avgtext+0avgdata 254192maxresident)k
0inputs+0outputs (12major+16066minor)pagefaults 0swaps

.... and after....

Pass 1: Checking inodes, blocks, and sizes
Pass 1: Memory used: 916k/31500k (719k/198k), time: 17.83/ 2.79/ 0.05
Pass 1: I/O read: 8MB, write: 0MB, rate: 0.45MB/s
Pass 2: Checking directory structure
Pass 2: Memory used: 916k/62064k (704k/212k), time:  0.45/ 0.01/ 0.01
Pass 2: I/O read: 4MB, write: 0MB, rate: 8.82MB/s
Pass 3: Checking directory connectivity
Peak memory: Memory used: 916k/62064k (704k/212k), time: 18.89/ 3.39/ 0.07
Pass 3A: Memory used: 916k/62064k (735k/181k), time:  0.00/ 0.00/ 0.00
Pass 3A: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 3: Memory used: 916k/62064k (693k/224k), time:  0.00/ 0.00/ 0.00
Pass 3: I/O read: 1MB, write: 0MB, rate: 1265.82MB/s
Pass 4: Checking reference counts
Pass 4: Memory used: 916k/936k (601k/315k), time:  5.69/ 5.67/ 0.00
Pass 4: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 5: Checking group summary information
Pass 5: Memory used: 1048k/936k (569k/480k), time: 22.76/10.49/ 0.53
Pass 5: I/O read: 117MB, write: 0MB, rate: 5.14MB/s
Memory used: 1048k/936k (569k/480k), time: 47.38/19.57/ 0.60
I/O read: 129MB, write: 0MB, rate: 2.72MB/s

