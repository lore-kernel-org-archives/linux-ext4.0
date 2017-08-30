From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] ext4: avoid Y2038 overflow in recently_deleted()
Date: Wed, 30 Aug 2017 23:03:08 +0200
Message-ID: <CAK8P3a1WHVqwK6veXcruHQ=roub6ivnffpBWCw=XcTzF9=ev1A@mail.gmail.com>
References: <1503686915-57151-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:37322 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750814AbdH3VDJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Aug 2017 17:03:09 -0400
Received: by mail-oi0-f66.google.com with SMTP id b184so6612395oih.4
        for <linux-ext4@vger.kernel.org>; Wed, 30 Aug 2017 14:03:09 -0700 (PDT)
In-Reply-To: <1503686915-57151-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 25, 2017 at 8:48 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> Avoid a 32-bit time overflow in recently_deleted() since i_dtime
> (inode deletion time) is stored only as a 32-bit value on disk.
> Since i_dtime isn't used for much beyond a boolean value in e2fsck
> and is otherwise only used in this function in the kernel, there is
> no benefit to use more space in the inode for this field on disk.
>
> Instead, compare only the relative deletion time with the low
> 32 bits of the time using the newly-added time_before32() helper,
> which is similar to time_before() and time_after() for jiffies.
>
> Increase RECENTCY_DIRTY to 300s based on Ted's comments about
> usage experience at Google.
>
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>
> Change-Id: I7402e1b3d49ea326f872ec8324933f42b502b9be

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

Sorry for the late reply.
