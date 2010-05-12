From: tytso@mit.edu
Subject: Re: [PATCH] mke2fs: be explicit if external journal device is not
 found
Date: Wed, 12 May 2010 12:54:58 -0400
Message-ID: <20100512165458.GA826@thunk.org>
References: <4BB4F366.9030404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	"Richard W.M. Jones" <rjones@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44508 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284Ab0ELQzA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 May 2010 12:55:00 -0400
Content-Disposition: inline
In-Reply-To: <4BB4F366.9030404@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 01, 2010 at 02:26:30PM -0500, Eric Sandeen wrote:
> This for RH bug #572935 -
> RFE: Misleading error message from mke2fs -J option

Applied into the e2fsprogs maint branch, thanks.

						- Ted
