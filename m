From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] badblocks: Add options for parseable status output
Date: Wed, 13 Dec 2017 11:24:10 -0500
Message-ID: <20171213162410.2bn6nmrg75xlu5nz@thunk.org>
References: <CAGbvivJTZJdZVx-f+hZuoii5TgmygtiCST8tNGzTZNyBZ8tUuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Wyllys Ingersoll <wyllys.ingersoll@keepertech.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41060 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753266AbdLMQYM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 13 Dec 2017 11:24:12 -0500
Content-Disposition: inline
In-Reply-To: <CAGbvivJTZJdZVx-f+hZuoii5TgmygtiCST8tNGzTZNyBZ8tUuA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 06, 2017 at 12:34:06PM -0500, Wyllys Ingersoll wrote:
> This patch adds a couple of new command line arguments
> to make it easier to control the frequency of the status output and make the
> output more parseable.
> 
>       Add new command line arguments for badblocks utility:
>            [-a alarm_interval ]   Control the frequency of status
> output (in seconds)
>            [-P] makes the output more parseable by external programs (comma
>                  separated, LF terminated)
> 
> Signed-off-by: Wyllys Ingersoll <wyllys.ingersoll@keepertech.com>

This patch is whitespace damanged and is not applicable.  And the
github pull request was unnecessarily broken up into three commits....

       	    	    		      	     - Ted
