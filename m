From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC PATCH 10/17] signed int -> blk64_t to fix bugs at 2^31 -
	2^32 blocks
Date: Fri, 14 Nov 2008 09:24:33 -0500
Message-ID: <20081114142433.GD25117@mit.edu>
References: <1226461390-5502-4-git-send-email-vaurora@redhat.com> <1226461390-5502-5-git-send-email-vaurora@redhat.com> <1226461390-5502-6-git-send-email-vaurora@redhat.com> <1226461390-5502-7-git-send-email-vaurora@redhat.com> <1226461390-5502-8-git-send-email-vaurora@redhat.com> <1226461390-5502-9-git-send-email-vaurora@redhat.com> <1226461390-5502-10-git-send-email-vaurora@redhat.com> <1226461390-5502-11-git-send-email-vaurora@redhat.com> <20081113195742.GV16005@webber.adilger.int> <20081114023812.GD20637@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Valerie Aurora Henson <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:45284 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751159AbYKNOYi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Nov 2008 09:24:38 -0500
Content-Disposition: inline
In-Reply-To: <20081114023812.GD20637@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 13, 2008 at 09:38:12PM -0500, Valerie Aurora Henson wrote:
> 
> Agreed.  Ted, is this a good format for you or do you want me to
> regenerate against something?
> 

No, this is fine.  I'll take the patch and merge it into maint.

Note, what I'm going to try to do is to take entire patches of yours
at once, although in some cases they will be applied to different
branches (or split into different patches).

The goal will be to not disturb things too badly if you do any further
work on the patch series, since git-rebase should be smart enough.
However, it might be a good idea for you to set a tag on what you've
pushed so far, and to save everything past that point as diffs in case
git rebase doesn't work out for whatever reason.

Hopefully while I'm in Japan and/or over Thanksgiving weekend I'll
have enough time to merge all of these patches into mainline.  (I'll
probably miss next week's conference call as well since I'll be in
Tokyo, BTW.  If someone can take notes during the call, or at least
for anything that needs my attention, I'd appreciate it.)

						- Ted
