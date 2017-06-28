From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH 07/12] e2fsck: track ea_inode references
Date: Tue, 27 Jun 2017 18:26:31 -0700
Message-ID: <CAAeU0aMecOPcr38t4XB2oqbnxRaTzDW_pnCyGgEqpOy7NyQOXg@mail.gmail.com>
References: <20170626134348.1240-1-tahsin@google.com> <20170626134348.1240-7-tahsin@google.com>
 <2822BB00-1A19-4DE4-8532-63FC307E5D7B@dilger.ca> <CAAeU0aMBM0DASLL_WjpNS=hvx9n4ntEJEKs_X=a948oJiHV26w@mail.gmail.com>
 <DD3F340E-4D88-497D-9DCC-3A4C93F03E5B@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:35357 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752010AbdF1B0d (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jun 2017 21:26:33 -0400
Received: by mail-yw0-f172.google.com with SMTP id j11so18832482ywa.2
        for <linux-ext4@vger.kernel.org>; Tue, 27 Jun 2017 18:26:33 -0700 (PDT)
In-Reply-To: <DD3F340E-4D88-497D-9DCC-3A4C93F03E5B@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Sorry, I can't answer that.  Git history shows that it has been around since
> 2000 but is not set by the configure script.  I just thought it made sense to
> clean up the code, but it might be even better to get rid of it completely.

Sounds good. Sent it out as a separate patch ("[PATCH] e2fsck: remove
#ifdef EXT2_NO_64_TYPE blocks").
