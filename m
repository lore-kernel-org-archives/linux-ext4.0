From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: possible bug ?
Date: Wed, 19 Sep 2012 12:50:39 -0400
Message-ID: <20120919165039.GB21210@thunk.org>
References: <CAEG-z2-5=hYOZ+ZwUAE5ULQPJ2kjZ5WMv9EoTpx=c+Mik6_9ug@mail.gmail.com>
 <5059E12A.9000306@redhat.com>
 <20120919162600.GA21210@thunk.org>
 <5059F32D.10005@redhat.com>
 <5059F446.5010308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Adrian Sandu <dexter@d3xt3r01.tk>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51538 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755830Ab2ISQut (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Sep 2012 12:50:49 -0400
Content-Disposition: inline
In-Reply-To: <5059F446.5010308@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 19, 2012 at 11:35:18AM -0500, Eric Sandeen wrote:
> 
> Actually argh, too many bugs.  ;)  I was thinking of 
> https://bugzilla.redhat.com/show_bug.cgi?id=857618
>
> (Lukas pointed at upstream commit 31d4f3a2f3c73f279ff96a7135d7202ef6833f12
> to avoid the BUG_ON but we still don't know the root cause I think).
> 
> Anyway, now I'm OT for this thread.

It is OT, so I've updated the RH bugzilla with my comments.

The one thing I would add is that we haven't been able to trigger this
via xfstests, so the workload needed trigger this must be fairly
unique/unusual.  (Which is why I suggested in the bugzilla update that
if someone sees this pattern of corruption, it would be very useful to
get the pathname of the inode in question, in the hopes that this
provides some hint as to what happened.)

						- Ted
