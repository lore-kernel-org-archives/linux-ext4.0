From: Andreas Dilger <adilger@sun.com>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Mon, 5 Nov 2007 23:06:36 +0800
Message-ID: <20071105150636.GB2892@webber.adilger.int>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071105021533.GA3055@webber.adilger.int> <20071105043222.GA30552@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:59566 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbXKEPGm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Nov 2007 10:06:42 -0500
Content-Disposition: inline
In-Reply-To: <20071105043222.GA30552@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Nov 04, 2007  23:32 -0500, Theodore Tso wrote:
> On Mon, Nov 05, 2007 at 10:15:33AM +0800, Andreas Dilger wrote:
> > On Nov 04, 2007  17:42 -0500, Theodore Ts'o wrote:
> > > * js/uninit (Sun Oct 21 21:04:24 2007 -0500) 14 commits
> > >  - Add m_uninit test case.
> > >  - Add new mm_lazy test case.
> > >  - Fix test cases.
> > 
> > Do you have all of the f_uninit test cases we made?
> > 
> > f_uninit_bad_free_inodes
> > f_uninit_blk_used_not_set
> > f_uninit_checksum_bad
> > f_uninit_disable
> > f_uninit_enable
> > f_uninit_inode_past_unused
> > f_uninit_last_uninit
> > f_uninit_set_inode_not_set
> 
> Nope, it wasn't in the patches that Jose sent out.  I assume they're
> in the CFS e2fsprogs?

Yes.  You can get our full patch series at:

ftp://ftp.lustre.org/pub/lustre/other/e2fsprogs/e2fsprogs-1.40.2-cfs1.patches.tgz

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
