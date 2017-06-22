From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: First stab at ea inode disk format doc updates
Date: Thu, 22 Jun 2017 11:52:41 -0700
Message-ID: <CAAeU0aMoK2Vp=-JgZwb+J8hZkTD_YxA+ZTsW31FoGrL5O1RmiQ@mail.gmail.com>
References: <20170622181856.GD4728@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:34810 "EHLO
        mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751193AbdFVSwn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Jun 2017 14:52:43 -0400
Received: by mail-yw0-f175.google.com with SMTP id e142so9440117ywa.1
        for <linux-ext4@vger.kernel.org>; Thu, 22 Jun 2017 11:52:42 -0700 (PDT)
In-Reply-To: <20170622181856.GD4728@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hi Darrick,

> Also -- what is the value of i_mtime (ea inode parent pointer) when the
> refcount > 1?

In the current implementation, xattr inode format is assumed to be in
the new format (refcount in i_ctime and l_i_version, hash in i_atime).
parent xattr e_hash field incorporates xattr inode hash to achieve
strong binding. If hash validation fails, we fallback to old binding
validation (xattr inode i_mtime == parent ino && xattr inode
i_generation == parent i_generation). The idea is to allow migration
from old lustre disks. So, if refcount is valid then value in i_mtime
is not defined.
