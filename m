From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] ext4: add debug_want_extra_isize mount option
Date: Thu, 12 Jan 2017 21:58:35 -0500
Message-ID: <20170113025835.hekkmb3jdxg2yhj5@thunk.org>
References: <20170112034938.5934-1-tytso@mit.edu>
 <20170112034938.5934-2-tytso@mit.edu>
 <EBB78DF0-12A8-45DA-B61C-695E8DE358DB@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux@sciencehorizons.net
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41336 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750885AbdAMC6i (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 12 Jan 2017 21:58:38 -0500
Content-Disposition: inline
In-Reply-To: <EBB78DF0-12A8-45DA-B61C-695E8DE358DB@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 12, 2017 at 12:19:37PM -0700, Andreas Dilger wrote:
> On Jan 11, 2017, at 8:49 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> > 
> > In order to test the inode extra isize expansion code, it is useful to
> > be able to easily create file systems that have inodes with extra
> > isize values smaller than the current desired value.
> 
> Rather than adding all of the debug hooks as mount options, wouldn't it
> make more sense to add tunables via debugfs or as an attr_extra_isize or
> similar?

Debugfs would be lot more complicated to implement, and especially if
we had to set up a separate directory hierarchy for each file system.
And both debugfs and setting it up in sysfs would mean more runtime
memory in use for each file system this is mounted.  The mount option
is actually one of the simpler, lighter weight ways of adding the
debug hook.

What's the objection (or objections) you have to using mount options?

       	   	   	     	      - Ted
