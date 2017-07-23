From: Saurabh Kadekodi <saukad@cs.cmu.edu>
Subject: Re: Collecting aged Ext4 profiles
Date: Sat, 22 Jul 2017 18:40:40 -0700
Message-ID: <C2BFD8B1-9033-4A6D-A30C-D4845D381FDD@cs.cmu.edu>
References: <6F8D59B2-0630-4405-BC85-D634B122F3C8@cs.cmu.edu>
 <D52E9B43-C169-4C71-BFDA-0100C75FEDC1@dilger.ca>
 <5BCA327F-3BE1-43E0-802B-1656568FD7D2@dilger.ca>
 <808EFE67-E7CF-4BA7-9930-67AD1B4832B8@cs.cmu.edu>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp02.srv.cs.cmu.edu ([128.2.217.201]:63717 "EHLO
        smtp02.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752080AbdGWBko (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 22 Jul 2017 21:40:44 -0400
In-Reply-To: <808EFE67-E7CF-4BA7-9930-67AD1B4832B8@cs.cmu.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

fsstats captures most of the stuff I want to (age and size distributions). It does not capture the directory depth distribution (i.e. what fraction of the files are how deep in the fs hierarchy) which can be important in an aging study because Ext4 chooses to split high level directories in different block groups resulting in some fragmentation. fsstats also does not capture free space fragmentation and the fragmentation score, both of which are important for my study.

If fsstats is more convenient, it would be great if the following commands could also be run in order to capture the fragmentation:

1. e2freefrag ext4_dev

2. e4defrag -c mount_point

Thanks,
Saurabh

> On Jul 17, 2017, at 1:12 PM, Saurabh Kadekodi <saukad@cs.cmu.edu> wrote:
> 
> Thanks Andreas. Yes, it would be great if you could share the archive. I will go through fsstats and check the exact difference. In case it captures what I need to, I agree that using fsstats would be more apt.
> 
> Thanks,
> Saurabh
> 
>> On Jul 17, 2017, at 1:08 PM, Andreas Dilger <adilger@dilger.ca> wrote:
>> 
>> On Jul 16, 2017, at 12:34 AM, Andreas Dilger <adilger@dilger.ca> wrote:
>>> On Jul 15, 2017, at 18:14, Saurabh Kadekodi <saukad@cs.cmu.edu> wrote:
>>> 
>>>> Hi,
>>>> 
>>>> I am a PhD student studying file and storage systems and I am currently conducting research on local file system aging. My research aims at understanding realistic aging patterns and analyzing the effects of aging on file system data structures and its performance. For this purpose, I would like to capture characteristics of naturally aged file systems (i.e. not aged via synthetic workload generators).
>>>> 
>>>> In order to facilitate this profile capture, I have written a shell / python based profiling tool (fsagestats - https://github.com/saurabhkadekodi/fsagestats)  that does a file system tree walk and captures different characteristics (file age, file size and directory depth) of files and directories and produces distributions. I do not care about file names or data within each file. It also runs e2freefrag in order to understand the level of free space fragmentation, e4defrag in order to capture the fragmentation score, and copies a large file (~ 2GB) and runs filefrag in order to understand the file fragmentation, all of which are directly correlated with the file system performance. It dumps the results in the results dir, which is to be specified when you run fsagestats. You can sen
 d me the aging profile by tarring up the results directory and sending it via email.
>>>> 
>>>> Since I do not have access to Ext4 systems that see a lot of churn, I am reaching out to the Ext4 community in order to find volunteers willing to run my script and capture their Ext4 aging profile. Please feel free to modify the script as per your installation or as you see fit. Since fsagestats collects no private information, I eventually intend to host these profiles publicly (unless explicitly requested not to) to aid other researchers / enthusiasts.
>>>> 
>>>> In case you have any questions on concerns, please let me know.
>>>> 
>>>> Thanks,
>>>> Saurabh Kadekodi
>>>> 
>>>> PS: cc’ing the response and / or the aging profile to saukad@cs.cmu.edu is greatly appreciated.
>>> 
>>> How does your fsagestats tool compare to the existing fsstats tool (http://web.cs.dal.ca/~morven/CSCI3120/fsstats)?  If there isn't a significant difference between the two, it would be nice to stick with the existing tool to collect the filesystem information so that the body of data collected continues to grow.
>> 
>> Actually, a slightly better URL is https://github.com/adilger/fsstats which is a
>> proper Git repo and includes the original license.  The original project URL
>> http://www.pdsi-scidac.org/fsstats/ is no longer functional.  I also have a local
>> archive of results from that project if you are interested.
>> 
>> Cheers, Andreas
>> 
>> 
>> 
>> 
>> 
> 
