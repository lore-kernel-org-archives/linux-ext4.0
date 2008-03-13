From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/4] Automatic quotaon on remount
Date: Thu, 13 Mar 2008 12:37:34 -0400
Message-ID: <20080313163734.GA3980@infradead.org>
References: <20080313125944.GF12523@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, reiserfs-list@namesys.com,
	Jan Engelhardt <jengelh@computergmbh.de>,
	Michael Tokarev <mjt@tls.msk.ru>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34119 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbYCMQiN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Mar 2008 12:38:13 -0400
Content-Disposition: inline
In-Reply-To: <20080313125944.GF12523@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 13, 2008 at 01:59:44PM +0100, Jan Kara wrote:
>   Hi,
> 
>   the series of patches below implements automatic enabling of quotas on
> remount read-write when filesystem with quotas enabled has previously been
> remounted read-only (and thus quotas had to be disabled).
>   The patches are split logically, but due to interface changes all four
> patches need to be applied together or ext3, ext4 or reiserfs won't
> compile.
> 
> [PATCH 1/4] quota: Quota core changes for quotaon on remount
> [PATCH 2/4] ext3: Make ext3 handle quotaon on remount
> [PATCH 3/4] ext4: Make ext4 handle quotaon on remount
> [PATCH 4/4] reiserfs: Make reiserfs handle quotaon on remount

No need to touch jfs?

