From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/8] Add test of quota accounting using fsx
Date: Tue, 27 Jul 2010 10:15:38 +0200
Message-ID: <20100727081538.GB3358@quack.suse.cz>
References: <1274710459-11446-1-git-send-email-jack@suse.cz>
 <1274710459-11446-5-git-send-email-jack@suse.cz>
 <4C0FD43D.3040803@sandeen.net>
 <20100615095505.GB3347@quack.suse.cz>
 <4C4E0229.5040002@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, hch@infradead.org, xfs@oss.sgi.com,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58246 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755815Ab0G0IQG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jul 2010 04:16:06 -0400
Content-Disposition: inline
In-Reply-To: <4C4E0229.5040002@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 26-07-10 16:46:17, Eric Sandeen wrote:
> On 06/15/2010 04:55 AM, Jan Kara wrote:
> > On Wed 09-06-10 12:49:49, Eric Sandeen wrote:
> >> Jan Kara wrote:
> >>> Run fsx (and also several fsx threads in parallel) and verify that
> >>> quota accounting is correct after they finish.
> >>
> >> Jan, I'm having trouble with this one on XFS for some reason, with our 
> >> RHEL6 kernel and quota-3.17...
> >   OK, attached is an improvement to the XFSQA tests after which all quota
> > tests pass for XFS just fine.
> >   The second patch is just minor general improvement of _require_scratch
> > macro.
> >   Could they be added to XFSQA repository? Thanks.
> 
> Jan, I've got some ext4 failures reported on these, although I can't hit
> them, so not quite sure what's going on.
> 
> In 231:
> 
> +< fsgqa     --     760       0       0              3     0     0
> +---
> +> fsgqa     --     764       0       0              3     0     0
> +14c14
> +< fsgqa     --     760       0       0              3     0     0
> +---
> +> fsgqa     --     764       0       0              3     0     0
> 
> after the quotacheck & repquota we have 4 more blocks.  Maybe this
> is due to my accounting of metadata blocks at write time, and not
> before ... would it be reasonable to put a sync call as the first
> line of check_usage() ?
  Just last week a change went into xfstests which introduces a generic
quota checking function and uses sync before getting quota usage. I think
xfstests passed for me with ext4 after this change but I've now restarted
the tests to recheck it.
  
> Also in 233:
> 
> +< #501      --   15392       0       0            998     0     0
> +< #501      --   15392   32000   32000            998  1000  1000
> +---
> +> #501      +-   32084   32000   32000  7days     998  1000  1000
> +> #501      --   32084       0       0            998     0     0
> 
> "7days" magically appeared after the quotacheck.  Not sure what's going
> on there...
  That's because the usage after checking exceeded block soft limit and
thus grace time has been set. So it's the same problem as in the above
test.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
