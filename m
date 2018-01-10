From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: use strlcpy() instead of strncpy()
Date: Wed, 10 Jan 2018 18:01:31 -0500
Message-ID: <20180110230131.GD6499@thunk.org>
References: <1515488319-23779-1-git-send-email-wangxiongfeng2@huawei.com>
 <20180109100655.bdbnsrvhceaimaxh@quack2.suse.cz>
 <eae3c8fd-d778-fa65-4609-5159a1a3b405@huawei.com>
 <20180109202003.GC5389@thunk.org>
 <CAK8P3a1xGW+KmtaqQfuARTn2zwJ3J6fZrLqTchstJcvGPj_BEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Jan Kara <jack@suse.cz>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34000 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752978AbeAJXBm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 10 Jan 2018 18:01:42 -0500
Content-Disposition: inline
In-Reply-To: <CAK8P3a1xGW+KmtaqQfuARTn2zwJ3J6fZrLqTchstJcvGPj_BEQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 10, 2018 at 10:30:15PM +0100, Arnd Bergmann wrote:
> This warning option appears to be particularly good in finding code that
> is actually dangerous in case of an overflow, and generally using
> strscpy() improves either correctness and readability over strncpy(),
> I think it's worth leaving enabled globally.
> 
> I have an experimental patch series to let you wrap the _Pragma("GCC
> diagnostic ingnored \"-Wstringop-truncation\"") directive in some
> nicer syntax. Would that work for you here?

Having a Pragma which silences errors is certainly better than
nothing, but what might be nice is to have a way of tagging a variable
or structure member function as "not guaranteed to be null
terminated".  That would suppress warnings where strncpy is used to
set the character array, and add warnings if how the character array
is accessed without taking due care that it might not be
null-terminated.

Essentially all of the on-disk strings in ext4 are not NUL terminated
(or not necessarily NUL terminated).  We either use an explicit length
(directory entries) or we use a fixed length character array (for the
things like the volume label, last error function, etc.)

Cheers,

					- Ted
