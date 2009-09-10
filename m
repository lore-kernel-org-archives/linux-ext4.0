From: Jan Kara <jack@suse.cz>
Subject: Re: ext4+quota+nfs issue
Date: Thu, 10 Sep 2009 14:40:56 +0200
Message-ID: <20090910124056.GI607@duck.suse.cz>
References: <4AA5E5F3.30309@primeinteractive.net> <4AA72C14.1020005@primeinteractive.net> <alpine.LRH.2.00.0909091141300.25928@twin.jikos.cz> <4AA7C38E.8020306@redhat.com> <1252531929.19097.174.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
	Pavol Cvengros <pavol.cvengros@primeinteractive.net>,
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:39466 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbZIJMk6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Sep 2009 08:40:58 -0400
Content-Disposition: inline
In-Reply-To: <1252531929.19097.174.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 09-09-09 14:32:09, Mingming wrote:
> On Wed, 2009-09-09 at 10:02 -0500, Eric Sandeen wrote:
> > Jiri Kosina wrote:
> > > [ adding relevant CCs ]
> > > 
> > > On Wed, 9 Sep 2009, Pavol Cvengros wrote:
> > > 
> > >> Hi,
> > >>
> > >> can somebody who is aware of ext4 and quota have a look on this one?
> > >>
> > 
> > This was also just reported at:
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=521914
> > 
> 
> Checked the bugzilla, it seems the fs enabled quota, but no user quota
> limit is specified. Is this the case with the ext4 quota+ nfs issue too?
> 
> If no user quota is specified, then IS_NOQUOTA() should avoid doing
> quota reservation/claim at all. Not sure what is missing... I will check
> if I could reproduce this on local filesystem...
  Mingming, IS_NOQUOTA() check is true only for quota-files. For all other
files it is false since we have to know how much space each user uses even
if it does not have a quota limit set (for the case that someone sets the
limit in future).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
