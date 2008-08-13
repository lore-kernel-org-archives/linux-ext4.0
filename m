From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: tracepoints in ext4 (and/or ext3?)
Date: Tue, 12 Aug 2008 20:42:36 -0500
Message-ID: <48A23C0C.1070204@redhat.com>
References: <48A09E7F.7060605@redhat.com> <20080812081954.5f5eeb10@gara> <20080812163232.GC8857@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Jose R. Santos" <jrs@us.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbYHMBqt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Aug 2008 21:46:49 -0400
In-Reply-To: <20080812163232.GC8857@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Tue, Aug 12, 2008 at 08:19:54AM -0500, Jose R. Santos wrote:
>> Good idea, although Im not sure if ext[34] is the best place we should
>> start putting markers though.
> 
> I can think of ext3/4 specific markers that would be useful for people
> who are tuning our filesystems for performance.  This would include
> when we start and end tranactions, when we force a checkpoint, when we
> create and, extend, and finish using a handle in the jbd layer.

Yep this is the kind of thing I thought of at first ...

> In the ext4 itself, knowing when we are mapping delayed allocations
> would be useful, as well as when we freeze and unfreeze a filesystem
> (i.e., for snapshots).

I could imagine even things like when/where/how big each allocation is,
also maybe some things in the lookup paths...

We might even be able to ditch the mballoc history in favor of
tracepoints if desired?

-Eric

> There are a lot of other tracepoints that probably do make more sense
> to be put in the VFS layer, although on thing that would be *really*
> nice is some semantic sugar in Systemtap or in a Systemtap tapset so
> that we only trigger the tracepoints for a particular filesystem.
> 
>      	     	     	 	     	   - Ted

