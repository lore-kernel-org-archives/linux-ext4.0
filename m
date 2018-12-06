Return-Path: <SRS0=bC55=OP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:30472 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726047AbeLFWuM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Dec 2018 17:50:12 -0500
Date: Fri, 7 Dec 2018 09:50:08 +1100
From: Dave Chinner <david@fromorbit.com>
To: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: tytso@mit.edu, kernel@collabora.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v4 00/23] Ext4 Encoding and Case-insensitive support
Message-ID: <20181206225008.GB19305@dastard>
References: <20181206220429.10722-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181206220429.10722-1-krisman@collabora.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 06, 2018 at 05:04:06PM -0500, Gabriel Krisman Bertazi wrote:
> Hi,
> 
> Following the e2fsprogs changes, these are the corresponding kernel-side
> modifications to support the fname_encoding feature.
> 
> The patches are split in two parts. The fist 14 patches are refactoring
> and improvements to the NLS code, including the utf8 normalization
> support.  The final patches implement the fname_encoding feature in ext4.

Please repost this all to linux-fsdevel@vger.kernel.org. You're
changing a significant amount of non-ext4 filesystem code, as well
as adding core filesystem infrastructure so it needs to have wider
visibility and review than just the ext4 list.

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
