From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Re: Re: EXT4 regression caused 4eec7
Date: Mon, 13 May 2013 21:56:43 +0800
Message-ID: <20130513135643.GB12883@gmail.com>
References: <31302271.2821368363898561.JavaMail.weblogic@epml17>
 <20130513131809.GG400@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: EUNBONG SONG <eunb.song@samsung.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:46304 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab3EMNjE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 May 2013 09:39:04 -0400
Content-Disposition: inline
In-Reply-To: <20130513131809.GG400@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 13, 2013 at 03:18:09PM +0200, Jan Kara wrote:
> On Sun 12-05-13 13:04:59, EUNBONG SONG wrote:
> > 
> > 
> > >> Since at this point it's safer to rollback the change and we can
> > >> investigate more deeply how to fix it correctly for the next
> > >> development cycle, this is the patch which I'm testing.
> > 
> > >>                     - Ted
> > 
> > > Hello, I've tested with your patch. But the same problem was reproduced.
> > > Currently, I'm trying to git bisect. If i done git bisect, i will let you know.
> > 
> > Hi, I've done git bisect. and panic at jbd2_journal_put_journal_head() is caused by 
> > ae4647fb7654676fc44a97e86eb35f9f06b99f66: "jbd2: reduce journal_head size."
> > I write just code patch which revert ae4647fb7654676fc44a97e86eb35f9f06b99f66 because
> > I don't know the root cause. 
>   This is really strange. I've verified the code and all the places
> modifying b_jlist or b_modified are holding bh_state lock so we should be
> safe...

Hi Jan,

Could you please take a look at this mail [1].  I don't think we hold
bh_state lock there.

1. http://www.spinics.net/lists/linux-ext4/msg38205.html

Thanks,
                                                - Zheng
