From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs - handle large setb/testb/freeb commands in debugfs
Date: Tue, 10 Apr 2007 15:40:29 -0400
Message-ID: <20070410194029.GC16821@thunk.org>
References: <461BDAD5.5060900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48978 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804AbXDJTkc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Apr 2007 15:40:32 -0400
Content-Disposition: inline
In-Reply-To: <461BDAD5.5060900@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Apr 10, 2007 at 01:43:33PM -0500, Eric Sandeen wrote:
> I noticed that you can't give more than a 2^31 block count to the
> debugfs commands setb, clearb, or freeb.  Looks ok?

Yup, thanks.  Committed into the repository.

						- Ted
