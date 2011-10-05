From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: Fix up usage & error text for cluster size
 specification
Date: Wed, 5 Oct 2011 02:01:25 -0400
Message-ID: <20111005060125.GB4297@thunk.org>
References: <4E8B84BB.6040004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56504 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932975Ab1JEGCO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Oct 2011 02:02:14 -0400
Content-Disposition: inline
In-Reply-To: <4E8B84BB.6040004@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 04, 2011 at 05:12:11PM -0500, Eric Sandeen wrote:
> Commit c6ed60cd removed "f" (fragment size) from the getopt string,
> and re-used its spot in the getopt switch, but didn't update the
> usage message or the error message during parsing.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

						- Ted
