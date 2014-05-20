From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: add sysfs entry showing whether the fs contains
 errors
Date: Tue, 20 May 2014 11:56:53 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405201150180.2162@localhost.localdomain>
References: <1399382357-12703-1-git-send-email-lczerner@redhat.com> <20140506174301.GQ8434@birch.djwong.org> <20140506192325.GB5012@thunk.org> <alpine.LFD.2.00.1405071040240.2128@localhost.localdomain> <20140520094741.GG11499@pcnci.linuxbox.cz>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-51790227-1400579474=:2162"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaETJ5C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 May 2014 05:57:02 -0400
In-Reply-To: <20140520094741.GG11499@pcnci.linuxbox.cz>
Content-ID: <alpine.LFD.2.00.1405201152170.2162@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-51790227-1400579474=:2162
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.2.00.1405201152171.2162@localhost.localdomain>

On Tue, 20 May 2014, Nikola Ciprich wrote:

> Date: Tue, 20 May 2014 11:47:41 +0200
> From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
> To: Luká¨ Czerner <lczerner@redhat.com>
> Cc: Theodore Ts'o <tytso@mit.edu>, Darrick J. Wong <darrick.wong@oracle.com>,
>     linux-ext4@vger.kernel.org, Nikola Ciprich <nikola.ciprich@linuxbox.cz>
> Subject: Re: [PATCH] ext4: add sysfs entry showing whether the fs contains
>     errors
> 
> Hello Luká¨,
> 
> just wanted to ask about the status of this patch.. it didn't make it
> to git yet, did it? Do you plan to make some changes to it? I'm eager
> to test it ;-)

No it did not and it would not given that there was not a merge
window since then. I've been distracted by other work, but I'll put
you in cc when I have a new patch - yes I plan to change the format
of the output to be more compliant with sysfs rules.

-Lukas

> 
> cheers
> 
> nik
> 
> 
> On Wed, May 07, 2014 at 10:44:34AM +0200, Luká¨ Czerner wrote:
> > On Tue, 6 May 2014, Theodore Ts'o wrote:
> > 
> > > Date: Tue, 6 May 2014 15:23:26 -0400
> > > From: Theodore Ts'o <tytso@mit.edu>
> > > To: Darrick J. Wong <darrick.wong@oracle.com>
> > > Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
> > >     nikola.ciprich@linuxbox.cz
> > > Subject: Re: [PATCH] ext4: add sysfs entry showing whether the fs contains
> > >     errors
> > > 
> > > On Tue, May 06, 2014 at 10:43:01AM -0700, Darrick J. Wong wrote:
> > > > 
> > > > Minor complaint: "contains" makes me think that cat'ing that file will return
> > > > either 0 or 1, not a string of error text.  Perhaps we could shorten it to
> > > > /sys/fs/ext4/sda/errors ?
> > > 
> > > What I'd suggest doing is simply calling it errors_count, and
> > > returning s_error_count.  While we're at it, we could also return
> > > s_first_error_time and s_last_error_time as well, since I imagine
> > > those would could be quite useful for someone trying to create a
> > > system health monitoring daemon.
> > > 
> > > Cheers,
> > > 
> > > 						- Ted
> > 
> > Right now I am using the same function which prints this information
> > to the log. So I am going to use simpler output for the sysfs.
> > 
> > <error count> <first time> <function>:<line> <last time> <function>:<line>
> > 
> > That should be easy to parse. I think that just calling it errors is
> > good enough.
> > 
> > Thanks!
> > -Lukas
> > 
> 
> 
--8323328-51790227-1400579474=:2162--
