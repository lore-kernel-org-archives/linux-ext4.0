From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: A warning from 3.6+ with bigalloc and delalloc when running
 xfstest
Date: Sat, 13 Oct 2012 22:18:34 -0400
Message-ID: <20121014021834.GA4418@thunk.org>
References: <CANWLp03Kcp75CZPr6DubSExH9GhLUqaLf=xHvLiivprs=z2BvQ@mail.gmail.com>
 <20121009054820.GA8028@thunk.org>
 <20121009062931.GA29314@gmail.com>
 <20121009135152.GA29156@thunk.org>
 <CAA0+VHwL0u0h6sn=Z0FyHsqYi2ji=sUaQ9ZPJCQ9kEMOpQHarg@mail.gmail.com>
 <20121011155708.GA9480@gmail.com>
 <CAA0+VHySFTOC53QGyt2aCk4vNq45dcfptEHN0vc+tLnZA0tgng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andrey Sidorov <qrxd43@motorola.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55435 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737Ab2JNOlw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Oct 2012 10:41:52 -0400
Content-Disposition: inline
In-Reply-To: <CAA0+VHySFTOC53QGyt2aCk4vNq45dcfptEHN0vc+tLnZA0tgng@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 13, 2012 at 02:29:48PM -0400, Andrey Sidorov wrote:
> I didn't see it as well, but wanted to be sure it won't break file
> system once occurred.
> Our use-case is mostly dio and pre-fallocated writes, so I think we'll be fine.
> Thanks!

Yes, that will work just fine.  That in fact was the use case I was
primarily interested in when I did the bigalloc work.  The main
weaknesses come from using buffered writes with delayed allocation and
when the disk is almost full.

					- Ted
