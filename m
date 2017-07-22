From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 1/2] e2p: Fix segfault in e2p_os2string.
Date: Sat, 22 Jul 2017 17:57:26 -0400
Message-ID: <20170722215726.ywgkerssm7kfgqm2@thunk.org>
References: <20170718192919.32406-1-abuchbinder@google.com>
 <20170718214823.22649-1-abuchbinder@google.com>
 <20170718214823.22649-2-abuchbinder@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Adam Buchbinder <abuchbinder@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51100 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751325AbdGVV52 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 22 Jul 2017 17:57:28 -0400
Content-Disposition: inline
In-Reply-To: <20170718214823.22649-2-abuchbinder@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 18, 2017 at 02:48:22PM -0700, Adam Buchbinder wrote:
> Passing in a negative integer would lead to a segfault, and
> a crafted filesystem image could trigger that.
> 
> Signed-off-by: Adam Buchbinder <abuchbinder@google.com>

Thanks, applied.

					- Ted
