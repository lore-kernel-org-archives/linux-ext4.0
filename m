From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] do you want jbd2 interface of ext3?
Date: Mon, 22 Feb 2010 19:02:47 +0100
Message-ID: <20100222180246.GA3112@quack.suse.cz>
References: <20100216164123.b10b00e5.toshi.okajima@jp.fujitsu.com>
 <20100216185452.GE3153@quack.suse.cz>
 <4B7BAA70.9070605@jp.fujitsu.com>
 <20100217164933.GC5337@thunk.org>
 <4B8219B8.8070207@jp.fujitsu.com>
 <9B774728-3508-4850-B036-CB0013403DE9@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: toshi.okajima@jp.fujitsu.com, Jan Kara <jack@suse.cz>,
	akpm@linux-foundation.org, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47061 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889Ab0BVSCj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Feb 2010 13:02:39 -0500
Content-Disposition: inline
In-Reply-To: <9B774728-3508-4850-B036-CB0013403DE9@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 22-02-10 08:55:53, Theodore Tso wrote:
> As for quota --- quite seriously --- if you have mission critical users,
> I'd suggest that they not use quota.  Dimitry has been turning up all
> sorts of bugs in the quota subsystem, many of which are just as
> applicable to ext3.  The real issue is that quota hasn't received as much
> testing as other file system features --- in any file system, not just
> ext4.
  I don't agree with this. I know about quite a few large customers
depending on quotas on their servers and they run on ext3 / reiserfs quite
happily. Dmitry's patches touching the generic code were mostly cleanups,
the fixes were just in the delayed allocation handling but that never
gets executed for ext3 or reiserfs...
  I don't say there cannot be bugs and certainly quota code has less
exposure than other more used filesystem parts. But I don't know about
any serious quota issue on ext3 / reiserfs in last two years or so
(except the one that was caused by Dmitry's fixes ;).

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
