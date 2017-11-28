From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/3] Improve kobject handling in fs/ext4
Date: Mon, 27 Nov 2017 22:51:05 -0500
Message-ID: <20171128035105.lec6u6y4p3qwgjde@thunk.org>
References: <20171127231801.27652-1-sirmy15@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Riccardo Schirone <sirmy15@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33878 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753522AbdK1DvH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 27 Nov 2017 22:51:07 -0500
Content-Disposition: inline
In-Reply-To: <20171127231801.27652-1-sirmy15@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 28, 2017 at 12:17:58AM +0100, Riccardo Schirone wrote:
> This patch tries to correctly use kobjects in fs/ext4. In particular it
> allocates kobjects/ksets dynamically, instead of statically, and improve
> error handling in case kobject_* functions fail.

I don't see the point of allocating the kobjects in question
dynamically?  There is only one of them, so why not use static
allocation?  What is "incorrect" about not doing dynamically allocated
kobjects/ksets?

Regards,

						- Ted
