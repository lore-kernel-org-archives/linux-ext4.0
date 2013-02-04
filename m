From: Prashant Shah <pshah.mumbai@gmail.com>
Subject: Re: Maximum number of directories
Date: Mon, 4 Feb 2013 18:49:54 +0530
Message-ID: <CAD6i1fKHDP3m8EQZVaY-3VQ+6kh5=Bv7SQhLozJJEb7UJ5q=VQ@mail.gmail.com>
References: <17001225.1MS6YREEfJ@deuteros>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:59198 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab3BDN2T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Feb 2013 08:28:19 -0500
Received: by mail-ea0-f172.google.com with SMTP id f13so2797564eaa.17
        for <linux-ext4@vger.kernel.org>; Mon, 04 Feb 2013 05:28:18 -0800 (PST)
In-Reply-To: <17001225.1MS6YREEfJ@deuteros>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Mon, Feb 4, 2013 at 4:25 PM, Tvrtko Ursulin
<tvrtko.ursulin@onelan.co.uk> wrote:

> I was creating such a (crazy?) tree and hit -ENOSPC at ~31 million directories
> created in total with df showing only 40% use:

> Inode count:              29868032
> Free inodes:              29848131

Since, each directory will use a inode entry, there is some mismatch
with ~31 million directories and 19901 inodes in use. The inode usage
count should be much larger. You have max 29 million inodes available
- so max can be 29 million directories.

Try $blk

Regards.
