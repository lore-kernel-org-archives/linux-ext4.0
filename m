From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Add largedir feature
Date: Mon, 20 Mar 2017 10:20:30 -0400
Message-ID: <20170320142030.s2acios7q2qytzak@thunk.org>
References: <20170319133425.gxeg3mba3brvztjf@thunk.org>
 <2F91584E-6351-4523-9821-54AD6A7CD889@dilger.ca>
 <AC9DD60D-37A5-458B-AFA2-5EDDAAFD5E9E@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Yang Sheng <yang.sheng@intel.com>,
        Zhen Liang <liang.zhen@intel.com>,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>
To: Alexey Lyashkov <alexey.lyashkov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57634 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754218AbdCTOUn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 20 Mar 2017 10:20:43 -0400
Content-Disposition: inline
In-Reply-To: <AC9DD60D-37A5-458B-AFA2-5EDDAAFD5E9E@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 20, 2017 at 02:34:31PM +0300, Alexey Lyashkov wrote:
> 
> To make picture clean. OST side is regular FS with 32 directories where a stripe objects is live.
> With current 4G inodes limit each directory will filled with up 100k regular files.
> Files allocated in batch, up to 20k files per batch. Allocated object used on MDT side to make mapping between metadata objects and data for such file.
> I worry about it part, not about MDT. these directories have a large number creations/unlinks and performance degradation started after 3M-5M creations/unlinks.
> With Large dir feature i think this performance problems may deeper.

This makes no sense.  On the Object Store side, if the maximum
directory size is 100k regular files, you're never going to run into
two-levle htree limit, so the presense (or absense) of largedir is
largely irrelevant.  So how can it make the performance problem worse?

						- Ted
