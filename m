From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fs/ext4: add missing ext4_resize_end
Date: Wed, 4 Jan 2012 21:23:46 -0500
Message-ID: <20120105022346.GB24494@thunk.org>
References: <20111222150057.GA10845@dztty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
To: Djalal Harouni <tixxdz@opendz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58191 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757670Ab2AECXs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jan 2012 21:23:48 -0500
Content-Disposition: inline
In-Reply-To: <20111222150057.GA10845@dztty>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 22, 2011 at 04:00:57PM +0100, Djalal Harouni wrote:
> Online resize ioctls 'EXT4_IOC_GROUP_EXTEND' and 'EXT4_IOC_GROUP_ADD'
> call ext4_resize_begin() to check permissions and to set the
> EXT4_RESIZING bit lock, they do their work and they must finish with
> ext4_resize_end() which calls clear_bit_unlock() to unlock and to
> avoid -EBUSY errors for the next resize operations.
> 
> This patch adds the missing ext4_resize_end() calls on error paths.
> 
> Patch tested.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Djalal Harouni <tixxdz@opendz.org>

Applied, thanks.

					- Ted
