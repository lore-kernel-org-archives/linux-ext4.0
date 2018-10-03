Return-Path: <SRS0=mHRP=MP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50314 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726432AbeJCKB3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 3 Oct 2018 06:01:29 -0400
Date: Tue, 2 Oct 2018 23:15:00 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Eric Whitney <enwlinux@gmail.com>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH v3 0/6] ext4: rework bigalloc reserved cluster accounting
Message-ID: <20181003031500.GA30807@thunk.org>
References: <20180928162316.16480-1-enwlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180928162316.16480-1-enwlinux@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 28, 2018 at 12:23:10PM -0400, Eric Whitney wrote:
> Ext4 can make gross overestimates of the number of reserved clusters
> required to handle bigalloc write requests under delayed allocation,
> resulting in premature ENOSPC and quota limit failures.
> 
> These patches fix the implementation of reserved cluster accounting for
> bigalloc file systems configured to use delayed allocation, and fix the
> specific bugs described in bugzilla #151491.

Thanks, I've applied this patch series to the ext4 git tree.

		     	   	     - Ted
