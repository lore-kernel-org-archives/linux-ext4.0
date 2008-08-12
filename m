From: Theodore Tso <tytso@mit.edu>
Subject: Re: tracepoints in ext4 (and/or ext3?)
Date: Tue, 12 Aug 2008 12:32:32 -0400
Message-ID: <20080812163232.GC8857@mit.edu>
References: <48A09E7F.7060605@redhat.com> <20080812081954.5f5eeb10@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:36791 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750987AbYHLQcv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Aug 2008 12:32:51 -0400
Content-Disposition: inline
In-Reply-To: <20080812081954.5f5eeb10@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 12, 2008 at 08:19:54AM -0500, Jose R. Santos wrote:
> 
> Good idea, although Im not sure if ext[34] is the best place we should
> start putting markers though.

I can think of ext3/4 specific markers that would be useful for people
who are tuning our filesystems for performance.  This would include
when we start and end tranactions, when we force a checkpoint, when we
create and, extend, and finish using a handle in the jbd layer.

In the ext4 itself, knowing when we are mapping delayed allocations
would be useful, as well as when we freeze and unfreeze a filesystem
(i.e., for snapshots).

There are a lot of other tracepoints that probably do make more sense
to be put in the VFS layer, although on thing that would be *really*
nice is some semantic sugar in Systemtap or in a Systemtap tapset so
that we only trigger the tracepoints for a particular filesystem.

     	     	     	 	     	   - Ted
