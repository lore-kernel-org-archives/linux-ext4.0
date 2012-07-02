From: Jan Kara <jack@suse.cz>
Subject: Re: ext4_fallocate
Date: Mon, 2 Jul 2012 19:44:21 +0200
Message-ID: <20120702174421.GM6679@quack.suse.cz>
References: <20120625191744.GB9688@thunk.org>
 <4FE9B57F.4030704@redhat.com>
 <4FE9F9F4.7010804@zoho.com>
 <4FEA0DD1.8080403@gmail.com>
 <4FEA1415.8040809@redhat.com>
 <4FEA1F18.6010206@redhat.com>
 <20120627193034.GA3198@thunk.org>
 <4FEB9115.6090309@redhat.com>
 <20120702031611.GB2406@gmail.com>
 <4FF1CD5D.8010904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Fredrick <fjohnber@zoho.com>,
	Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@dilger.ca>, wenqing.lz@taobao.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53293 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755899Ab2GBRoY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jul 2012 13:44:24 -0400
Content-Disposition: inline
In-Reply-To: <4FF1CD5D.8010904@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 02-07-12 11:33:33, Eric Sandeen wrote:
> On 07/01/2012 10:16 PM, Zheng Liu wrote:
> > Hi Eric,
> > 
> > Could you please run this test with 'journal_async_commit' flag.  In my
> > previous test, this feature can dramatically improve the performance of
> > uninitialized extent conversion.
> > 
> > I have sent an email to do a similar test [1].  In that email, I do a
> > similar test and the journal_async_commit flag quite can improve the
> > performance.
> 
> I can try to find time for that, but so far I haven't actually seen any
> severe impact of conversion on a non-debug kernel.  And didn't Jan think
> that journal_async_commit was fatally flawed?
  Yes, that option is broken and basically unfixable for data=ordered mode
(see http://comments.gmane.org/gmane.comp.file-systems.ext4/30727). For
data=writeback it works fine AFAICT.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
