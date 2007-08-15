From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fix panic in jbd by adding locks
Date: Wed, 15 Aug 2007 13:37:37 +0200
Message-ID: <20070815113737.GC7642@atrey.karlin.mff.cuni.cz>
References: <20070814152255.GB24127@dhcp-243-37.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:60463 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbXHOMD7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Aug 2007 08:03:59 -0400
Content-Disposition: inline
In-Reply-To: <20070814152255.GB24127@dhcp-243-37.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

> It is possible to panic the box by a race condition that exists in the
> journalling code where we do not take the j_revoke_lock when traversing the
> journal's revoked record list.  This patch has been tested and we haven't seen
> the issue yet, its a rather straightforward and correct (at least I think so :)
> fix.  Thank you,
  In principle, the patch looks fine. The only thing I'm wondering about
is how that panic can happen... Journal write_revoke_records() is called
from journal_commit_transaction() when revoke table for the committing
transaction shouldn't see any further changes. So maybe the patch is
masking a different problem.
  Do you have a way of reproducing the problem? Any stack trace
available?

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
