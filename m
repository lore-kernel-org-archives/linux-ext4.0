From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4.h: Fixed alignment and minor code cleanup.
Date: Sun, 7 Jan 2018 23:57:29 -0500
Message-ID: <20180108045729.GG17380@thunk.org>
References: <1513800558.15997.3.camel@petroskoutoupis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Petros Koutoupis <petros@petroskoutoupis.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37668 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755359AbeAHE5c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 7 Jan 2018 23:57:32 -0500
Content-Disposition: inline
In-Reply-To: <1513800558.15997.3.camel@petroskoutoupis.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 20, 2017 at 02:09:18PM -0600, Petros Koutoupis wrote:
> Minor code cleanup: Fixed alignment and a reduction of lines in header file.
> 
> Signed-off-by: Petros Koutoupis <petros@petroskoutoupis.com>

The patch is whitespace damaged, unfortunately.

Also, the cleanup actually isn't the best cleanup.  We should really
be changing ext4_chksum() to take a struct super instead of a struct
ext4_sb_info, so we can call ext4_std_error() so we can properly log
an error without immediately crashing the kernel.  The chksum
shouldn't really ever fail, but if it does, calling ext4_error() is
better than bringing down the whole system with a BUG_ON.

Cheers,
						- Ted
