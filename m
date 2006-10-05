From: =?iso-8859-1?Q?Bj=F6rn?= JACKE <bjacke@sernet.de>
Subject: Re: creation time stamps for ext4 ?
Date: Thu, 5 Oct 2006 21:23:12 +0200
Message-ID: <E1GVYnq-00004v-00@intern.SerNet.DE>
References: <E1GVUd2-0006O6-00@intern.SerNet.DE> <20061005151937.GV22010@schatzie.adilger.int> <20061005165504.GA23727@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext3-users@redhat.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.SerNet.DE ([193.175.80.2]:31187 "EHLO mail.SerNet.de")
	by vger.kernel.org with ESMTP id S1750839AbWJETWo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Oct 2006 15:22:44 -0400
To: Theodore Tso <tytso@mit.edu>
Content-Disposition: inline
In-Reply-To: <20061005165504.GA23727@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2006-10-05 at 12:55 -0400 Theodore Tso sent off:
> > I've given this some thought for adding as part of the nsec timestamp
> > patch.  That is more feasable if we move the nsec ctime into the main
> > inode to double as the version field.
> 
> Shoehorning an extra creation time field into the inode is relatively
> easy, but it's also necessary to have system calls to get and set the
> creation time.  The stat structure doesn't have room for the creation
> time, so that means a new version of the stat structure exported the
> kernel, and a new version of the stat structure exported by glibc.
> 
> So there are VFS and glibc changes necessary to make this be useful.
> But that doesn't prevent us from reserving space in the inode and
> starting to fill it in with the creation time, although it may be
> quite a while before it will be easily available to user programs like
> Samba.

yes, probably. But it's a reasonable effort to start that at some 
time. It's good if ext3 developers have it in mind already now.
Should I open a feature request at bugzilla.kernel.org for the needed 
VFS changes?

Bjoern
