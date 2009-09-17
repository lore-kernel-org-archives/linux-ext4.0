From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: Filessystem corruptions while using rsnapshot
Date: Thu, 17 Sep 2009 22:33:44 +0200
Message-ID: <20090917203344.GA1874@phenom2.trippelsdorf.de>
References: <20090909133026.GA1965@phenom2.trippelsdorf.de>
 <4AA7BE69.7070406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-153.synserver.de ([212.40.180.153]:1045 "HELO
	smtp-out-153.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753323AbZIQUdo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Sep 2009 16:33:44 -0400
Content-Disposition: inline
In-Reply-To: <4AA7BE69.7070406@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 09, 2009 at 09:40:41AM -0500, Eric Sandeen wrote:
> Markus Trippelsdorf wrote:
> > I'm using rsnapshot (http://rsnapshot.org/) to automatically backup my
> > root filesystem (btrfs) to a second harddrive running ext4. Rsnapshot
> > uses rsync and a massive amount of hard links to keep multiple backups
> > instantly available. 
> > It seems that the sheer number of hard links overwhelms ext4 and results
> > in problems that require manual fsck.ext4 runs to bring the fs back to
> > normal.
> > 
> > For example this is output from fsck.ext4:
> > 
> > Problem in HTREE directory inode <some number> 
> > ... node <increasing number> has invalid depth (2)
> > ... node <increasing number> has bad mxhash
> > ... node <increasing number> not referenced
> > 
> > This output is repeated ad nauseam while <increasing number> increases
> > at each round.
> > 
> > The bug is very simple to reproduce here. Just run rsnapshot several
> > times per day and you will eventually hit the problem.
> 
> Could you provide a bzip2'd e2image -r of a corrupted filesystem for 
> analysis?

Eric, I'm sorry that I may have wasted your time with this.
It turned out that a bad RAM module was the most likely cause of these
corruptions. (I've found out only today, after I got btrfs csum errors
in my log, see: http://thread.gmane.org/gmane.comp.file-systems.btrfs/3613)

So please accept my apologies.
Thanks.
-- 
Markus
