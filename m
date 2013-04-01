From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC V3] ext3: add ioctl to force 32-bit hashes from
 indexed dirs
Date: Mon, 1 Apr 2013 16:09:54 -0400
Message-ID: <20130401200954.GB24097@thunk.org>
References: <51546EED.8030507@redhat.com>
 <5154AAB4.2000701@redhat.com>
 <5159A8D5.1000204@redhat.com>
 <20130401181718.GB22443@thunk.org>
 <5159D03F.5000606@redhat.com>
 <20130401190804.GD22443@thunk.org>
 <5159E4AC.7050307@redhat.com>
 <20130401200052.GA24097@thunk.org>
 <5159E88F.8030704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Anand Avati <avati@redhat.com>, Jan Kara <jack@suse.cz>,
	jra@samba.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57919 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905Ab3DAUKB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Apr 2013 16:10:01 -0400
Content-Disposition: inline
In-Reply-To: <5159E88F.8030704@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 01, 2013 at 03:05:35PM -0500, Eric Sandeen wrote:
> 
> Meh, let's just keep it simple then.  And I'd really like to know if
> gluster still even needs this, or if their new scheme will work instead,
> in  which case we should drop it - but Samba made noise about needing it too,
> though I've not seen specifics, so I hate to merge it "just in case."

Yeah, it would be good to get some clarification about whether Samba
is doing some wierd and unnatural with telldir cookies and assuming
that they can expropriate the high 32-bits of the telldir cookie for
their own purposes or not....

Jeremy, any chance you could clarify whether or not Samba depends on
telldir cookies to be small integers?

Thanks,

					- Ted
