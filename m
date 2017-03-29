From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: Creating a mailing list, git tree, and patchwork project for
 fscrypt
Date: Wed, 29 Mar 2017 14:14:12 -0700
Message-ID: <20170329211412.GB29310@gmail.com>
References: <20161216203732.g65wjf2wgc6rsijy@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, jaegeuk@kernel.org,
        ebiggers@google.com, mhalcrow@google.com, richard@nod.at,
        linux-ext4@vger.kernel.org, linux-f2fs@vger.kernel.org,
        linux-fscrypt@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35690 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932966AbdC2VOQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Mar 2017 17:14:16 -0400
Content-Disposition: inline
In-Reply-To: <20161216203732.g65wjf2wgc6rsijy@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 16, 2016 at 03:37:32PM -0500, Theodore Ts'o wrote:
> I'm thinking about creating a separate mailing list (linux-fscrypt),
> git tree and patchwork project, just to make it easier to track the
> patches which are coming in.
> 
> Does anyone have any objections with that plan?
> 
> Cheers,
> 

This seems to have done for a while now:
	
    * http://vger.kernel.org/vger-lists.html#linux-fscrypt
    * https://git.kernel.org/pub/scm/linux/kernel/git/tytso/fscrypt.git/
    * https://patchwork.kernel.org/project/linux-fscrypt/list/

Were you planning to also update the MAINTAINERS file to refer to the new list?

- Eric
