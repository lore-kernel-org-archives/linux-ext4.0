From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Problems building xfsprogs
Date: Thu, 21 Jul 2011 00:27:29 -0400
Message-ID: <20110721042729.GC3304@thunk.org>
References: <20110720175918.GB17971@thunk.org>
 <20110721041903.GB3304@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57314 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888Ab1GUE1b (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jul 2011 00:27:31 -0400
Content-Disposition: inline
In-Reply-To: <20110721041903.GB3304@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 21, 2011 at 12:19:03AM -0400, Ted Ts'o wrote:
> Another problem with xfsprogs.  "make install" iterates into the
> debian subdirectory, for no good reason I can see other than to cause
> the build to explode in a million pieces.... 

Sorry, never mind, false alarm.

						- Ted
