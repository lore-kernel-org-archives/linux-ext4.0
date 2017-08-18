From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: Y2038 bug in ext4 recently_deleted() function
Date: Thu, 17 Aug 2017 18:23:26 -0700
Message-ID: <CABeXuvqtDdtjgjEznXPgdUfaZiG-KJ3AURpT_AuUACcPATaoDw@mail.gmail.com>
References: <20170808050517.7160-1-wshilong@ddn.com> <20170816164211.GA31117@quack2.suse.cz>
 <3ED34739A4E85E4F894367D57617CDEFEDA401CE@LAX-EX-MB2.datadirect.datadirectnet.com>
 <20170817091959.GB7644@quack2.suse.cz> <20170817092153.GA14074@quack2.suse.cz>
 <BCA34CA8-FDDF-49FA-A5B4-9CCCEAC0C8D0@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Theodore Ts'o" <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>,
        Wang Shilong <wshilong@ddn.com>,
        Wang Shilong <wangshilong1991@gmail.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Shuichi Ihara <sihara@ddn.com>, Li Xi <lixi@ddn.com>,
        Jan Kara <jack@suse.cz>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:38625 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753345AbdHRBX1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Aug 2017 21:23:27 -0400
Received: by mail-io0-f178.google.com with SMTP id g71so28676126ioe.5
        for <linux-ext4@vger.kernel.org>; Thu, 17 Aug 2017 18:23:27 -0700 (PDT)
In-Reply-To: <BCA34CA8-FDDF-49FA-A5B4-9CCCEAC0C8D0@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Strange, I never even knew recently_deleted() existed, even though it was
> added to the tree 4 years ago yesterday.  It looks like this is only used
> with the no-journal code, which I don't really interact with.
>
> One thing I did notice when looking at it is that there is a Y2038 bug in
> recently_deleted(), as it is comparing 32-bit i_dtime directly with 64-bit
> get_seconds().

I don't think dtime has widened on the disk layout for ext4 according
to https://ext4.wiki.kernel.org/index.php/Ext4_Disk_Layout. So I am
not sure how fixing the internal implementation would be useful until
we do that. Is there a plan for that?

As far as get_seconds() is concerned, get_seconds() returns unsigned
long which is 64 bits on a 64 bit arch and 32 bit on a 32 bit arch.
Since dtime variable is declared as unsigned long in this function,
same holds for the size of this variable.

There is no y2038 problem on a 64 bit machine.

So moving to the case of a 32 bit machine:

get_seconds() can return values until year 2106. And, recentcy at max
can only be 35. Analyzing the current line:

if (dtime && (dtime < now) && (now < dtime + recentcy))

The above equation should work fine at least until 35 seconds before
y2038 deadline.

-Deepa
