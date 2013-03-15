From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Ext4:can not rm directories on 2.6.3x
Date: Fri, 15 Mar 2013 10:59:22 -0400
Message-ID: <20130315145921.GC7403@thunk.org>
References: <CAAO_Xo5g2LR54ry=SU7UhGbv-chdkdd6foq+-LjnuE8yAj8ikg@mail.gmail.com>
 <513EDC2B.9020604@gmail.xom>
 <20130312134229.GJ18595@thunk.org>
 <513FF163.7080606@gmail.xom>
 <5142CAE4.3070400@gmail.xom>
 <20130315145314.GB7403@thunk.org>
 <20130315145604.GA5048@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: zhuyj <zyjzyj2000@gmail.com>, linux-ext4@vger.kernel.org,
	stable@kernel.org, Paul Gortmaker <paul.gortmaker@windriver.com>
To: Willy Tarreau <w@1wt.eu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53648 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518Ab3COO70 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Mar 2013 10:59:26 -0400
Content-Disposition: inline
In-Reply-To: <20130315145604.GA5048@1wt.eu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 15, 2013 at 03:56:04PM +0100, Willy Tarreau wrote:
> > Thanks, Zhujh for figuring this out.  Those two patches weren't
> > taggled with cc: stable@vger.kernel.org, but they probably should have
> > been.  Since they first appeared in v3.0, the two long-term stable
> > kernels that would benefit with these patches are v3.0.x and v3.2.x.

Oops, sorry, that should have read 2.6.32 and 2.6.34.  :-)

> > Willy, Paul, would you consider cherry-picking the following commits
> > for your respective stable kernels?
> > 
> > git cherry-pick 7ad8e4e6ae2a7c95445ee1715b1714106fb95037
> > git cherry-pick 6976a6f2acde2b0443cd64f1d08af90630e4ce81
> 
> Yes of course !

Great, thanks!!

						- Ted
