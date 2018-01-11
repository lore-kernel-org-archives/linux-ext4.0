From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] tests: Fixup for new r_move_itable tests.
Date: Thu, 11 Jan 2018 14:13:27 -0500
Message-ID: <20180111191327.GA5559@thunk.org>
References: <20171111075540.21722-1-mbakke@fastmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Marius Bakke <mbakke@fastmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37766 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964978AbeAKTNg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 11 Jan 2018 14:13:36 -0500
Content-Disposition: inline
In-Reply-To: <20171111075540.21722-1-mbakke@fastmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 11, 2017 at 08:55:40AM +0100, Marius Bakke wrote:
> Commits 257f009d1034737096f197dc875931207bcdfc75 and
> 2b50c18a8a12781c26b71873f4368fe61711d9f9 missed one pass in expected
> output.
> 
> Signed-off-by: Marius Bakke <mbakke@fastmail.com>

Hi, what architecture did you discover this on?  I don't need this
change on x86, but I was seeing some mysterious regression test
failures on a big-endian system which seemed to look like this.  I
didn't have time to follow up on it then, but I suspect that this may
be what you are running into.

Can you confirm?

Thanks,

						- Ted
