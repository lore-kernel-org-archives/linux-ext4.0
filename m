From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/5] libext2fs: Implement fast find_first_zero() for
 bitarray bitmaps.
Date: Mon, 26 Mar 2012 11:26:07 -0400
Message-ID: <20120326152607.GB15027@thunk.org>
References: <20120310213321.GK6961@sli.dy.fi>
 <20120310213840.GP6961@sli.dy.fi>
 <20120326023400.GA16642@thunk.org>
 <20120326132258.GA31953@cc.hut.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Sami Liedes <sami.liedes@iki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36907 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932659Ab2CZP0J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Mar 2012 11:26:09 -0400
Content-Disposition: inline
In-Reply-To: <20120326132258.GA31953@cc.hut.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 26, 2012 at 04:22:58PM +0300, Sami Liedes wrote:
> Hmm, no, I don't think so? count==0 here iff we have tested as many
> bits as the caller requested. So this code will bail out if the number
> of bits to test is not large enough to even hit a byte boundary, or if
> the last bit to test and the byte boundary coincide. Perhaps count
> should be renamed to something like bits_left_to_test if it's
> confusing now?

Ah, you're right, my bad.  I managed to confuse myself with !count.
In cases where we're not dealing with a boolean value, it's actually
better to write (count == 0), for this reason.

> I agree that a regression test is needed. I'll look into writing that.

If you could work on improving tst_bitmaps, that would be great.  Thanks!!

       	     	     	       		    - Ted
