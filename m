From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: check for zero length extent
Date: Sun, 11 Mar 2012 23:30:55 -0400
Message-ID: <20120312033055.GA24255@thunk.org>
References: <1331498791-2455-1-git-send-email-tytso@mit.edu>
 <84C5A1E3-0ACA-465E-9768-FEAC7BC5044A@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"merll@web.de" <merll@web.de>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58069 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174Ab2CLDa7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Mar 2012 23:30:59 -0400
Content-Disposition: inline
In-Reply-To: <84C5A1E3-0ACA-465E-9768-FEAC7BC5044A@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 11, 2012 at 08:00:58PM -0600, Andreas Dilger wrote:
> On 2012-03-11, at 14:46, Theodore Ts'o <tytso@mit.edu> wrote:
> > Explicitly test for an extent whose length is zero, and flag that as a
> > corrupted extent.
> 
> Two minor nits in the patch...

Thanks, I've made your suggested fixes.

					- Ted
