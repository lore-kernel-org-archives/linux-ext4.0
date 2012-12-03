From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V7 22/23] ext4: let fallocate handle inline data
 correctly.
Date: Sun, 2 Dec 2012 20:37:59 -0500
Message-ID: <20121203013759.GA4545@thunk.org>
References: <1351047002-4723-1-git-send-email-tm@tao.ma>
 <1351047338-4963-1-git-send-email-tm@tao.ma>
 <1351047338-4963-22-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36408 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648Ab2LCDdT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 2 Dec 2012 22:33:19 -0500
Content-Disposition: inline
In-Reply-To: <1351047338-4963-22-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 24, 2012 at 10:55:37AM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> If we are punching hole in a file, we will return ENOTSUPP.

We don't need to fix this right away (I'll apply the patch w/o dealing
with this), but probably the right thing to do is to deal with
punching a hole in an inline data file by setting the region of the
file to zero --- after all, that's how we handle punching
non-page-aligned regions for extent based files, so we might as well
support inline data files the same way, especially since that should
be a relatively easy change.

						- Ted
