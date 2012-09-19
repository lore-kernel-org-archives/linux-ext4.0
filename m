From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RFC 1/2] ext4: speed-up truncate/unlink
Date: Wed, 19 Sep 2012 14:16:44 -0400
Message-ID: <20120919181644.GA28470@thunk.org>
References: <CAA0+VHzw55=4X43GK9RkRK_q4qmzR8KyqrrFidQMCPb6r4nPeA@mail.gmail.com>
 <20120918041006.GC32195@thunk.org>
 <CAA0+VHxM6s7dmmeEf6CsF+5YxaUhv1zgQ3Q-ZNbwADFu8UeftQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andrey Sidorov <qrxd43@motorola.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51561 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932929Ab2ISSQt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Sep 2012 14:16:49 -0400
Content-Disposition: inline
In-Reply-To: <CAA0+VHxM6s7dmmeEf6CsF+5YxaUhv1zgQ3Q-ZNbwADFu8UeftQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 18, 2012 at 02:17:09PM -0400, Andrey Sidorov wrote:
> 
> Yes, please add
> Signed-off-by: Andrey Sidorov <qrxd43@motorola.com>

Thanks, applied.

I am interested in your proposed patch 2/2 as well, but it's going to
require more detailed review, and it sounds like you were planning on
doing some work to better handle corner cases as well?

						- Ted
