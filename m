From: Christian Fischer <Christian.Fischer@easterngraphics.com>
Subject: Re: Enable asynchronous commits by default patch revoked?
Date: Tue, 25 Aug 2009 08:16:44 +0200
Message-ID: <200908250816.44892.Christian.Fischer@easterngraphics.com>
References: <200908241033.10527.Christian.Fischer@easterngraphics.com> <20090824133447.GH23677@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from intranet.easterngraphics.com ([62.80.28.49]:34654 "EHLO
	intranet.easterngraphics.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754001AbZHYGQw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Aug 2009 02:16:52 -0400
In-Reply-To: <20090824133447.GH23677@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Monday 24 August 2009, Theodore Tso wrote:
> On Mon, Aug 24, 2009 at 10:33:10AM +0200, Christian Fischer wrote:
> > I try to figure out reasonable mount options for ext4.
> >
> > I've seen a "Enable asynchronous commits by default" patch from Sun, 21
> > Sep 2008.
> >
> > Why is it revoked?
>
> It patch was never merged because the ayschronous commits feature
> disabled all write barriers, so under heavy workloads a power failure
> could cause data loss.
>
> No one has gotten around to looking at this closely; I think adding a
> strategically placed blkdev_issue_flush() will allow us to safely
> enable this feature, but it needs careful study.
>
> Thanks for reminding us about this bit of unfinished business.  I'll
> put it back on our todo list, where it had fallen off.  For now, it's
> not safe to use, which is why it's not enabled by default.
>
>     	    	       	      	       	       - Ted

Hi Ted,

Thanks, good to know that this better isn't to use.

Christian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
