From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] ext4_freeze: don't return to userspace with a mutex held
Date: Sun, 4 Apr 2010 17:56:38 -0400
Message-ID: <A0351AEF-E91E-4CD8-A38E-DAE3EEEBB127@mit.edu>
References: <4BB12B03.9070906@redhat.com> <20100404205237.GK18524@thunk.org> <4BB90354.3040300@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:50795 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752013Ab0DDWBo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Apr 2010 18:01:44 -0400
In-Reply-To: <4BB90354.3040300@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Apr 4, 2010, at 5:23 PM, Eric Sandeen wrote:
> 
> Well, there is __generic_file_aio_write doing vfs_check_frozen, but
> I thought there was more at the vfs level to stop things from getting
> to the filesystem... *shrug* I see you put the patch in as sent,
> it sounds right to me.

Yeah, it looks safe but it would be nice to do some testing to make sure there's nothing we missed.

I'm also vaguely worried whether the right thing will happen in no-journal mode, but it looks like it's better than what we had before (which clearly would have never worked in no journal mode), so I decided to let it pass.

Testing the freeze functionality definitely needs to be done before we trust what happens in no journal mode, for sure.

-- Ted

