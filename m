From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Add largedir feature
Date: Sat, 29 Apr 2017 20:59:53 -0400
Message-ID: <20170430005953.m74yjettitj7mzr6@thunk.org>
References: <1489657877-34478-1-git-send-email-artem.blagodarenko@seagate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        alexey.lyashkov@gmail.com, Yang Sheng <yang.sheng@intel.com>,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33370 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S378359AbdD3BAA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 29 Apr 2017 21:00:00 -0400
Content-Disposition: inline
In-Reply-To: <1489657877-34478-1-git-send-email-artem.blagodarenko@seagate.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 16, 2017 at 05:51:17AM -0400, Artem Blagodarenko wrote:
> From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
> 
> This INCOMPAT_LARGEDIR feature allows larger directories to be created
> in ldiskfs, both with directory sizes over 2GB and and a maximum htree
> depth of 3 instead of the current limit of 2. These features are needed
> in order to exceed the current limit of approximately 10M entries in a
> single directory.
> 
> Signed-off-by: Yang Sheng <yang.sheng@intel.com>
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>

Thanks, applied.

					- Ted
