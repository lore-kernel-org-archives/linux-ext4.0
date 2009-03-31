From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Add sysfs support
Date: Tue, 31 Mar 2009 09:11:47 -0400
Message-ID: <20090331131147.GH13356@mit.edu>
References: <1235879288-26201-1-git-send-email-tytso@mit.edu> <20090330101034.GB4796@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56913 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488AbZCaNLv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Mar 2009 09:11:51 -0400
Content-Disposition: inline
In-Reply-To: <20090330101034.GB4796@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 30, 2009 at 03:40:34PM +0530, Aneesh Kumar K.V wrote:
> On Sat, Feb 28, 2009 at 10:48:07PM -0500, Theodore Ts'o wrote:
> > Add basic sysfs support so that information about the mounted
> > filesystem and various tuning parameters can be accessed via
> > /sys/fs/ext4/<dev>/*.
> > 
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> > ---
> >  fs/ext4/ext4_sb.h |    2 +
> >  fs/ext4/super.c   |  198 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 200 insertions(+), 0 deletions(-)
> > 
> 
> This needs documentation in Documentation/ABI/testing.

Good point, added, thanks.

					- Ted
