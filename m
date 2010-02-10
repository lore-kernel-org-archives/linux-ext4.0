From: tytso@mit.edu
Subject: Re: ext5
Date: Wed, 10 Feb 2010 16:50:28 -0500
Message-ID: <20100210215028.GD739@thunk.org>
References: <fe37fadb578fb9a3df9c878f8b9e9c3e@remailer.privacy.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Anonymous Remailer (austria)" <mixmaster@remailer.privacy.at>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:57706 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036Ab0BJVue (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Feb 2010 16:50:34 -0500
Content-Disposition: inline
In-Reply-To: <fe37fadb578fb9a3df9c878f8b9e9c3e@remailer.privacy.at>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 10, 2010 at 12:40:05AM +0100, Anonymous Remailer (austria) wrote:
> 
> will there be ext5? ext4 works just fine so far. but it could be
> even more faster. otherwise i have to jump to btrfs (when it's
> done).

We currently don't have any plans for an "ext5".  There might be some
new features that might gradually trickle into ext4; for example
there's someone who I may be mentoring who is interested in working on
an idea I've had to add read-only compression to ext4.  (Actually, the
design I've sketched out makes 90% of the work be file system
independent, so it's something that could be retrofitted into other
filesystems: xfs, btrfs, etc.)

The benchmarks I've seen don't show that btrfs is that much faster;
for some workloads its faster, for others its slower.  Of course,
there may be some file system tuning that still remains to be done,
both for btrfs and ext4, that may change the performance numbers
slightly.

The main reason why I suspect people will be interested in btrfs is to
because of some of its features (i.e., file system level snapshots,
data level checksums, etc.) that are unlikely to show up in ext4.  I
also suspect that btrfs will take a while to mature, as all file
systems do.  ZFS for example took good five years to development, and
perhaps another 3-4 before people started really trusting it for
critical production uses.

Regards,

						- Ted
