From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH 0/3] ext4: inode preferred block allocation
Date: Tue, 20 Apr 2010 00:39:38 +0200
Message-ID: <20100419223938.GJ5439@quack.suse.cz>
References: <4BC57A1D.9080105@sx.jp.nec.com>
 <g2q87f94c371004150922qb636f468t9cf3b6cb8cfd7b03@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kazuya Mio <k-mio@sx.jp.nec.com>,
	ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
	linux-fsdevel@vger.kernel.org,
	OHSM-DEV <ohsm-devel@lists.sourceforge.net>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39262 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157Ab0DSWjf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Apr 2010 18:39:35 -0400
Content-Disposition: inline
In-Reply-To: <g2q87f94c371004150922qb636f468t9cf3b6cb8cfd7b03@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 15-04-10 12:22:38, Greg Freemyer wrote:
<snip>
> fyi: Creating locality groups is the use case I see for Dmitry's
> Project ID patchset.  A collection of files that are used together can
> be assigned a unique ProjectID and then e4defrag can grow the
> knowledge to place them within a locality area on the disk.
> 
> But I also can see that new files within a directory would inherit the
> ProjectID from the directory, and the data blocks allocated from the
> correct locality area from the get go.
> 
> Dmitry, I haven't studied your patchset, but does it allow for
> ProjectID inheritance from the parent directory?
  Yes, ProjectID should be inherited from the parent directory.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
