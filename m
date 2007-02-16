From: Theodore Tso <tytso@mit.edu>
Subject: Re: booked-page-flag.patch
Date: Fri, 16 Feb 2007 10:03:08 -0500
Message-ID: <20070216150308.GB25957@thunk.org>
References: <20070215004504.023a90f0.akpm@linux-foundation.org> <45D495EA.3060200@redhat.com> <m3k5yj49bw.fsf@bzzz.home.net> <20070215125654.b0f18ab3.akpm@linux-foundation.org> <m3fy973z9w.fsf@bzzz.home.net> <20070215152352.6ddcfa92.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>, Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40466 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945966AbXBPQHf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Feb 2007 11:07:35 -0500
Content-Disposition: inline
In-Reply-To: <20070215152352.6ddcfa92.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Feb 15, 2007 at 03:23:52PM -0800, Andrew Morton wrote:
> > one more question: how much of it you want in VFS?
> 
> As much as possible, really.  It's probably too late for XFS to reuse any
> new infrastructure, but if the infrastructure is well-designed it _should_
> be possible to us it in new filesytems, and to convert ext2.

Actually, in a hallway conversation with David Chinner at the Linux
filesystem/storage workshop this week, it sounded like he was willing
to at least consider changing XFS to use a VFS-based infrastructure.
So when we put together a proposal for how to do this in the XFS
layer, I would suggest cc'ing the linux-fsdevel list.

Regards,

						- Ted
