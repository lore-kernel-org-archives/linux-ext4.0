From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/12] container quota: bill container inodes alloc/free
 on ext4.
Date: Tue, 5 Jun 2012 10:03:03 +1000
Message-ID: <20120605000302.GC4347@dastard>
References: <1338389946-13711-1-git-send-email-jeff.liu@oracle.com>
 <1338389946-13711-11-git-send-email-jeff.liu@oracle.com>
 <4FC736AD.2070404@parallels.com>
 <4FC76B0D.6020804@oracle.com>
 <4FC76ECA.3070301@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jeff.liu@oracle.com, containers@lists.linux-foundation.org,
	cgroups@vger.kernel.org, jack@suse.cz, daniel.lezcano@free.fr,
	Ted Ts'o <tytso@mit.edu>, bpm@sgi.com, chris.mason@oracle.com,
	hch@infradead.org, christopher.jones@oracle.com, tinguely@sgi.com,
	tm@tao.ma, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Glauber Costa <glommer@parallels.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:65173 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751935Ab2FEADJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Jun 2012 20:03:09 -0400
Content-Disposition: inline
In-Reply-To: <4FC76ECA.3070301@parallels.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 31, 2012 at 05:14:50PM +0400, Glauber Costa wrote:
> On 05/31/2012 04:58 PM, Jeff Liu wrote:
> >>>  This should be inside dquot_free_inode().
> >Yeah, Ted also mentioned this before, all name space dquot bill routine
> >could be placed to dquot_xxx() for VFS quota user.
> >
> >However, AFAICS, they still have to be exported to other file systems
> >which have their own quota management module, like XFS.
> >
> >Thanks,
> >-Jeff
> >
> Do you have a personal need to have it working with xfs, or is the
> use you are pursuing achievable with the other filesystems?
> 
> Unless you have a reason yourself to use xfs, I'd say don't bother
> with it too much at the moment. get it working for the standard
> interface first.

Which means you'll end up with something that has to be rewritten to
support XFS. Do it right the first time.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
