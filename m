From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2 V2] ext4: remove the resize mount option
Date: Mon, 13 Feb 2012 17:44:09 -0500
Message-ID: <20120213224409.GB24098@thunk.org>
References: <4EB17085.9060107@redhat.com>
 <4EB1717B.1000202@redhat.com>
 <4EB171AA.2040006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37508 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab2BMWoL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Feb 2012 17:44:11 -0500
Content-Disposition: inline
In-Reply-To: <4EB171AA.2040006@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 02, 2011 at 11:36:58AM -0500, Eric Sandeen wrote:
> The resize mount option seems to be of limited value,
> especially in the age of online resize2fs.  Nuke it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
