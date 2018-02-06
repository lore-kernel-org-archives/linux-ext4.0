From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/1] ext4: don't put symlink in pagecache into highmem
Date: Tue, 6 Feb 2018 08:32:09 -0500
Message-ID: <20180206133209.GD17801@thunk.org>
References: <20180205195739.9654-1-jinqian@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jin Qian <jinqian@google.com>,
        stable@vger.kernel.org
To: Jin Qian <jinqian@android.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41772 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751084AbeBFNcP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 6 Feb 2018 08:32:15 -0500
Content-Disposition: inline
In-Reply-To: <20180205195739.9654-1-jinqian@android.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 05, 2018 at 11:57:39AM -0800, Jin Qian wrote:
> From: Jin Qian <jinqian@google.com>
> 
> partial backport of 21fc61c73c3903c4c312d0802da01ec2b323d174.

Hi Jin,

When you do a partial backport like this, it would be helpful you
could indicate which kernel version(s) it is meant for, since there
are many stable kernel trees.

Thanks!!

						- Ted
