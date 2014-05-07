From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: add sysfs entry showing whether the fs contains
 errors
Date: Wed, 7 May 2014 10:44:34 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405071040240.2128@localhost.localdomain>
References: <1399382357-12703-1-git-send-email-lczerner@redhat.com> <20140506174301.GQ8434@birch.djwong.org> <20140506192325.GB5012@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org, nikola.ciprich@linuxbox.cz
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784AbaEGIoo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 May 2014 04:44:44 -0400
In-Reply-To: <20140506192325.GB5012@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 6 May 2014, Theodore Ts'o wrote:

> Date: Tue, 6 May 2014 15:23:26 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Darrick J. Wong <darrick.wong@oracle.com>
> Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
>     nikola.ciprich@linuxbox.cz
> Subject: Re: [PATCH] ext4: add sysfs entry showing whether the fs contains
>     errors
> 
> On Tue, May 06, 2014 at 10:43:01AM -0700, Darrick J. Wong wrote:
> > 
> > Minor complaint: "contains" makes me think that cat'ing that file will return
> > either 0 or 1, not a string of error text.  Perhaps we could shorten it to
> > /sys/fs/ext4/sda/errors ?
> 
> What I'd suggest doing is simply calling it errors_count, and
> returning s_error_count.  While we're at it, we could also return
> s_first_error_time and s_last_error_time as well, since I imagine
> those would could be quite useful for someone trying to create a
> system health monitoring daemon.
> 
> Cheers,
> 
> 						- Ted

Right now I am using the same function which prints this information
to the log. So I am going to use simpler output for the sysfs.

<error count> <first time> <function>:<line> <last time> <function>:<line>

That should be easy to parse. I think that just calling it errors is
good enough.

Thanks!
-Lukas
