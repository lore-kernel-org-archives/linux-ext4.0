From: Jan Kara <jack@suse.cz>
Subject: Re: [4.7-rc6 ext3 BUG] kernel BUG at fs/ext4/xattr.c:1331
Date: Thu, 4 Aug 2016 18:18:14 +0200
Message-ID: <20160804161814.GB12861@quack2.suse.cz>
References: <20160718022356.GC1922@dastard>
 <20160718030256.GD1922@dastard>
 <83e3076d-4f84-705d-5259-b3ac1aaf90b7@redhat.com>
 <20160718052447.GE1922@dastard>
 <20160728135432.GA19398@quack2.suse.cz>
 <20160729002112.GX16044@dastard>
 <20160729064210.GA3611@quack2.suse.cz>
 <20160801030909.GD12853@thunk.org>
 <20160801121930.GB19431@quack2.suse.cz>
 <20160801130905.GH12853@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41875 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973AbcHDQSR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Aug 2016 12:18:17 -0400
Content-Disposition: inline
In-Reply-To: <20160801130905.GH12853@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 01-08-16 09:09:05, Ted Tso wrote:
> On Mon, Aug 01, 2016 at 02:19:30PM +0200, Jan Kara wrote:
> > Regarding your patch - I think it's a reasonable band-aid although I'll
> > have to backport proper fixes to 4.4 anyway (it's a base of our next
> > enterprise release), which is where i_projid got introduced as well, so
> > eventually we will have proper stable fixes for all relevant kernels
> > anyway.
> 
> Well, it depends on whether you intend to support upgrading an
> existing file system or require users to run mkfs.ext4 before being
> able to take advantage of the new feature.  Red Hat is much more
> conservative and has historically only supported running mke2fs from
> scratch --- which probably made sense from their QA department's POV,
> anyway.  The band-aid patch is enough if you don't suppor "tune2fs -O
> project", but only "mke2fs -t ext4 -O project".  I'd personally prefer
> upstream to support both flawlesssly, so I'm thankful for your work to
> fix things properly, but enterprise distros can be extremely
> conservative.

Well, in SUSE we were initially very conservative about ext4 but as ext4
has matured, we are not that cautious anymore. So e.g. turning on project
quota feature would be something we'd like to support unless there is a
really good reason not to...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
