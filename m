From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/5] jbd2: Pass extra bool parameter in journal
 routines to specify if its ok to fail the journal transaction allocation.
Date: Tue, 24 May 2011 20:25:20 -0400
Message-ID: <20110525002520.GM26055@thunk.org>
References: <BANLkTinNUxt_Bj0JErLVDbh=73JHzzS9=w@mail.gmail.com>
 <20110524225643.GK26055@thunk.org>
 <BANLkTin2=C48nGj0AAf99kiX0aoEBHshtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35604 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757405Ab1EYAZb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 May 2011 20:25:31 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTin2=C48nGj0AAf99kiX0aoEBHshtw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 24, 2011 at 05:14:22PM -0700, Manish Katiyar wrote:
> Thanks for your feedback. I'm still learning how to get my somewhat
> useful change into ext4 :-) so will keep these points in mind. Yes,
> Jan had also pointed that these patches need to be bisectable, so
> actually the last version of the patch in the thread should be
> complete in itself. But if you say, I can resend the two patches which
> have been reviewed and ack'd by Jan in a new separate mail thread with
> appropriate changelog and you can ignore these then. Is that ok ?

Yes please.  Since that will cause the other patches to get
renumbered, it's best if you resend them all as a separate mail
thread.

							- Ted
