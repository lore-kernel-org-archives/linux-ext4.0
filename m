From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: e2fsck -D segfaults in pass 3A
Date: Thu, 13 Mar 2008 22:24:19 +0100 (CET)
Message-ID: <alpine.DEB.1.00.0803132223130.7433@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803132116430.7433@sheep.housecafe.de> <20080313204949.GC28728@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns2.g-housing.de ([81.169.133.75]:33622 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbYCMVYW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Mar 2008 17:24:22 -0400
In-Reply-To: <20080313204949.GC28728@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 13 Mar 2008, Theodore Tso wrote:
> Yeah, thanks for pointing that out.  Pass3A doesn't deal with
> directories stored in extent format yet, and you must have one or more
> directories directories in extent format.   So e2fsck -D won't work.

Ah, good to know :)

Thanks for your time,
Christian.
-- 
BOFH excuse #265:

The mouse escaped.
