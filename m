From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/4 v3] e2fsprogs journal fixes (UUID and 1k block size
 issue)
Date: Tue, 29 Jul 2014 07:36:00 -0400
Message-ID: <20140729113600.GB14680@thunk.org>
References: <1406533405-6899-1-git-send-email-a3at.mail@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, darrick.wong@oracle.com,
	adilger@dilger.ca
To: Azat Khuzhin <a3at.mail@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34113 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285AbaG2LgE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jul 2014 07:36:04 -0400
Content-Disposition: inline
In-Reply-To: <1406533405-6899-1-git-send-email-a3at.mail@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 28, 2014 at 11:43:21AM +0400, Azat Khuzhin wrote:
> 
> Azat Khuzhin (4):
>   journal: use consts instead of 1024 and add helper for journal with 1k
>     blocksize
>   tune2fs: remove_journal_device(): use the correct block to find jsb
>   tune2fs: update journal super block when changing UUID for fs.
>   tune2fs: update journal users while updating fs UUID (with external
>     journal)

Thanks for working on this!  I've applied these patches to the maint branch.

       	   	      	     	  - Ted
