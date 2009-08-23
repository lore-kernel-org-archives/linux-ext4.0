From: Theodore Tso <tytso@mit.edu>
Subject: Re: Compile error in pu branch of e2fsprogs.
Date: Sun, 23 Aug 2009 10:48:59 -0400
Message-ID: <20090823144859.GE23677@mit.edu>
References: <8693.1250784298@alphaville.usa.hp.com> <4A8D763E.8040603@redhat.com> <9226.1250785933@alphaville.usa.hp.com> <4A8D7CA5.5010208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: nicholas.dokos@hp.com, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56457 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933589AbZHWOtG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Aug 2009 10:49:06 -0400
Content-Disposition: inline
In-Reply-To: <4A8D7CA5.5010208@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've fixed this in the latest rebase of the pu branch, which has the
latest 'maint' branch fixes merged in.  I've also finished cleaning up
and merged the bitmap changes into the 'next' branch, which is a
sizeable chunk of the 64-bit changes:

 43 files changed, 1683 insertions(+), 352 deletions(-)

What's left to be cleaned up and merged:

 96 files changed, 1940 insertions(+), 1402 deletions(-)

						- Ted
