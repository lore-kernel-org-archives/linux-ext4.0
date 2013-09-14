From: Alexander Harrowell <a.harrowell@gmail.com>
Subject: Re: ext4 recovery, the saga of 16777215 continues
Date: Sat, 14 Sep 2013 09:25:35 +0000
Message-ID: <CA+qGm=-tSOFyWJFTwB3HWpS_WdGekXyWUVMP8RN33sciwkafMQ@mail.gmail.com>
References: <CA+qGm=_vV3xv8ip6JfuW7hDo3ZgR5Bj4oA_1r0BPD33rAso0Jg@mail.gmail.com>
	<20130914021818.GA1112@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:58067 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab3INJZg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 14 Sep 2013 05:25:36 -0400
Received: by mail-pd0-f178.google.com with SMTP id w10so2187939pde.23
        for <linux-ext4@vger.kernel.org>; Sat, 14 Sep 2013 02:25:35 -0700 (PDT)
In-Reply-To: <20130914021818.GA1112@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

dump_inode 2937950 /media/usbdisk/dump

On Sat, Sep 14, 2013 at 2:18 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Fri, Sep 13, 2013 at 03:40:47PM +0000, Alexander Harrowell wrote:
>> OK, so after updating e2fsprogs and doing a bunch of hacking around, I
>> was eventually able to find the inode that returns hundreds of MB of
>> 16777215 in the multiply-claimed blocks pass.
>>
>> Dumping it out with debugfs, the output file reached 28 GB before the
>> device receiving ran out of space. I thought inodes were of defined
>> size?
>
> What do you mean by "dumping it out"?  What precise debugfs command
> were you using?
>
> stat?  dump?  something else?
>
>                                                 - Ted
