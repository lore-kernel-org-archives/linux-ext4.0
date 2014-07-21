From: Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] fs/ext4/super.c: Let 'counters' switched by SMP
Date: Mon, 21 Jul 2014 10:40:02 -0700
Message-ID: <CAOesGMhmENA+eojUYBOCJQBNq4zcWx8C-qDCv5umNPm0it8qxg@mail.gmail.com>
References: <53C47E59.8030502@gmail.com>
	<20140715093154.GB1451@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>,
	Chen Gang <gang.chen.5i5j@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f173.google.com ([209.85.220.173]:62779 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320AbaGURkH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jul 2014 13:40:07 -0400
Received: by mail-vc0-f173.google.com with SMTP id hy10so12636217vcb.4
        for <linux-ext4@vger.kernel.org>; Mon, 21 Jul 2014 10:40:05 -0700 (PDT)
In-Reply-To: <20140715093154.GB1451@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On Tue, Jul 15, 2014 at 2:31 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Jul 15, 2014 at 09:05:29AM +0800, Chen Gang wrote:
>> When SMP is disabled, 'struct percpu_counter' has no 'counters' member,
>> so need skip it when in !SMP.
>>
>> The related git commit:
>>
>>   "feab139 ext4: rearrange initialization to fix EXT4FS_DEBUG".
>>
>> The related error (with allmodconfig under score):
>>
>>     CC [M]  fs/ext4/super.o
>>   fs/ext4/super.c: In function 'ext4_commit_super':
>>   fs/ext4/super.c:4546:41: error: 'struct percpu_counter' has no member named 'counters'
>>     if (EXT4_SB(sb)->s_freeclusters_counter.counters)
>>                                            ^
>>   fs/ext4/super.c:4550:39: error: 'struct percpu_counter' has no member named 'counters'
>>     if (EXT4_SB(sb)->s_freeinodes_counter.counters)
>
> Thanks for the pointing out the problem.  I though think the right way
> of fixing this problem, though, instead of using the #ifdef
> CONFIG_SMP, is to do this:
>
>        if (percpu_counter_initialized(&EXT4_SB(sb)->s_freeclusters_counter))
>           ...
>
> I'll respin the "ext4: rearrange initialization to fix EXT4FS_DEBUG"
> commit to include this fix and give you credit in the commit logs for
> pointing out this issue.

Friendly ping, since all !SMP builds in -next seem to be broken by this still.


-Olof
