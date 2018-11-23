Return-Path: <SRS0=kdxW=OC=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32884 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388020AbeKWW7D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 23 Nov 2018 17:59:03 -0500
Date: Fri, 23 Nov 2018 13:15:03 +0100
From: Jan Kara <jack@suse.cz>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] ext4: add ext4_sb_bread() to disambiguate ENOMEM cases
Message-ID: <20181123121503.GB31877@quack2.suse.cz>
References: <20181117233523.8832-1-tytso@mit.edu>
 <20181122122155.GN9840@quack2.suse.cz>
 <20181122211233.GB7843@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181122211233.GB7843@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 22-11-18 16:12:33, Theodore Y. Ts'o wrote:
> On Thu, Nov 22, 2018 at 01:21:55PM +0100, Jan Kara wrote:
> > 
> > Is there a reason for REQ_PRIO? I'm not sure all REQ_META reads are really
> > a priority ones...
> 
> Hmm, good question.  With the exception of readahead, most reads will
> be blocking some process.  We are currently using REQ_PRIO for all
> directory block reads.  The ext4_sb_read() function gets used for
> resizing, indirect block map to extent tree migration, and extended
> attribute reads.  The last is the most common, and arguably the most
> justifiable to be REQ_PRIO.  (Of course my understanding is that the
> block layer is ignoring REQ_PRIO, so this is mostly academic...)

Agreed that this is currently academic but AFAIR some blk-mq schedulers
might be improved to consider REQ_PRIO again.

> So I think what I'll do is this.  I'll add a parameter to
> ext4_sb_read() so each caller can use use REQ_PRIO.  REQ_PRIO will be
> used from xattr.c, but not from fs/ext4/migrate.c and
> fs/ext4/resize.c.

Sounds good. Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
