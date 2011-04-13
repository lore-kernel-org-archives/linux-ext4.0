From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC] exclude_bitmap and uninit_bg features
Date: Wed, 13 Apr 2011 21:03:46 +0200
Message-ID: <BANLkTimmRQtOiH2iunJczQOhxkB4uoCJ2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35627 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757056Ab1DMTDr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Apr 2011 15:03:47 -0400
Received: by qyg14 with SMTP id 14so598945qyg.19
        for <linux-ext4@vger.kernel.org>; Wed, 13 Apr 2011 12:03:46 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

I have been exploring the possibility to make exclude bitmap a compat feature
and I think I have come to a dead end with ext4_init_block_bitmap().

On old kernels, this function will disregard the exclude bitmap block and leave
it free in the block bitmap.

So that leaves us with the less attractive option to make it rocompat,
which leads to the following dilemma:
Once exclude bitmap is allocated by new mkfs or added by new tune2fs,
the fs can no longer be mounted by an older kernel.
How can we solve that problem?

We could use 2 features:
EXT4_FEATURE_COMPAT_EXCLUDE_BITMAP /* exclude bitmap is allocated */
EXT4_FEATURE_RO_COMPAT_UNINIT_EXCLUDE /* uninit_bg and exclude_bitmap are set */

New mkfs can allocate exclude bitmaps for uninit groups and set the 2
features by default.
tune2fs -O ^uninit_exclude can init all groups and remove the rocompat feature,
making the fs available for old kernels, while keeping the exclude
bitmap intact.

Does that make sense to you?

Amir.
