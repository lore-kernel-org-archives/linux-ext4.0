From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH 1/6] f2fs: check entire encrypted bigname when finding a
 dentry
Date: Tue, 2 May 2017 19:56:28 -0700
Message-ID: <20170503025628.GA624@zzz>
References: <20170424170013.85175-1-ebiggers3@gmail.com>
 <20170424170013.85175-2-ebiggers3@gmail.com>
 <20170425001023.GA4983@jaegeuk.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fscrypt@vger.kernel.org, "Theodore Y . Ts'o" <tytso@mit.edu>,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Gwendal Grignou <gwendal@chromium.org>, hashimoto@chromium.org,
        kinaba@chromium.org, stable@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34097 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751703AbdECC4c (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 2 May 2017 22:56:32 -0400
Content-Disposition: inline
In-Reply-To: <20170425001023.GA4983@jaegeuk.local>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jaegeuk,

On Mon, Apr 24, 2017 at 05:10:23PM -0700, Jaegeuk Kim wrote:
> Hi Eric,
> 
> This looks good to me.
> I'll drop it from my tree, so please move forward through fscrypt.
> 
> Thanks,

This is in fscrypt/master now (along with the other patches in the series), but
it's also in f2fs/dev.  Are you still planning to drop it from the f2fs tree?

- Eric
