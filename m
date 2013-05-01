From: Subranshu Patel <spatel.ml@gmail.com>
Subject: Re: fsck memory usage
Date: Wed, 1 May 2013 08:12:14 +0530
Message-ID: <CAEUQceh8oX9TsOR-rtn44QtegGSGH_+QHm9GPcoVPqHGJMhWHw@mail.gmail.com>
References: <CAEUQceh3Wm6LZpGQnXNjh0c9WbO8S70D5-KYjY8anup80WbLHQ@mail.gmail.com>
	<20130417230745.GC5401@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qe0-f52.google.com ([209.85.128.52]:33283 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757199Ab3EACmP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Apr 2013 22:42:15 -0400
Received: by mail-qe0-f52.google.com with SMTP id q19so711028qeb.11
        for <linux-ext4@vger.kernel.org>; Tue, 30 Apr 2013 19:42:14 -0700 (PDT)
In-Reply-To: <20130417230745.GC5401@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> What version of e2fsprogs are you using? There has been a number of

> changes made to improve both CPU and memory utilization in more recent

> versions of e2fsprogs.


I am using version 1.41.12


>> Then I performed metadata corruption - 10% of the files, 10% of the

>> directories and some superblock attributes using debugfs. Then I

>> executed fsck to find a memory usage of around 8GB, a much larger

>> value.


> It's going to depend on what sort of metadata corruption was suffered.

> If you need to do pass 1b/c/d fix ups, it will need more memory.

> That's pretty much unavoidable, but it's also not the common case. In

> most use cases, if those cases require using swap, that's generally OK

> if it's the rare case, and not the common case. That's why it's not

> something I've really been worried about.

I used the sar command for tracking memory usage. The total memory
usage reported by sar command is around 8GB, but it includes the
buffer and cache memory.

memused = 8GB

buffer = 6.7GB

cache = negligible (some MBs)

So I think the effective memory usage will be 1.3GB (8 - 6.7). So the
memory reported under buffer and cache is available for use (if any
other process requires it). Please correct my understanding.

--
Subranshu
