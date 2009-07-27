From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: e2fsck results on a 96TB fs.
Date: Mon, 27 Jul 2009 14:37:57 -0400
Message-ID: <20090727183756.GR27582@shell>
References: <8735.1248711127@gamaville.dokosmarshall.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842AbZG0Sh5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Jul 2009 14:37:57 -0400
Content-Disposition: inline
In-Reply-To: <8735.1248711127@gamaville.dokosmarshall.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 27, 2009 at 12:12:07PM -0400, Nick Dokos wrote:
> This is with 2.6.31-rc4 (and some necessary DM fixes - I got those
> from agk's tree last Friday - they *may* be in mainline
> by now). e2fsprogs was current as of late last week.

Nice!  We still have some bugs, but it's nice to see that 64-bit
e2fsprogs is getting to the point where we are finding bugs in other
pieces of software more often than in e2fsprogs. :)

-VAL
