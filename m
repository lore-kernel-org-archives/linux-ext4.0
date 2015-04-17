From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 2/3] ext4: Speedup ext4 orphan inode handling
Date: Fri, 17 Apr 2015 09:09:40 +0300
Message-ID: <CAOQ4uxh4B9WpzdkZipwcbpa4EQ4xDuzH60h-GOadYkxr_iaGLw@mail.gmail.com>
References: <1429198977-5637-1-git-send-email-jack@suse.cz>
	<1429198977-5637-3-git-send-email-jack@suse.cz>
	<CAOQ4uxifVr1swHb5Y2M-TRuzwdDo-z92G6PuHvBGecGZ7nYuHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:35935 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbbDQGJm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Apr 2015 02:09:42 -0400
Received: by lagv1 with SMTP id v1so72646616lag.3
        for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2015 23:09:40 -0700 (PDT)
In-Reply-To: <CAOQ4uxifVr1swHb5Y2M-TRuzwdDo-z92G6PuHvBGecGZ7nYuHg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

I am sure you considered the option of EXT4_ORPHAN_DIR_INO,
a directory being an existing vessel for storing inodes.

I imagine that using directory would reduce the complexity of the patch (?)
What were your reasons for choosing the orphan file solution?

Cheers,
Amir.


> On Thu, Apr 16, 2015 at 6:42 PM, Jan Kara <jack@suse.cz> wrote:
>>
>> Ext4 orphan inode handling is a bottleneck for workloads which heavily
>> truncate / unlink small files since it contends on the global
>> s_orphan_mutex lock (and generally it's difficult to improve scalability
>> of the ondisk linked list of orphaned inodes).
>>
>> This patch implements new way of handling orphan inodes. Instead of
>> linking orphaned inode into a linked list, we store it's inode number in
>> a new special file which we call "orphan file". Currently we still
>> protect the orphan file with a spinlock for simplicity but even in this
>> setting we can substantially reduce the length of the critical section
>> and thus speedup some workloads.
>>
>> Note that the change is backwards compatible when the filesystem is
>> clean - the existence of the orphan file is a compat feature, we set
>> another ro-compat feature indicating orphan file needs scanning for
>> orphaned inodes when mounting filesystem read-write. This ro-compat
>> feature gets cleared on unmount / remount read-only.
>>
>> Some performance data from 48 CPU Xeon Server with 32 GB of RAM,
>> filesystem located on ramdisk, average of 5 runs:
>>
>> stress-orphan (microbenchmark truncating files byte-by-byte from N
>> processes in parallel)
>>
>> Threads Time            Time
>>         Vanilla         Patched
>>   1       1.602800        1.260000
>>   2       4.292200        2.455000
>>   4       6.202800        3.848400
>>   8      10.415000        6.833000
>>  16      18.933600       12.883200
>>  32      38.517200       25.342200
>>  64      79.805000       50.918400
>> 128     159.629200      102.666000
>>
>> reaim new_fserver workload (tweaked to avoid calling sync(1) after every
>> operation)
>>
>> Threads Jobs/s          Jobs/s
>>         Vanilla         Patched
>>   1      24375.00        22941.18
>>  25     162162.16       278571.43
>>  49     222209.30       331626.90
>>  73     280147.60       419447.52
>>  97     315250.00       481910.83
>> 121     331157.90       503360.00
>> 145     343769.00       489081.08
>> 169     355549.56       519487.68
>> 193     356518.65       501800.00
>>
>> So in both cases we see significant wins all over the board.
>>
>> Signed-off-by: Jan Kara <jack@suse.cz>
>> ---
>>  fs/ext4/ext4.h  |  52 +++++++++++--
>>  fs/ext4/namei.c |  95 +++++++++++++++++++++--
>>  fs/ext4/super.c | 237
>> ++++++++++++++++++++++++++++++++++++++++++++++++--------
>>  3 files changed, 341 insertions(+), 43 deletions(-)
>>
