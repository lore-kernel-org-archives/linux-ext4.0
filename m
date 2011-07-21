From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Problems building xfsprogs
Date: Thu, 21 Jul 2011 00:19:03 -0400
Message-ID: <20110721041903.GB3304@thunk.org>
References: <20110720175918.GB17971@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39620 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab1GUETH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jul 2011 00:19:07 -0400
Content-Disposition: inline
In-Reply-To: <20110720175918.GB17971@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Another problem with xfsprogs.  "make install" iterates into the
debian subdirectory, for no good reason I can see other than to cause
the build to explode in a million pieces.... 

						- Ted
