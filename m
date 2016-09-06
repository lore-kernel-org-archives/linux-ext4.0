From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: enforce online defrag restriction for encrypted
 files
Date: Mon, 5 Sep 2016 23:05:18 -0400
Message-ID: <20160906030518.igheo52lccautlvo@thunk.org>
References: <20160722221755.GA1594@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46606 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755769AbcIFDFW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 5 Sep 2016 23:05:22 -0400
Content-Disposition: inline
In-Reply-To: <20160722221755.GA1594@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 22, 2016 at 06:17:55PM -0400, Eric Whitney wrote:
> Online defragging of encrypted files is not currently implemented.
> However, the move extent ioctl can still return successfully when
> called.  For example, this occurs when xfstest ext4/020 is run on an
> encrypted file system, resulting in a corrupted test file and a
> corresponding test failure.
> 
> Until the proper functionality is implemented, fail the move extent
> ioctl if either the original or donor file is encrypted.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.

						- Ted
