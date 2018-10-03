Return-Path: <SRS0=mHRP=MP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49568 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726407AbeJCIk7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 3 Oct 2018 04:40:59 -0400
Date: Tue, 2 Oct 2018 21:54:43 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH] e2fsprogs: avoid segfault when s_nr_users is too high
Message-ID: <20181003015443.GA22436@thunk.org>
References: <20180814143753.8937-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180814143753.8937-1-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 14, 2018 at 04:37:53PM +0200, Lukas Czerner wrote:
> Currently in e2fsprogs tools it's possible to access out of bounds
> memory when reading list of ids sharing a journal log
> (journal_superblock_t->s_users[]) in case where s_nr_users is too high.
> 
> This is because we never check whether the s_nr_users fits into the
> restriction of JFS_USERS_MAX. Fix it by checking that nr_users is not
> bigger than JFS_USERS_MAX and error out when possiblem.
> 
> Also add test for dumpe2fs. The rest would require involving external
> journal which is not possible to test with e2fsprogs test suite at the
> moment.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

					- Ted
