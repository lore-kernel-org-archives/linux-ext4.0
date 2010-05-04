From: tytso@mit.edu
Subject: Re: Introducing Next3 - built-in snapshots support for Ext3
Date: Tue, 4 May 2010 18:42:26 -0400
Message-ID: <20100504224226.GE6344@thunk.org>
References: <g2j18730dc51004180841obb1171bbwa1822d6fe0856429@mail.gmail.com>
 <s2s18730dc51005030247u5ef2fddfz269b57d97714db8f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:36445 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760246Ab0EDWme (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 May 2010 18:42:34 -0400
Content-Disposition: inline
In-Reply-To: <s2s18730dc51005030247u5ef2fddfz269b57d97714db8f@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 03, 2010 at 12:47:58PM +0300, Amir G. wrote:
> 
> Next3 project was introduced 2 weeks ago. I hope you've had a chance
> to visit the wiki page.

I took a quick look, but to be honest, I've been swamped lately, and
with the merge window close at hand, it was something I was going to
put off for another 2-3 weeks.  I didn't realize you were in need of
some immediate comments so that you could finalize the on-disk format.

So the high bit on that front is that it looks like at least some of
the fields used, bit positions grabbed, etc., overlap with those used
by ext4.  Ext4 is where new development takes place in the ext2/3/4
series.  So enhancements such as Next3 will probably not be received
with great welcome into ext3.  And as far as e2fsprogs (which handles
the ext2, ext3, and ext4 file systems) is concerned, I don't want to
deal with the complexity of certain fields that mean one thing for
ext4, and something else for Next3.

I'll try to carve out time to look at the Next3 patches in greater
detail this week.

Best regards,

					- Ted
