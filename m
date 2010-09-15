From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 5/6] Use sb_issue_discard in ext4_ext_zeroout
Date: Wed, 15 Sep 2010 16:19:58 -0400
Message-ID: <AANLkTi=Z2NVgZzNi7=u=YSeOktbz7jATrX3ceC-8H0x6@mail.gmail.com>
References: <1284568568-13637-1-git-send-email-lczerner@redhat.com> <1284568568-13637-6-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, rwheeler@redhat.com,
	sandeen@redhat.com, adilger@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47374 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab0IOUUT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Sep 2010 16:20:19 -0400
Received: by bwz11 with SMTP id 11so900172bwz.19
        for <linux-ext4@vger.kernel.org>; Wed, 15 Sep 2010 13:20:18 -0700 (PDT)
In-Reply-To: <1284568568-13637-6-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 15, 2010 at 12:36 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> Change ext4_ext4_zeroout to use sb_issue_discard instead of its
> own approach to zero out extents.

s/sb_issue_discard/sb_issue_zeroout/ in both the Subject and patch
header (above).

Patch 4/6 header also has a typo: s/sn_issue_discard/sb_issue_zeroout/
