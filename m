From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: Collecting aged Ext4 profiles
Date: Mon, 17 Jul 2017 11:56:12 +0200
Message-ID: <20170717095612.3gafcg46wv5dnn5c@localhost.localdomain>
References: <6F8D59B2-0630-4405-BC85-D634B122F3C8@cs.cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org, spetrovi@redhat.com
To: Saurabh Kadekodi <saukad@cs.cmu.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54124 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751265AbdGQJ4P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 17 Jul 2017 05:56:15 -0400
Content-Disposition: inline
In-Reply-To: <6F8D59B2-0630-4405-BC85-D634B122F3C8@cs.cmu.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

my collegue Samuel Petrovic <spetrovi@redhat.com> has done some research
in this area as well, so maybe you may find it useful to compare notes.
Adding him to cc.

Cheers,
-Lukas


On Sat, Jul 15, 2017 at 05:14:21PM -0700, Saurabh Kadekodi wrote:
> Hi,
> 
> I am a PhD student studying file and storage systems and I am currently conducting research on local file system aging. My research aims at understanding realistic aging patterns and analyzing the effects of aging on file system data structures and its performance. For this purpose, I would like to capture characteristics of naturally aged file systems (i.e. not aged via synthetic workload generators).
> 
> In order to facilitate this profile capture, I have written a shell / python based profiling tool (fsagestats - https://github.com/saurabhkadekodi/fsagestats)  that does a file system tree walk and captures different characteristics (file age, file size and directory depth) of files and directories and produces distributions. I do not care about file names or data within each file. It also runs e2freefrag in order to understand the level of free space fragmentation, e4defrag in order to capture the fragmentation score, and copies a large file (~ 2GB) and runs filefrag in order to understand the file fragmentation, all of which are directly correlated with the file system performance. It dumps the results in the results dir, which is to be specified when you run fsagestats. You can send m
 e the aging profile by tarring up the results directory and sending it via email.
> 
> Since I do not have access to Ext4 systems that see a lot of churn, I am reaching out to the Ext4 community in order to find volunteers willing to run my script and capture their Ext4 aging profile. Please feel free to modify the script as per your installation or as you see fit. Since fsagestats collects no private information, I eventually intend to host these profiles publicly (unless explicitly requested not to) to aid other researchers / enthusiasts.
> 
> In case you have any questions on concerns, please let me know.
> 
> Thanks,
> Saurabh Kadekodi
> 
> PS: cc’ing the response and / or the aging profile to saukad@cs.cmu.edu is greatly appreciated.
