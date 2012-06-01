From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: Add ext4_mb_unload_buddy in the error path
Date: Fri, 1 Jun 2012 00:09:22 -0400
Message-ID: <20120601040922.GD7897@thunk.org>
References: <20120529233422.12259.959.stgit@dungbeetle.mtv.corp.google.com>
 <20120529233609.12259.48732.stgit@dungbeetle.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@google.com>, linux-ext4@vger.kernel.org
To: Salman Qazi <sqazi@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46888 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab2FAEJZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Jun 2012 00:09:25 -0400
Content-Disposition: inline
In-Reply-To: <20120529233609.12259.48732.stgit@dungbeetle.mtv.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 29, 2012 at 04:36:09PM -0700, Salman Qazi wrote:
> ext4_free_blocks fails to pair an ext4_mb_load_buddy with a matching
> ext4_mb_unload_buddy when it fails a memory allocation.
> 
> Signed-off-by: Salman Qazi <sqazi@google.com>

Applied, thanks.

					- Ted
