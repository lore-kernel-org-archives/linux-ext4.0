From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] make ext4_valid_block_bitmap() more verbose
Date: Mon, 15 Nov 2010 10:21:12 -0600
Message-ID: <4CE15DF8.4030600@redhat.com>
References: <201011130026.51268.bs_lists@aakef.fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Bernd Schubert <bschubert@ddn.com>,
	Andreas Dilger <andreas.dilger@oracle.com>
To: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757684Ab0KOQVT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Nov 2010 11:21:19 -0500
In-Reply-To: <201011130026.51268.bs_lists@aakef.fastmail.fm>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/12/10 5:26 PM, Bernd Schubert wrote:
> The real issue we want to debug with the patch below actually came up while 
> stress testing Lustre using the RHEL5.5 kernel (so 2.6.32'ish ext4), but a 
> more verbose error function should not hurt for vanilla ext4 either.
> 
> make ext4_valid_block_bitmap() more verbose
> 
> While running our stress test suite, ext4_valid_block_bitmap() 
> frequently complains about an invalid block bitmap.
> However, e2fsck does not find anything. So in oder to be able
> to better debug this issue, make the function more verbose and 
> let it complain about the two possible invalid bitmaps.

Making a raw e2image of the problematic filesystem would let us take a
look at why e2fsck isn't finding problems; unless you plan to fix that
yourself as well, which is just fine of course.  :)

-Eric
 
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
