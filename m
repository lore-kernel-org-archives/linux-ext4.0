From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH XFSPROGS 3/3] mkfs: Link against libuuid after liblkid
Date: Fri, 22 Jul 2011 10:29:05 -0400
Message-ID: <20110722142905.GC19681@infradead.org>
References: <1311292237-4155-1-git-send-email-tytso@mit.edu>
 <1311292237-4155-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40898
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754427Ab1GVO3G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jul 2011 10:29:06 -0400
Content-Disposition: inline
In-Reply-To: <1311292237-4155-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 21, 2011 at 07:50:37PM -0400, Theodore Ts'o wrote:
> The order in which libraries are searched matters if you are using
> static libraries.  Since libblkid uses some functions from libuuid, it
> needs to come before libuuid in the link line.

Thanks, applied.

