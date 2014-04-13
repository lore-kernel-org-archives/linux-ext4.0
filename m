From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: silence sparse check warning for function
 ext4_trim_extent.
Date: Sat, 12 Apr 2014 23:06:33 -0400
Message-ID: <20140413030633.GC14599@thunk.org>
References: <CAGW2f1GZ3ns=Fr9Dkp3ixh7uQhiFg0xJmPxY60TmGEUk9E8SBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
To: jon ernst <jonernst07@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53392 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbaDMDGf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Apr 2014 23:06:35 -0400
Content-Disposition: inline
In-Reply-To: <CAGW2f1GZ3ns=Fr9Dkp3ixh7uQhiFg0xJmPxY60TmGEUk9E8SBg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 12, 2014 at 10:25:45PM -0400, jon ernst wrote:
> By doing "make  M=fs/ext4 C=2"
> on commit ad6599ab3ac98a4474544086e048ce86ec15a4d1
> 
> sparse reports this warning:
>   CHECK   fs/ext4/mballoc.c
> fs/ext4/mballoc.c:5019:9: warning: context imbalance in
> 'ext4_trim_extent' - unexpected unlock
> 
> Signed-off-by: "Jon Ernst" <jonernst07@gmail.com>

Thanks, applied.

					- Ted
