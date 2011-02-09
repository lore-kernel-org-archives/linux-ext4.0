From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [ext4] Multiple page-io submission (Option "mblk_io_submit")
Date: Wed, 9 Feb 2011 13:38:16 -0500
Message-ID: <20110209183816.GD9533@thunk.org>
References: <AANLkTinXsDN4Bhp9_kcbeu6BNMADTSBVN_6+nn63w+kW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Curt Wohlgemuth <curtw@google.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: sedat.dilek@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34592 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646Ab1BISiU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Feb 2011 13:38:20 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTinXsDN4Bhp9_kcbeu6BNMADTSBVN_6+nn63w+kW@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 08, 2011 at 06:30:29PM +0100, Sedat Dilek wrote:
> Hi,
> 
> while looking at pending patches in ext4.git#{master, for_linus}, I
> saw "ext4: Fix data corruption with multi-block writepages support"
> which should fix [2] according to text in the commit-body.
> 
> Are you planning to turn on "multiple page-io submission" again by
> default (as is was disabled in "ext4: Turn off multiple page-io
> submission by default" [3])?

I'm planning on turning it on by default post 2.6.38, during the
2.6.39-rc1 merge window.  That's me being paranoid, since this is so
late in the -rc cycle for 2.6.38.

						- Ted
