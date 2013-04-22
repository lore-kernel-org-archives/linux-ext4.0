From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Weird resize2fs failures when mounting ext3 as ext4
Date: Sun, 21 Apr 2013 21:47:56 -0400
Message-ID: <20130422014756.GA4830@thunk.org>
References: <51229FF7.7090003@redhat.com>
 <20130421233057.GA5625@thunk.org>
 <51749486.20606@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43331 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319Ab3DVBsA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Apr 2013 21:48:00 -0400
Content-Disposition: inline
In-Reply-To: <51749486.20606@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 21, 2013 at 08:38:14PM -0500, Eric Sandeen wrote:
> > Also, here's a simplified repro that doesn't require LVM.  The bug was
> > introduced in commit fb0a387dcdc, so it goes back to 2.6.32.
> 
> Argh.  Karma!  Sorry about that, and thanks for taking a look.

No problem!  Could you do me a favor and package up the repro as a
generic test case for xfstests?  I figure this would be a good thing
to delegate to you, since you have a lot more experience creating
tests for xfstests.

						- Ted
