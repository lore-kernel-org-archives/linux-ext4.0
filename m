From: Saurabh Kadekodi <saukad@cs.cmu.edu>
Subject: Collecting aged Ext4 profiles
Date: Sat, 15 Jul 2017 17:14:21 -0700
Message-ID: <6F8D59B2-0630-4405-BC85-D634B122F3C8@cs.cmu.edu>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp01.srv.cs.cmu.edu ([128.2.217.200]:56696 "EHLO
        smtp01.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751198AbdGPAOZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Jul 2017 20:14:25 -0400
Received: from [10.0.1.26] (c-24-6-102-209.hsd1.ca.comcast.net [24.6.102.209])
        (authenticated bits=0)
        by smtp01.srv.cs.cmu.edu (8.13.6/8.13.6) with ESMTP id v6G0EMLL004747
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-ext4@vger.kernel.org>; Sat, 15 Jul 2017 20:14:24 -0400 (EDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I am a PhD student studying file and storage systems and I am currently conducting research on local file system aging. My research aims at understanding realistic aging patterns and analyzing the effects of aging on file system data structures and its performance. For this purpose, I would like to capture characteristics of naturally aged file systems (i.e. not aged via synthetic workload generators).

In order to facilitate this profile capture, I have written a shell / python based profiling tool (fsagestats - https://github.com/saurabhkadekodi/fsagestats)  that does a file system tree walk and captures different characteristics (file age, file size and directory depth) of files and directories and produces distributions. I do not care about file names or data within each file. It also runs e2freefrag in order to understand the level of free space fragmentation, e4defrag in order to capture the fragmentation score, and copies a large file (~ 2GB) and runs filefrag in order to understand the file fragmentation, all of which are directly correlated with the file system performance. It dumps the results in the results dir, which is to be specified when you run fsagestats. You can send me 
 the aging profile by tarring up the results directory and sending it via email.

Since I do not have access to Ext4 systems that see a lot of churn, I am reaching out to the Ext4 community in order to find volunteers willing to run my script and capture their Ext4 aging profile. Please feel free to modify the script as per your installation or as you see fit. Since fsagestats collects no private information, I eventually intend to host these profiles publicly (unless explicitly requested not to) to aid other researchers / enthusiasts.

In case you have any questions on concerns, please let me know.

Thanks,
Saurabh Kadekodi

PS: cc’ing the response and / or the aging profile to saukad@cs.cmu.edu is greatly appreciated.
