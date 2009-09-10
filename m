From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2 V3] allow direct IO to fallocate and holes
Date: Thu, 10 Sep 2009 10:54:40 +0200
Message-ID: <20090910085440.GB607@duck.suse.cz>
References: <1252025090.15321.17.camel@mingming-laptop> <20090907215746.GA11748@duck.suse.cz> <1252529462.19097.170.camel@mingming-laptop> <20090910075730.GD8690@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming <cmm@us.ibm.com>, Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Eric Sandeen <sandeen@redhat.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46970 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbZIJIyl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Sep 2009 04:54:41 -0400
Content-Disposition: inline
In-Reply-To: <20090910075730.GD8690@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 10-09-09 13:27:30, Aneesh Kumar K.V wrote:
> On Wed, Sep 09, 2009 at 01:51:02PM -0700, Mingming wrote:
> .....
> .....
> 
> > >   I think fsync() still won't work correctly since it can happen user sees
> > > AIO completed, calls fsync() that completes, 
> > 
> > hmm, does fsync() ensure user sees AIO data completed?
> >
> 
> If we call fsync after getting AIO completion event and crash we should
> ensure that the data can be read back properly. That is either
> 
> a) we should ensure that we convert the extent before returning the io
>     completion event
> b) Or the fsync should be able to guarantee that it will force the extent
>    conversion pending on the file.
  Exactly.

a) should happen in the sync-io case where we can afford to do IO from the
end_io callback (and due to flush_workqueue call, it happens with the
current Mingming's patch so that is file). But for tha aio case, we have to
somehow implement b).

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
