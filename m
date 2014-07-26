From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: Re: [PATCH 0/5] e2fsprogs: some small cleanups and fixes for journal
 code
Date: Sat, 26 Jul 2014 11:33:29 +0400
Message-ID: <20140726073329.GB24045@azat>
References: <1405002908-16332-1-git-send-email-a3at.mail@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: darrick.wong@oracle.com, adilger@dilger.ca, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:53445 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaGZHdd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Jul 2014 03:33:33 -0400
Received: by mail-lb0-f181.google.com with SMTP id 10so4001527lbg.40
        for <linux-ext4@vger.kernel.org>; Sat, 26 Jul 2014 00:33:31 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1405002908-16332-1-git-send-email-a3at.mail@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 10, 2014 at 06:35:03PM +0400, Azat Khuzhin wrote:
> [PATCH 1/5] lib: add EXT2_ prefix for SUPERBLOCK_{OFFSET,SIZE}
> [PATCH 2/5] journal: use consts instead of 1024 and add helper for
> [PATCH 3/5] tune2fs: remove_journal_device(): use the correct block
> [PATCH 4/5] tune2fs: update journal super block when changing UUID
> [PATCH 5/5] tune2fs: update journal users while updating fs UUID

Hi Ted, any news on this?

Cheers,
Azat.
