From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/4] Automatic quotaon on remount
Date: Thu, 13 Mar 2008 17:47:23 +0100
Message-ID: <20080313164723.GK12523@duck.suse.cz>
References: <20080313125944.GF12523@duck.suse.cz> <20080313163734.GA3980@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, reiserfs-list@namesys.com,
	Jan Engelhardt <jengelh@computergmbh.de>,
	Michael Tokarev <mjt@tls.msk.ru>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:56995 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756078AbYCMQrY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Mar 2008 12:47:24 -0400
Content-Disposition: inline
In-Reply-To: <20080313163734.GA3980@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 13-03-08 12:37:34, Christoph Hellwig wrote:
> On Thu, Mar 13, 2008 at 01:59:44PM +0100, Jan Kara wrote:
> >   Hi,
> > 
> >   the series of patches below implements automatic enabling of quotas on
> > remount read-write when filesystem with quotas enabled has previously been
> > remounted read-only (and thus quotas had to be disabled).
> >   The patches are split logically, but due to interface changes all four
> > patches need to be applied together or ext3, ext4 or reiserfs won't
> > compile.
> > 
> > [PATCH 1/4] quota: Quota core changes for quotaon on remount
> > [PATCH 2/4] ext3: Make ext3 handle quotaon on remount
> > [PATCH 3/4] ext4: Make ext4 handle quotaon on remount
> > [PATCH 4/4] reiserfs: Make reiserfs handle quotaon on remount
> 
> No need to touch jfs?
  No, since JFS doesn't use quota_on callback and doesn't do journaled
quotas which require calling vfs_quota_on/off during journal replay. But
thanks for the suggestion :).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
