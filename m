From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: ext4 extent status tree LRU locking
Date: Tue, 18 Jun 2013 11:49:31 +0800
Message-ID: <20130618034931.GA10628@gmail.com>
References: <51B7B128.60909@intel.com>
 <20130614140940.GA20401@gmail.com>
 <20130614140215.GA1017@thunk.org>
 <20130614170028.GA21544@gmail.com>
 <20130614180054.GB1017@thunk.org>
 <20130617101033.GA17828@gmail.com>
 <51BF7BAA.5030803@intel.com>
 <20130618022548.GA24671@gmail.com>
 <20130618025133.GB24479@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Dave Hansen <dave.hansen@intel.com>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Jan kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:35457 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab3FRDbQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Jun 2013 23:31:16 -0400
Content-Disposition: inline
In-Reply-To: <20130618025133.GB24479@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 17, 2013 at 10:51:34PM -0400, Theodore Ts'o wrote:
> On Tue, Jun 18, 2013 at 10:25:48AM +0800, Zheng Liu wrote:
> > Ah, sorry, I forgot to mention that this patch bases against ext4/master
> > branch.  Now ext4/dev branch has some regression when I run xfstests.
> 
> What regressions are you seeing?

generic/300.

When I try to test my patch, I know that there has a report that
invalidate page range patch set causes a regression, and I am not sure
whether invalidate page range patch set causes it or not.  So I decide
to generate my patch against ext4/master.  So, don't worry. :-)

BTW, I will run xfstests this week.  If I meet any regression, I will
let you know.

> 
> > Ted, I notice that now in ext4 tree we have 'dev', 'dev-with-revert',
> > and 'dev2' branches.  Which one is the best to generate a new patch for
> > the next merge window?
> 
> Either the dev branch or the master branch.   
> 
> The dev-with-revert and dev2 were branches that I had created when
> investigating a potential regression with the invalidage page range
> patch set.  I've since determined that it's a timing issue and it's
> not a new regression --- we've had xfstests failures with test
> generic/300 for a while now.

Thanks for pointing it out.

                                                - Zheng
