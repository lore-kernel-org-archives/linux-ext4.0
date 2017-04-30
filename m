From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: preload block group descriptors
Date: Sun, 30 Apr 2017 00:54:54 -0400
Message-ID: <20170430045454.bswu2osb4bynkxq6@thunk.org>
References: <1487609153-3367-1-git-send-email-artem.blagodarenko@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, alexey.lyashkov@gmail.com,
        Andrew Perepechko <andrew.perepechko@seagate.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33682 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966371AbdD3Ey6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 30 Apr 2017 00:54:58 -0400
Content-Disposition: inline
In-Reply-To: <1487609153-3367-1-git-send-email-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 20, 2017 at 07:45:53PM +0300, Artem Blagodarenko wrote:
> From: Andrew Perepechko <andrew.perepechko@seagate.com>
> 
> With enabled meta_bg option block group descriptors
> reading IO is not sequential and requires optimization.
> 
> Signed-off-by: Andrew Perepechko <andrew.perepechko@seagate.com>

Thanks, applied.

					- Ted
