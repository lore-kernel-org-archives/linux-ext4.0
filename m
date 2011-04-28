From: Jan Kara <jack@suse.cz>
Subject: Re: [BUG] fatal hang untarring 90GB file, possibly writeback
 related.
Date: Thu, 28 Apr 2011 15:52:28 +0200
Message-ID: <20110428135228.GC1696@quack.suse.cz>
References: <1303920553.2583.7.camel@mulgrave.site>
 <1303921583-sup-4021@think>
 <1303923000.2583.8.camel@mulgrave.site>
 <1303923177-sup-2603@think>
 <1303924902.2583.13.camel@mulgrave.site>
 <1303925374-sup-7968@think>
 <1303926637.2583.17.camel@mulgrave.site>
 <1303934716.2583.22.camel@mulgrave.site>
 <1303990590.2081.9.camel@lenovo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: James Bottomley <James.Bottomley@suse.de>,
	Chris Mason <chris.mason@oracle.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, mgorman@novell.com
To: colin.king@canonical.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:56072 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759654Ab1D1Nwa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Apr 2011 09:52:30 -0400
Content-Disposition: inline
In-Reply-To: <1303990590.2081.9.camel@lenovo>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 28-04-11 12:36:30, Colin Ian King wrote:
> One more data point to add, I've been looking at an identical issue when
> copying large amounts of data.  I bisected this - and the lockups occur
> with commit 
> 3e7d344970673c5334cf7b5bb27c8c0942b06126 - before that I don't see the
> issue. With this commit, my file copy test locks up after ~8-10
> iterations, before this commit I can copy > 100 times and don't see the
> lockup.
  Adding Mel to CC, I guess he'll be interested. Mel, it seems this commit
of yours causes kswapd on non-preempt kernels spin for a *long* time...

								Honza
> On Wed, 2011-04-27 at 15:05 -0500, James Bottomley wrote:
> > On Wed, 2011-04-27 at 12:50 -0500, James Bottomley wrote:
> > > To test the theory, Chris asked me to try with data=ordered.
> > > Unfortunately, the deadlock still shows up.  This is what I get.
> > 
> > As another data point: I'm trying the same kernel with CONFIG_PREEMPT
> > enabled.  This time the deadlock doesn't happen.  Instead, kswapd0 gets
> > pegged at 99% CPU for much of the untar, but it does eventually
> > complete.
> > 
> > James
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
