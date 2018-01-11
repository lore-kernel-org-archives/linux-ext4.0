From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] fs/ext4: create ext4_feat kobject dynamically
Date: Thu, 11 Jan 2018 15:17:22 -0500
Message-ID: <20180111201722.GH19241@thunk.org>
References: <20171127231801.27652-1-sirmy15@gmail.com>
 <20171127231801.27652-3-sirmy15@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Riccardo Schirone <sirmy15@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38020 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932437AbeAKUR2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 11 Jan 2018 15:17:28 -0500
Content-Disposition: inline
In-Reply-To: <20171127231801.27652-3-sirmy15@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 28, 2017 at 12:18:00AM +0100, Riccardo Schirone wrote:
> kobjects should always be allocated dynamically, because it is unknown
> to whoever creates them when kobjects can be released.
> 
> Signed-off-by: Riccardo Schirone <sirmy15@gmail.com>

Thanks, applied.

					- Ted
