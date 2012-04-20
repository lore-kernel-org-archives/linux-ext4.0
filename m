From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC][PATCH 0/3] add FALLOC_FL_NO_HIDE_STALE flag in fallocate
Date: Fri, 20 Apr 2012 17:52:47 +0800
Message-ID: <20120420095247.GA30070@gmail.com>
References: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com>
 <4F8DAAFE.40500@redhat.com>
 <20120418040842.GA11684@gmail.com>
 <alpine.LFD.2.00.1204180919500.5310@dhcp-27-109.brq.redhat.com>
 <20120418120307.GB3447@gmail.com>
 <alpine.LFD.2.00.1204181402550.5310@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>,
	Ric Wheeler <rwheeler@redhat.com>, Ted Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger@whamcloud.com>,
	Dave Chinner <david@fromorbit.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58022 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab2DTJqN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Apr 2012 05:46:13 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1204181402550.5310@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

These days I dig this slowdown and find that the *root cause* might be
journal.  I use blktrace to grab a detailed behaviour and find the below
phenonmenon.  I post the blktrace's result in here.

[Test command]
time for((i=0;i<2000;i++)); do \
	dd if=/dev/zero of=/mnt/sda1/testfile conv=notrunc bs=4k count=1 \
	seek=`expr $i \* 16` oflag=sync,direct 2>/dev/null; \
	done

[scripts]
blktrace -d /dev/sda1
blkparse -i sda1.* -o blktrace.log
cat blktrace.log | grep 'D' | grep 'W' > result.log

[result (ext4)]
[cut]
  8,1    0       14    49.969995286    10  D  WS 38011023 + 40 [kworker/0:1]
  8,1    0       20    49.996170768     0  D  WS 38011063 + 8 [swapper/0]
  8,1    0       29    50.006811878 10011  D  WS 278719 + 8 [dd] 
  8,1    0       31    50.013996421    10  D  WS 38011071 + 24 [kworker/0:1]
  8,1    0       37    50.029656811     0  D  WS 38011095 + 8 [swapper/0]
  8,1    1       70    50.039768259 10013  D  WS 278847 + 8 [dd] 
  8,1    0       41    50.046996403    10  D  WS 38011103 + 24 [kworker/0:1]
  8,1    0       47    50.071458802     0  D  WS 38011127 + 8 [swapper/0]
  8,1    1       89    50.081529060 10015  D  WS 278975 + 8 [dd] 
  8,1    0       51    50.088996276    10  D  WS 38011135 + 24 [kworker/0:1]
  8,1    0       57    50.113247880     0  D  WS 38011159 + 8 [swapper/0]
  8,1    1      108    50.123329330 10017  D  WS 279103 + 8 [dd] 
  8,1    0       61    50.130995672    10  D  WS 38011167 + 24 [kworker/0:1]
  8,1    0       67    50.155052076     0  D  WS 38011191 + 8 [swapper/0]
  8,1    1      126    50.165154127 10019  D  WS 279231 + 8 [dd] 
  8,1    0       71    50.172995678    10  D  WS 38011199 + 24 [kworker/0:1]
  8,1    0       77    50.196855020     0  D  WS 38011223 + 8 [swapper/0]
  8,1    1      145    50.206945237 10021  D  WS 279359 + 8 [dd] 
  8,1    0       81    50.214997236    10  D  WS 38011231 + 24 [kworker/0:1]
  8,1    0       87    50.238643778     0  D  WS 38011255 + 8 [swapper/0]
  8,1    1      164    50.248738960 10023  D  WS 279487 + 8 [dd] 
  8,1    0       91    50.255996776    10  D  WS 38011263 + 24 [kworker/0:1]
  8,1    0       97    50.280447549     0  D  WS 38011287 + 8 [swapper/0]
  8,1    1      183    50.290550957 10025  D  WS 279615 + 8 [dd] 
[cut]

We can see that every one write operation needs to do two journal
writes, one writes journal header and data, and another writes commit.

Then I run the same benchmark in xfs to do a comparison.  This
comparison just aims to explain why the slowdown occurs in ext4.

[result (xfs)]
[cut]
  8,1    0       70     0.256951000     0  D WSM 40162600 + 3 [swapper/0]
  8,1    1       50     0.271551873 12575  D  WS 1311 + 8 [dd] 
  8,1    0       78     0.282466586     0  D WSM 40162603 + 3 [swapper/0]
  8,1    1       55     0.296547264 12577  D  WS 1439 + 8 [dd] 
  8,1    0       86     0.307978442     0  D WSM 40162606 + 3 [swapper/0]
  8,1    1       60     0.321578789 12579  D  WS 1567 + 8 [dd] 
  8,1    0       94     0.333494988     0  D WSM 40162609 + 3 [swapper/0]
  8,1    1       65     0.346582549 12581  D  WS 1695 + 8 [dd] 
  8,1    0      102     0.359005937     0  D WSM 40162612 + 3 [swapper/0]
  8,1    1       70     0.371613387 12583  D  WS 1823 + 8 [dd] 
  8,1    0      110     0.384552158     0  D WSM 40162615 + 3 [swapper/0]
  8,1    1       75     0.396604067 12585  D  WS 1951 + 8 [dd] 
  8,1    0      118     0.410062404     0  D WSM 40162618 + 3 [swapper/0]
  8,1    1       80     0.421614702 12587  D  WS 2079 + 8 [dd] 
  8,1    0      126     0.436783655     0  D WSM 40162621 + 3 [swapper/0]
  8,1    1       85     0.454989457 12589  D  WS 2207 + 8 [dd] 
  8,1    0      134     0.470633321     0  D WSM 40162624 + 3 [swapper/0]
  8,1    1       90     0.488311574 12591  D  WS 2335 + 8 [dd] 
  8,1    0      142     0.504477295     0  D WSM 40162627 + 3 [swapper/0]
  8,1    1       95     0.521675622 12593  D  WS 2463 + 8 [dd] 
  8,1    0      150     0.538326978     0  D WSM 40162630 + 3 [swapper/0]
  8,1    1      100     0.555016257 12595  D  WS 2591 + 8 [dd] 
  8,1    0      158     0.563839349     0  D WSM 40162633 + 4 [swapper/0]
  8,1    1      105     0.580049767 12597  D  WS 2719 + 8 [dd] 
  8,1    0      166     0.589336947     0  D WSM 40162637 + 4 [swapper/0]
  8,1    1      110     0.605037173 12599  D  WS 2847 + 8 [dd] 
  8,1    0      174     0.614850369     0  D WSM 40162641 + 4 [swapper/0]
  8,1    1      115     0.630078920 12601  D  WS 2975 + 8 [dd] 
[cut]

The result shows that every one write in xfs only needs to do one
journal write.  Meanwhile the size of journal write is smaller than the
size of ext4.  Certainly, in modern disk, I believe that the disk writes
64k as easily as 4k.  So, IMO, twice journal writes is the *root
*cause*.  I use 'wc -l' to roughly count the number of I/Os.

$ wc -l result.log
ext4:	6018
xfs:	4021
ratio:	1.5:1

The benchmark result:
ext4:	75.615s
xfs:	54.395s
ratio:	1.4:1

Now, in JBD2, it at least needs to do two journal writes.  I have an
idea to solve this problem, and I will send a new RFC to the mailing
list.

Please feel free to review it.  Any comments are welcome.  Thank you.

Regards,
Zheng
