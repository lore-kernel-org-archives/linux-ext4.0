From: "Burton, Ross" <ross.burton@intel.com>
Subject: Re: [V4] misc: copy extended attributes in populate_fs
Date: Tue, 9 Sep 2014 14:09:27 +0100
Message-ID: <CAJTo0LZkfa5yJi8YG-EA+AM0Some8YrBThULqJ_49heNrOT5LA@mail.gmail.com>
References: <1405010678-993-1-git-send-email-ross.burton@intel.com>
 <20140728012909.GA19632@thunk.org> <CAJTo0LYSjRtoN29_VmKv=CxyCJpwaywqfqOegZPFnWbV1+96ow@mail.gmail.com>
 <20140909130329.GE24855@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:36038 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757AbaIINJs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2014 09:09:48 -0400
Received: by mail-qg0-f51.google.com with SMTP id e89so3601981qgf.10
        for <linux-ext4@vger.kernel.org>; Tue, 09 Sep 2014 06:09:47 -0700 (PDT)
In-Reply-To: <20140909130329.GE24855@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9 September 2014 14:03, Theodore Ts'o <tytso@mit.edu> wrote:
> It's on the master branch, which means it's waiting on 1.43.  It's
> very likely that 1.42.12 will be last maint branch release, and that
> 1.43.0 will be releasing relatively soon with inline data and metadata
> checksum support.  There are a number of patches still in the review
> queue and some additional testing we need to do before we can release
> 1.43, though.

Thanks, it's good to understand this.

Cheers,
Ross
