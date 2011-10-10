From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3] ext4: fix possible overflow in ext4_trim_fs()
Date: Mon, 10 Oct 2011 12:47:11 -0400
Message-ID: <20111010164711.GW7948@thunk.org>
References: <1315410777-24237-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tm@tao.ma
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41955 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759Ab1JJQrN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Oct 2011 12:47:13 -0400
Content-Disposition: inline
In-Reply-To: <1315410777-24237-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 07, 2011 at 05:52:57PM +0200, Lukas Czerner wrote:
> The overflow can happen when we are calling get_group_no_and_offset()
> which stores the result of do_div() in 32 bit long type. However the
> result might be bigger than that if big blocknr is passed in. This will
> most likely happen when calling FITRIM with the default argument len =
> ULLONG_MAX.
> 
> Fix this by using "end" variable instead of "start+len" as it is easier
> to get right and specifically check that the end is not beyond the end
> of the file system, so we are sure that the result of
> get_group_no_and_offset() will not overflow. Otherwise truncate it to
> the size of the file system.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Hi Lukas,

Since I've merged the bigalloc patches that uses clusters instead of
blocks for various file system parameters.  I made a quick attempt to
port your patch, and it wasn't obvious (and I don't have your testing
framework).  Could you do me a favor and forward port your patch to
either the dev or master branch on the ext4 github repository?

Thanks!!

					- Ted
