From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 23/25] libext2fs: support modifying arbitrary extended
 attributes
Date: Wed, 27 Nov 2013 19:36:19 +0800
Message-ID: <20131127113619.GA13435@gmail.com>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
 <20131018045134.7339.30673.stgit@birch.djwong.org>
 <20131126072115.GA22136@gmail.com>
 <20131126195547.GB3068@birch.djwong.org>
 <20131127025232.GB1016@gmail.com>
 <20131127031318.GH10269@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:33548 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab3K0Ld3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Nov 2013 06:33:29 -0500
Received: by mail-pb0-f53.google.com with SMTP id ma3so10231985pbc.12
        for <linux-ext4@vger.kernel.org>; Wed, 27 Nov 2013 03:33:28 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131127031318.GH10269@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 26, 2013 at 07:13:18PM -0800, Darrick J. Wong wrote:
> On Wed, Nov 27, 2013 at 10:52:32AM +0800, Zheng Liu wrote:
> > On Tue, Nov 26, 2013 at 11:55:47AM -0800, Darrick J. Wong wrote:
> > > On Tue, Nov 26, 2013 at 03:21:16PM +0800, Zheng Liu wrote:
> > > > On Thu, Oct 17, 2013 at 09:51:34PM -0700, Darrick J. Wong wrote:
> > > > > Add functions to allow clients to get, set, and remove extended
> > > > > attributes from any file.  It also supports modifying EAs living in
> > > > > i_file_acl.
> > > > > 
> > > > > v2: Put the header declarations in the correct part of ext2fs.h,
> > > > > provide a function to release an EA block from an inode, and check
> > > > > i_extra_isize to make sure we actually have space for in-inode EAs.
> > > > 
> > > > Is this the latest version?  I am working on inline data patch set for
> > > > e2fsprogs, and I want to use these API to manipulate the EA.  So that
> > > > would be great if you could point out which one is the latest version.
> > > > Thanks in advance.  Otherwise some nits below.
> > > 
> > > Oh!  I was just about to start working on pulling your patches into my monster
> > > patchset. :)
> > 
> > Wow!  Sorry for my late.  If you just begin to work on inline data
> > patchset.  Would you mind sending your latest monster patchset without
> > my inline data patchset first?  That gives me a chance to take a closer
> > look at them.  In general, I will send my patch set asap.
> 
> Don't worry about the timing.  I've been busy with a lot of other things.
> Every time I think I'm done and can start on inline_data, I find another weird
> test case that breaks things, so I have to go back and figure out what went
> wrong.
> 
> The patchbomb lives here: https://djwong.org/docs/e2fsprogs-patches/ 
> 
> Patch 22 is the end of my last (Oct. 2013) patchbomb.  I think the relevant
> ones you want are #20 and #24-32.  You can skip #26-27 if you don't care about
> fuse2fs.

Got it.  Thanks for your help. :)

                                                - Zheng
