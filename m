From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: validate s_first_meta_bg at mount time
Date: Thu, 1 Dec 2016 15:09:44 -0500
Message-ID: <20161201200944.ar2mvwxxgzchah66@thunk.org>
References: <20161129055717.4154-1-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55106 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750975AbcLAUJq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 1 Dec 2016 15:09:46 -0500
Content-Disposition: inline
In-Reply-To: <20161129055717.4154-1-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 29, 2016 at 01:57:17PM +0800, Eryu Guan wrote:
> Ralf Spenneberg reported that he hit a kernel crash when mounting a
> modified ext4 image. And it turns out that kernel crashed when
> calculating fs overhead (ext4_calculate_overhead()), this is because
> the image has very large s_first_meta_bg (debug code shows it's
> 842150400), and ext4 overruns the memory in count_overhead() when
> setting bitmap buffer, which is PAGE_SIZE.
>...
> Fix it by validating s_first_meta_bg first at mount time, and
> refusing to mount if its value exceeds the largest possible meta_bg
> number.
> 
> Reported-by: Ralf Spenneberg <ralf@os-t.de>
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>

Thanks, applied.  And yes, I do believe you are right about e2fsck
having an off-by-one error.  Will fix.

					- Ted
