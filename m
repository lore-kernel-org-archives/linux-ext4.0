From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: make "norecovery" an alias for "noload"
Date: Thu, 19 Nov 2009 17:10:45 +0100
Message-ID: <20091119161045.GG24836@duck.suse.cz>
References: <4B01D749.3030601@redhat.com>
 <20091119151233.GE24836@duck.suse.cz>
 <4B056AF8.3010604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:35725 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbZKSQKj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Nov 2009 11:10:39 -0500
Content-Disposition: inline
In-Reply-To: <4B056AF8.3010604@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 19-11-09 09:57:44, Eric Sandeen wrote:
> Jan Kara wrote:
> > On Mon 16-11-09 16:50:49, Eric Sandeen wrote:
> >> Users on the list recently complained about differences across
> >> filesystems w.r.t. how to mount without a journal replay.
> >>
> >> In the discussion it was noted that xfs's "norecovery" option is
> >> perhaps more descriptively accurate than "noload," so let's make
> >> that an alias for ext3.
> >>
> >> Also show this status in /proc/mounts
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >   OK, provided ext4 will have the same change, I'm fine with the patch.
> > So how is it with ext4?
> 
> I did send the same patch for ext4
> 
> "[PATCH 2/2] ext4: make "norecovery" an alias for "noload""
  Obviously I'm too lame at googling ;). OK, I've merged the patch to
for_next branch.

									Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
