From: Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH 3/3] Add inode table initialization code into Ext4
Date: Thu, 26 Aug 2010 19:03:22 +0800
Message-ID: <AANLkTimRZ5Cbi7k+=-fQzc8ywpb6u-s19f7UdFdpMJFt@mail.gmail.com>
References: <1282326704-14838-1-git-send-email-lczerner@redhat.com> <1282326704-14838-4-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org, rwheeler@redhat.com,
	sandeen@redhat.com, jack@suse.cz, tytso@mit.edu, adilger@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34467 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab0HZLDo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Aug 2010 07:03:44 -0400
Received: by vws3 with SMTP id 3so1570451vws.19
        for <linux-ext4@vger.kernel.org>; Thu, 26 Aug 2010 04:03:43 -0700 (PDT)
In-Reply-To: <1282326704-14838-4-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, all,

On Sat, Aug 21, 2010 at 1:51 AM, Lukas Czerner <lczerner@redhat.com> wrote:
> When lazy_itable_init extended option is passed to mke2fs, it
> considerably speed up filesystem creation because inode tables are left
> uninitialized, thus contains some old data. When this fs is mounted
> filesystem code should initialize (zero out) uninitialized inode table.
> So far this code was missing for ext4 and this patch adds this feature.
>
> When file system is mounted with "inititable" mount option, new thread
> (called itableinitd) is created. This thread walks through allocation
> groups searching for the group with not yet initialized inode table.
> When such a group is found it write zeroes through whole inode table and
> put itself into sleep for defined number of seconds to not disturb other
> ongoing I/O. This is repeated until it walks through every allocation group
> then the iitableinitd thread is stopped.
This will slow down e2fsck speed that is gained from uninitialized
italbe. Am I missing something? What about having another block group
flag to tell itable that is just zeroed but not used, from itable that
is already in use?


-- 
Thanks,
-Bergwolf
