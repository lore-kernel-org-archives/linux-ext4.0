From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: fix flag settings in e2image.h
Date: Sun, 21 Apr 2013 23:49:21 -0400
Message-ID: <20130422034921.GA9950@thunk.org>
References: <1361448418-26688-1-git-send-email-tracek@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tomas Racek <tracek@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43361 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580Ab3DVDt0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Apr 2013 23:49:26 -0400
Content-Disposition: inline
In-Reply-To: <1361448418-26688-1-git-send-email-tracek@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 21, 2013 at 01:06:58PM +0100, Tomas Racek wrote:
> This prevents from SIGSEGV when -s options is used.
> 
> Signed-off-by: Tomas Racek <tracek@redhat.com>

Applied, thanks.

					- Ted
