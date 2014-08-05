From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: After unlinking a large file on ext4, the process stalls for a
 long time
Date: Mon, 4 Aug 2014 22:33:00 -0400
Message-ID: <20140805023300.GE5263@thunk.org>
References: <53C6B38A.3000100@free.fr>
 <59C3F41A-6AFD-418E-BCE6-2361B8140D9A@dilger.ca>
 <53C7A5CA.4050903@free.fr>
 <alpine.LFD.2.00.1407171238060.2312@localhost.localdomain>
 <53C7B0B7.9030007@free.fr>
 <20140717133755.GN1491@thunk.org>
 <53C7F4C2.6070804@free.fr>
 <alpine.LFD.2.00.1407181127440.12453@localhost.localdomain>
 <53DF9918.3010206@free.fr>
 <6910CF48-15F8-4218-8881-06899D7C56A5@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mason <mpeg.blue@free.fr>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44543 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153AbaHECdG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Aug 2014 22:33:06 -0400
Content-Disposition: inline
In-Reply-To: <6910CF48-15F8-4218-8881-06899D7C56A5@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 05, 2014 at 12:55:14AM +0200, Andreas Dilger wrote:
> It would be possible to optimize mb_free_blocks() by having it
> clear a whole word at a time instead of a series if bits. 

It looks like we're doing this already in mb_test_and_clear_bits(),
aren't we?

> I thought that was done already, but it doesn't appear to be the case.
> Also, it isn't clear that the bit "normalization" is needed anymore.
> This was done back in the aniceint times when the buddy bitmaps were stored on disk instead of being regenerated only at mount time. 

I'm not sure what you mean by this; the only reference I can find
normalization is with normalizing requests?

						- Ted
