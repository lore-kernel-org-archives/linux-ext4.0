From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Always journal quota file modifications
Date: Thu, 3 Jun 2010 13:54:40 +0200
Message-ID: <20100603115439.GA3814@quack.suse.cz>
References: <1275488593-7237-1-git-send-email-jack@suse.cz>
 <87eigo1o2q.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37039 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab0FCLy5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Jun 2010 07:54:57 -0400
Content-Disposition: inline
In-Reply-To: <87eigo1o2q.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 03-06-10 13:07:41, Dmitry Monakhov wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> > When journaled quota options are not specified, we do writes
> > to quota files just in data=ordered mode. This actually causes
> > warnings from JBD2 about dirty journaled buffer because ext4_getblk
> > unconditionally treats a block allocated by it as metadata. Since
> > quota actually is filesystem metadata, the easiest way to get rid
> > of the warning is to always treat quota writes as metadata...
> Absolutely agree with the fix, but I have a theoretical question.
> Is is possible to solve the issue without handling quota's bh
> via ext4_handle_dirty_metadata()?
> As soon as i understand ext4_jbd2_file_inode() not works here
> because bh is belongs to blkdev page-cache. In other words is it
> possible provide ordering for blkdev's blocks in jbd2?
  You are right. It's not possible to provide ordering for blkdev's blocks
in JBD2 (unlike JBD). So a different solution would be rather problematic.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
