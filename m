From: Theodore Tso <tytso@mit.edu>
Subject: Re: general protection fault:  from release_blocks_on_commit
Date: Mon, 27 Oct 2008 14:19:28 -0400
Message-ID: <20081027181928.GB23111@mit.edu>
References: <1224612181.19719.20.camel@paris-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	sandeen@redhat.com
To: Eric Paris <eparis@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:34548 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751058AbYJ0STa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2008 14:19:30 -0400
Content-Disposition: inline
In-Reply-To: <1224612181.19719.20.camel@paris-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 21, 2008 at 02:03:01PM -0400, Eric Paris wrote:
> I can consistently get the below backtrace any time I try to shutdown my
> machine.  This machine has ext4 as it's root FS.  This is 100%
> reproducible.  I backed out commit
> 3e624fc72fba09b6f999a9fbb87b64efccd38036 and it fixed the problem.
> 
> This is a regression.

Can you send me your .config, please?  I'm trying to duplicate it on
my end.  

						- Ted
