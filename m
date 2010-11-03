From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH] ext4: optimize orphan_list handling for ext4_setattr
Date: Wed, 3 Nov 2010 11:35:41 -0600
Message-ID: <99285FCF-3BAD-4B13-9AC1-ABB3504DC82A@dilger.ca>
References: <87r5fevji5.fsf@dmon-lap.sw.ru> <93E1B72A-9C36-4CBA-AABD-DC0032331921@dilger.ca> <87sjzibvna.fsf@dmon-lap.sw.ru>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, Ted Ts'o <tytso@mit.edu>
To: Dmitry <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:14584 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab0KCRfm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Nov 2010 13:35:42 -0400
In-Reply-To: <87sjzibvna.fsf@dmon-lap.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-11-03, at 03:31, Dmitry wrote:
> On Wed, 3 Nov 2010 03:06:41 -0600, Andreas Dilger <adilger@dilger.ca> wrote:
>> 
>> Basically, the first hunk is moving the ext4_handle_valid() into the caller, and the second is avoiding a call to ext4_orphan_del->ext4_handle_valid(), which would likely be an unmeasurable performance difference.  No locks are taken (or avoided) before ext4_handle_valid() is checked.
> 
> But in case of nojournal mode it will be called with noop result.
> but orphan_del(NULL, inode) will result in useless locking. 

Looking at ext4_orphan_del(), I'm not sure why it checks:

        /* ext4_handle_valid() assumes a valid handle_t pointer */
        if (handle && !ext4_handle_valid(handle))
                return 0;

when in ext4_orphan_add() it is only checks:

        if (!ext4_handle_valid(handle))
                return 0;

I think the extra check for "handle" in ext4_orphan_del() is not needed, despite the comment there, because none of the other callsites for ext4_handle_valid() do this extra check.

>> Even better would be a no-lock check of list_empty(&ei->i_orphan()) before getting s_orphan_lock, since it shouldn't be possible to have two threads adding/removing the same inode to the orphan list (otherwise the inode may not be on the orphan list at all since add/del is not refcounted).  The only reason for s_orphan_lock is to prevent corruption of the global list.
> 
> Yes, this is the best solution. Actually i've thought about that, but
> end up with more obvious fix for nojournal mode.
> With that we can avoid 1 of 3 locks on truncate in journal mode.
> I'll test that solution.

Cheers, Andreas





