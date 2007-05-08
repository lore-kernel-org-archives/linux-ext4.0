From: Daniel Drake <ddrake@brontes3d.com>
Subject: Re: [PATCH e2fsprogs] Restore backup superblocks in preen mode
Date: Tue, 08 May 2007 14:52:20 -0400
Message-ID: <1178650340.923.26.camel@systems03.mmm.com>
References: <20070508174324.40EBE7B409F@zog.reactivated.net>
	 <20070508181459.GA31101@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp116.iad.emailsrvr.com ([207.97.245.116]:50069 "EHLO
	smtp116.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031545AbXEHTaP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 May 2007 15:30:15 -0400
In-Reply-To: <20070508181459.GA31101@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-05-08 at 14:14 -0400, Theodore Tso wrote:
> We could argue about whether or not e2fsck should explicitly ask for
> permission before using a backup superblock, and possibly printing the
> label and validating the size, etc., before using it

In that case, I think it should. At least, that would kill the confusion
where preen mode apparently doesn't want to automate a potentially
dangerous operation, whereas the standard mode works extremely hard to
complete the operation with no user intervention (and doesn't even
require as much info from the user!).

Thanks.
-- 
Daniel Drake
Brontes Technologies, A 3M Company
