From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 35/47] resize2fs: convert fs to and from 64bit mode
Date: Sun, 14 Dec 2014 22:32:12 -0500
Message-ID: <20141215033212.GG17575@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215433.883.51160.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, TR Reardon <thomas_reardon@hotmail.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55932 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbaLODcS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Dec 2014 22:32:18 -0500
Content-Disposition: inline
In-Reply-To: <20141107215433.883.51160.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2014 at 01:54:33PM -0800, Darrick J. Wong wrote:
> +		case 'b':
> +			flags |= RESIZE_ENABLE_64BIT;
> +			break;
> +		case 's':
> +			flags |= RESIZE_DISABLE_64BIT;
> +			break;

Out of curiosity, how did you come up with the options -b and -s?
"big" and "small"?

It's not necessarily the most mnemonic, but I can't come up with
anything better, myself.

						- Ted
