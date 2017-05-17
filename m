From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 0/2 v2] ext4: Fix SEEK_HOLE implementation
Date: Wed, 17 May 2017 20:40:55 +0800
Message-ID: <20170517124055.GI1946@eguan.usersys.redhat.com>
References: <20170517120739.2529-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36779 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751789AbdEQMk7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 17 May 2017 08:40:59 -0400
Received: by mail-pf0-f195.google.com with SMTP id n23so1622010pfb.3
        for <linux-ext4@vger.kernel.org>; Wed, 17 May 2017 05:40:58 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170517120739.2529-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

On Wed, May 17, 2017 at 02:07:37PM +0200, Jan Kara wrote:
> Hello,
> 
> here is second revision of the patch set to fix ext4 SEEK_HOLE implementation.
> For more details see changelog of the first patch.
> 
> Changes since v1:
> * Fix some more buggy cases
> * Fix range check
> * Simplify the code

This patchset fails generic/285 on sub-page block size ext4 too, again
failres were from subtest 7 and 8, as where xfs failed.

Thanks,
Eryu
