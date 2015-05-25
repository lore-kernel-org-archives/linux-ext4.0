From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/4] e2fsprogs: Support for orphan file feature
Date: Mon, 25 May 2015 09:19:37 +0200
Message-ID: <20150525071937.GA2387@quack.suse.cz>
References: <1432294137-26078-1-git-send-email-jack@suse.cz>
 <CAHAf8Wm7CqhHWTN-4sfcLrqAYSsXvOTRFXZZyoMbcHmN03Wc1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Albino Biasutti Neto <bino@riseup.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39365 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbbEYHTm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 May 2015 03:19:42 -0400
Content-Disposition: inline
In-Reply-To: <CAHAf8Wm7CqhHWTN-4sfcLrqAYSsXvOTRFXZZyoMbcHmN03Wc1w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 22-05-15 12:51:51, Albino Biasutti Neto wrote:
> 2015-05-22 8:28 GMT-03:00 Jan Kara <jack@suse.cz>:
> >   this is support orphan file feature in e2fsprogs. mke2fs and tune2fs support
> > should be fine, e2fsck support still has bugs so use with care. I'm posting
> > this mainly so that people can easily create filesystem with orphan file
> > feature for testing the kernel patches.
> 
> How ?
  Build & boot a kernel with the kernel patches I posted ([PATCH 0/3 v2]
ext4: Speedup orphan file handling) - warning there are actually 4 patches
in the series, I just messed up header.

Build e2fsprogs with patches in this series.

Create filesystem with '-O orphan_file' feature.

Now you can test whether the feature makes a difference for things you are
interested in - it may be visible when you heavily delete / truncate files
from lots of processes in parallel.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
