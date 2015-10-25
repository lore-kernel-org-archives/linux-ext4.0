From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: xfstests ext4/304 failing due to donor inode's i_size == 0
Date: Sun, 25 Oct 2015 07:10:41 -0400
Message-ID: <20151025111041.GF27558@thunk.org>
References: <20151019025727.GA6676@thunk.org>
 <87h9llior0.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42674 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbbJYLKr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 Oct 2015 07:10:47 -0400
Content-Disposition: inline
In-Reply-To: <87h9llior0.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 20, 2015 at 05:44:03PM +0300, Dmitry Monakhov wrote:
> Theodore Ts'o <tytso@mit.edu> writes:
> 
> > Hi Dmitry,
> >
> > I was investigating why ext4/304 is failing, and it's due to
> > defrag-fuzzer returning an error:
> Yep. You are right. I have out of tree patch which fix that. I'll send it
> to xfstests-dev list.

I tried the patch you sent, but ext4/304 is still failing.  At the end
of 304.full:

fio: file hash not empty on exit

						- Ted
