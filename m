From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4_freeze: don't return to userspace with a mutex held
Date: Sun, 04 Apr 2010 16:23:32 -0500
Message-ID: <4BB90354.3040300@redhat.com>
References: <4BB12B03.9070906@redhat.com> <20100404205237.GK18524@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986Ab0DDVXk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Apr 2010 17:23:40 -0400
In-Reply-To: <20100404205237.GK18524@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu wrote:
> On Mon, Mar 29, 2010 at 05:34:43PM -0500, Eric Sandeen wrote:
>> I don't -think- we need to do this; by now we should have s_frozen
>> set, and nobody else should be coming down the pipe to get to
>> the journal.  However, just to be on the safe side, I added
>> a couple of vfs_check_frozen() calls in ext4 functions which will
>> arrive at start_this_handle(), which should ensure that we never
>> get any journal traffic generated while frozen.
> 
> Um, I think the addition of vfs_check_frozen(), esp. to
> ext4_journal_start_sb() is absolutely necessary.  What else do we have
> to prevent filesystem modifications from going to the file systme
> layer?  I didn't see anything in the VFS layer that checks s_frozen;
> am I missing something?
> 
> 					- Ted

Well, there is __generic_file_aio_write doing vfs_check_frozen, but
I thought there was more at the vfs level to stop things from getting
to the filesystem... *shrug* I see you put the patch in as sent,
it sounds right to me.

Thanks,
-Eric
