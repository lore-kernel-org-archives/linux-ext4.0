From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: fix NULL pointer dereference from orig_data
 in fill_super and remount.
Date: Mon, 7 Nov 2011 10:19:39 -0500
Message-ID: <20111107151939.GA24234@thunk.org>
References: <1320674511-1980-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Namjae Jeon <linkinjeon@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38290 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab1KGPTn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Nov 2011 10:19:43 -0500
Content-Disposition: inline
In-Reply-To: <1320674511-1980-1-git-send-email-linkinjeon@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 07, 2011 at 11:01:51PM +0900, Namjae Jeon wrote:
> Fix NULL pointer dereference from orig_data in fill_super and remount.
> 
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>

Um, did you even try to test this patch before submitting it?

#1:   kstrdup() return NULL if data is NULL

#2:  The kernel's printk and sprintf functions will translate
     sprintf(buf, "%s", NULL) by filling in the string "NULL"

#3:  The only use of orig_data is a cosmetic one, of printing out
     the mount options which are passed in.

#4:  If the user doesn't specify any mount options, data is NULL, and
     your patch would cause those mounts to fail with ENOMEM.

In summary, there is no problem here; a pendant might complain that
it's possible for data to be non-NULL, and for orig_data to be null of
the kstrdup failed, but in that case, other memory allocations done
later in ext4_fill_super() will almost have certainly failed, so in
practice won't get as far as the printk.

					- Ted
