From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Large buffer cache in EXT4
Date: Sat, 16 Feb 2013 23:28:53 -0700
Message-ID: <6F61E227-A6F7-4AD6-9B9C-39E9E9EAABFA@dilger.ca>
References: <CAEUQcegw=gq9ndo=Zd4xC2gJDZrRzNpS2hAZW9x5Lh=KL_YDHQ@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Subranshu Patel <spatel.ml@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:36141 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab3BQG24 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Feb 2013 01:28:56 -0500
Received: by mail-pb0-f49.google.com with SMTP id xa12so1168688pbc.22
        for <linux-ext4@vger.kernel.org>; Sat, 16 Feb 2013 22:28:56 -0800 (PST)
In-Reply-To: <CAEUQcegw=gq9ndo=Zd4xC2gJDZrRzNpS2hAZW9x5Lh=KL_YDHQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-02-16, at 21:04, Subranshu Patel <spatel.ml@gmail.com> wrote:

> I created 2 filesystem on my system (RHEL 6.3, kernel version 2.6.32)
> - XFS and EXT4 and mounted them.
> 
> On both the filesystem I executed the mdtest tool(opensource tool) for
> 64 concurrent process. Each process performed the following:
> - Create large number of directories
> - Remove all the directories
> 
> During this time I monitored the memory usage of the system using sar
> command. I checked the 3 components - kbmemused, kbbuffers and
> kbcached
> 
> kbmemused - Amount of used memory in kilobytes. This does not take
> into account memory used by the kernel itself.
> kbbuffers - buffer cache
> kbcached - page cache
> 
> While the kbmemused and kbcached component was almost similar in EXT4
> and XFS (XFS being a little higher), the kbbuffer showed a totally
> different trend.
> 
> For EXT4, kbbuffers was:
> 390999KB for dir creation
> 364803KB for dir removal
> For XFS, kbbuffers was:
> 
> 1701KB for dir creation
> 2738KB for dir removal
> 
> In kernel 2.6, both buffer cache and page cache are merged. The page
> cache caches pages of files. The buffer cache caches disk blocks which
> consists of mainly metadata (not file data).
> 
> Why is the buffer cache large in case of EXT4 and what is stored in
> the buffer cache?

XFS does not use buffer cache, while ext[234] does use buffer cache. 

This is just a different code design. Ext4 uses the buffer cache to track metadata for journaling. 

Cheers, Andreas