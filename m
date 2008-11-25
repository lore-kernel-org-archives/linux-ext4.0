From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] imporve jbd2 fsync batching
Date: Tue, 25 Nov 2008 15:41:15 -0700
Message-ID: <20081125224115.GW3186@webber.adilger.int>
References: <20081104161024.GC28058@unused.rdu.redhat.com>
 <20081125102335.GB9882@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Josef Bacik <jbacik@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:64753 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbYKYWlT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Nov 2008 17:41:19 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAPMfIwm000787
	for <linux-ext4@vger.kernel.org>; Tue, 25 Nov 2008 14:41:18 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAW00I01UT29500@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 25 Nov 2008 14:41:18 -0800 (PST)
In-reply-to: <20081125102335.GB9882@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 25, 2008  05:23 -0500, Theodore Ts'o wrote:
> On Tue, Nov 04, 2008 at 11:10:25AM -0500, Josef Bacik wrote:
> > +	commit_time = ktime_to_ns(ktime_sub(ktime_get(), start_time));
> > +
> > +	/*
> > +	 * weight the commit time higher than the average time so we don't
> > +	 * react too strongly to vast changes in the commit time
> > +	 */
> > +	if (likely(journal->j_average_commit_time))
> > +		journal->j_average_commit_time = (commit_time*3 +
> > +				journal->j_average_commit_time) / 4;
> 
> Stupid question... if the goal is to not have the average commit time
> not react too strongly to sudden and vast changes to the commit time,
> would it be better to do this instead:
> 
> > +		journal->j_average_commit_time = (commit_time +
> > +				journal->j_average_commit_time*3) / 4;

Actually, yes.  That is my fault, I'd suggested the original change to
Josef.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

