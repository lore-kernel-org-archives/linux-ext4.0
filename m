From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: debuge2fs not displaying /dev folder
Date: Tue, 15 Jan 2013 10:43:49 -0700
Message-ID: <CF3C02F1-C284-4E7F-9921-C6DB21A33EE5@dilger.ca>
References: <CAD6i1f+GzTqewnV=2OefPTGT8YFzNo6+zmoPvxuJXMb9r0ABng@mail.gmail.com> <CAD6i1f+p0-W2Pf-Pcf6phTNqrzn6h3OG+zXM3nc9hULdKq1zvw@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Prashant Shah <pshah.mumbai@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:58076 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab3AORpG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jan 2013 12:45:06 -0500
Received: by mail-pa0-f49.google.com with SMTP id bi1so240544pad.8
        for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2013 09:45:05 -0800 (PST)
In-Reply-To: <CAD6i1f+p0-W2Pf-Pcf6phTNqrzn6h3OG+zXM3nc9hULdKq1zvw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On 2013-01-14, at 11:01 PM, Prashant Shah wrote:
> When using debuge2fs on a ext3 partition the /dev partition does not
> show any entries at all. While running it on a ext4 partition only
> part of entries are shown for /dev.
> 
> Below is the list of files and folder within /dev folder residing on
> a ext4 partition. Using "debugfs" shows around 92 entries while "ls"
> shows around 217 entries. A block level dump also shows the same
> folders as "debugfs".

The first and most important question is whether "/dev" is a real
filesystem, or if it is a virtual (e.g. "tmpfs" type) filesystem
on your machine?

> --------------------- debugfs --------------------
> 3014659  (12) .    2  (12) ..    3014663  (12) fd    3014664  (16) mapper
> 3014665  (12) pts    3014666  (12) shm    3014667  (16) agpgart
> 
> 
> --------- from ls -----------
> autofs           ecryptfs  loop6               pts    random    sr0
> tty2   tty35  tty50  tty9       ttyS22  uinput      vcsa2
> block            fb0       loop7               ram0   rfkill    stderr

It would be useful to show "ls -li" information for some of the
entries that appear via debugfs (e.g. "fd", "pts", and "shm" above),
and also some of the entries that do not appear in debugfs.

Cheers, Andreas





