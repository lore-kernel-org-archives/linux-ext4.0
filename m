Return-Path: <SRS0=ORgn=PU=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34669 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbfALHkF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Jan 2019 02:40:05 -0500
Received: by mail-pg1-f196.google.com with SMTP id j10so7298179pga.1
        for <linux-ext4@vger.kernel.org>; Fri, 11 Jan 2019 23:40:04 -0800 (PST)
Date: Sat, 12 Jan 2019 15:39:57 +0800
From: Eryu Guan <guaneryu@gmail.com>
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, jack@suse.cz, miaoxie@huawei.com
Subject: Re: [PATCH] jbd2: set freed flag while revoking a buffer which
 belongs to older transaction
Message-ID: <20190112073957.GE2713@desktop>
References: <1547100722-132243-1-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547100722-132243-1-git-send-email-yi.zhang@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 10, 2019 at 02:12:02PM +0800, zhangyi (F) wrote:
> Now, we capture a data corruption problem on ext4 while we're truncating
> an extent index block. Imaging that if we are revoking a buffer which
> has been journaled by the committing transaction, the buffer's jbddirty
> flag will not be cleared in jbd2_journal_forget(), so the commit code
> will set the buffer dirty flag again after refile the buffer.
> 
> fsx                               kjournald2
>                                   jbd2_journal_commit_transaction
> jbd2_journal_revoke                commit phase 1~5...
>  jbd2_journal_forget
>    belongs to older transaction    commit phase 6
>    jbddirty not clear               __jbd2_journal_refile_buffer
>                                      __jbd2_journal_unfile_buffer
>                                       test_clear_buffer_jbddirty
>                                        mark_buffer_dirty
> 
> Finally, if the freed extent index block was allocated again as data
> block by some other files, it may corrupt the file data when writing
> cached pages later, such as during umount time.
> 
> This patch mark buffer as freed when it already belongs to the
> committing transaction in jbd2_journal_forget(), so that commit code
> knows it should clear dirty bits when it is done with the buffer.
> 
> This problem can be reproduced by xfstests generic/455 easily with
> seeds (3246 3247 3248 3249).

Would you please capture the fsx ops sequences that could reproduce the
problem and replay it in a targeted regression test, like what
generic/{499,511} do? Thanks!

Eryu
