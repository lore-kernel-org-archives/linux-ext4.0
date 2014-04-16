From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] check: add support for an external test expunging file
Date: Wed, 16 Apr 2014 10:34:17 +1000
Message-ID: <20140416003417.GZ15995@dastard>
References: <1397530320-20579-1-git-send-email-tytso@mit.edu>
 <20140416001530.GU15995@dastard>
 <20140416002550.GB12078@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:57327 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838AbaDPAec (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Apr 2014 20:34:32 -0400
Content-Disposition: inline
In-Reply-To: <20140416002550.GB12078@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 15, 2014 at 08:25:50PM -0400, Theodore Ts'o wrote:
> On Wed, Apr 16, 2014 at 10:15:30AM +1000, Dave Chinner wrote:
> > > If the argument to the -X option is a pathname (that is, includes a
> > > '/' character), treat it as the latter case.  If it the argument to
> > > the -X option is just a bare filename (that is, does not include '/'
> > > character), treat it as the former.
> > 
> > Can you add a new option rather than overloading the existing one
> > with new meanings and semantics?
> 
> If that's your preference, sure.  How does --expunge-list-file strike
> you?  Or would you prefer something else?  I'm easy.  :-)

-E/--expunge-file is fine by me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
