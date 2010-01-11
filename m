From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] genhd: overlapping variable definition
Date: Mon, 11 Jan 2010 14:32:17 +0100
Message-ID: <20100111133216.GH4489@kernel.dk>
References: <20100106154555.3dd77fe2@nehalam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jerome Marchand <jmarchan@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>, Greg KH <gregkh@suse.de>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:47522 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab0AKNcS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jan 2010 08:32:18 -0500
Content-Disposition: inline
In-Reply-To: <20100106154555.3dd77fe2@nehalam>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 06 2010, Stephen Hemminger wrote:
> This fixes the sparse warning:
> fs/ext4/super.c:2390:40: warning: symbol 'i' shadows an earlier one
> fs/ext4/super.c:2368:22: originally declared here
> 
> Using 'i' in a macro is dubious practice.

Indeed, applied. Thanks!

-- 
Jens Axboe

