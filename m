From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 lock ordering patch
Date: Tue, 27 May 2008 14:13:37 +0200
Message-ID: <20080527121337.GF5178@duck.suse.cz>
References: <20080526173452.GL32407@duck.suse.cz> <20080526175109.GA14718@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:46311 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754835AbYE0MNj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 May 2008 08:13:39 -0400
Content-Disposition: inline
In-Reply-To: <20080526175109.GA14718@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 26-05-08 23:21:09, Aneesh Kumar K.V wrote:
> On Mon, May 26, 2008 at 07:34:52PM +0200, Jan Kara wrote:
> >   Hi Mingming,
> > 
> >   I've noticed you removed the patch reversing locking order of page lock
> > and transaction start from ext4 patch queue. Was this because of that
> > reported performance problem or for some other reason? As far as I've
> > understood that problem has been just in the patch fixing the delalloc mode
> > part so just removing that patch would be enough AFAICT.
> >   Anyway, the problem is I have now ordered mode rewrite for JBD2/ext4
> > which depends on this patch so the question is how to proceed... Should we
> > first fix that delalloc problem (are you looking into that?) or do we merge
> > all the changes and then fixup the delalloc code?
> > 
> That was due to delalloc interaction with locking order change patches.
  What kind of interaction do you mean? My patch actually didn't handle
delalloc at all - Mingming had a patch to workaround that.

> I am right now testing some changes for delalloc. But I still have file
> system hang with fsstress. So I haven't posted the latest changes yet.
  OK and do these changes count with reversion of the locking order or
not? Because my feeling when I last looked at delalloc was that with the
lock-ordering reversed it would be better to do da_writepages() and similar
stuff differently...
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
