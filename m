From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RFC 2/2] ext4: speed-up releasing blocks on commit
Date: Tue, 18 Sep 2012 00:17:14 -0400
Message-ID: <20120918041714.GD32195@thunk.org>
References: <CAA0+VHwvmr5Pi+86tcEsZ7L8gE30UdwivBTFy0_Q8bEgxw_uqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andrey Sidorov <qrxd43@motorola.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51227 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab2IRERQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Sep 2012 00:17:16 -0400
Content-Disposition: inline
In-Reply-To: <CAA0+VHwvmr5Pi+86tcEsZ7L8gE30UdwivBTFy0_Q8bEgxw_uqw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 18, 2012 at 01:00:58AM +0400, Andrey Sidorov wrote:
> Improve mb_free_blocks speed by clearing bits all at once instead of
> going one by one. Rebuild buddy bitmap by going up only once per range
> instead of once per block.
> This algorithm relies on buddy bitmap to be correct and it can't
> handle ranges with already freed blocks producing incorrect results in
> these conditions.
> I will add checking for error cases is to be added as soon as I get
> some inputs on how to do that (and if this patch has some interest at
> all). 

Thanks, this patch is interesting as well --- but yes, we do need to
make sure the changes will not make any potential inconsistency in the
buddy bitmaps any worse that they already are.

The main thing we need to consider for the buddy bitmap code is that
it's one of the more subtle and complex bits of code in the ext4 code
base.  So changing it is always scary that there is some interesting
edge case that isn't quite right.

That means the two things we need to consider are (a) adding sanity
checking code which we can compile in or out to test to make sure the
right thing happens for all of the various corner cases, and (b)
making sure we do the right thing even if the buddy bitmaps have
gotten corrupted in memory some how.

Regards,

						- Ted
