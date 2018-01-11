From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] fs/ext4: release kobject/kset even when
 init/register fail
Date: Thu, 11 Jan 2018 15:10:11 -0500
Message-ID: <20180111201011.GG19241@thunk.org>
References: <20171127231801.27652-1-sirmy15@gmail.com>
 <20171127231801.27652-2-sirmy15@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Riccardo Schirone <sirmy15@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37974 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932419AbeAKUKV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 11 Jan 2018 15:10:21 -0500
Content-Disposition: inline
In-Reply-To: <20171127231801.27652-2-sirmy15@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 28, 2017 at 12:17:59AM +0100, Riccardo Schirone wrote:
> Even when kobject_init_and_add/kset_register fail, the kobject has been
> already initialized and the refcount set to 1. Thus it is necessary to
> release the kobject/kset, to avoid the memory associated with it hanging
> around forever.
> 
> Signed-off-by: Riccardo Schirone <sirmy15@gmail.com>

Thanks, applied.

						- Ted
