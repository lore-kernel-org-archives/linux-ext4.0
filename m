From: Ted Ts'o <tytso@mit.edu>
Subject: Re: sparsify - utility to punch out blocks of 0s in a file
Date: Mon, 6 Feb 2012 16:41:32 -0500
Message-ID: <20120206214132.GA22019@thunk.org>
References: <4F2D8F30.3090802@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39786 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596Ab2BFVlo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Feb 2012 16:41:44 -0500
Content-Disposition: inline
In-Reply-To: <4F2D8F30.3090802@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Cool!  I assume you're going to try to get this into util-linux-ng?

I'm tempted to drop it in e2fsprogs's contrib directxory for now, but
I think the best home for it is util-linux-ng.

							- Ted
