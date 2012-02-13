From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: remove a the journal=update mount option
Date: Mon, 13 Feb 2012 17:41:23 -0500
Message-ID: <20120213224123.GA24098@thunk.org>
References: <4EB17085.9060107@redhat.com>
 <4EB170E0.7090701@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43386 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277Ab2BMWlZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Feb 2012 17:41:25 -0500
Content-Disposition: inline
In-Reply-To: <4EB170E0.7090701@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 02, 2011 at 11:33:36AM -0500, Eric Sandeen wrote:
> The V2 journal format was introduced around ten years ago,
> for ext3. It seems highly unlikely that anyone will need this
> migration option for ext4.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
