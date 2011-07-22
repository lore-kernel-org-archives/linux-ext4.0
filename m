From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH XFSPROGS 2/3] Build without enabling DEBUG by default
Date: Fri, 22 Jul 2011 10:17:53 -0400
Message-ID: <20110722141753.GA19681@infradead.org>
References: <1311292237-4155-1-git-send-email-tytso@mit.edu>
 <1311292237-4155-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49707
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754534Ab1GVORz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jul 2011 10:17:55 -0400
Content-Disposition: inline
In-Reply-To: <1311292237-4155-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 21, 2011 at 07:50:36PM -0400, Theodore Ts'o wrote:
> The tree currently will blow out with a build failure if -DDEBUG is
> specified.

This still doesn't make sense to me.  libxfs explicily overrides
DEBUG in the makefile:

# don't try linking xfs_repair with a debug libxfs.
DEBUG = -DNDEBUG

we really need to figure out why your enviroment doesn't pick this
up, especially as we've never seen that report from anybody else.

