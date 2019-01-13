Return-Path: <SRS0=NEJw=PV=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42791 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbfAMPM2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Jan 2019 10:12:28 -0500
Received: by mail-pf1-f195.google.com with SMTP id 64so9163340pfr.9
        for <linux-ext4@vger.kernel.org>; Sun, 13 Jan 2019 07:12:27 -0800 (PST)
Date: Sun, 13 Jan 2019 23:12:19 +0800
From: Eryu Guan <guaneryu@gmail.com>
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, jack@suse.cz, miaoxie@huawei.com
Subject: Re: [PATCH] jbd2: set freed flag while revoking a buffer which
 belongs to older transaction
Message-ID: <20190113151219.GF2713@desktop>
References: <1547100722-132243-1-git-send-email-yi.zhang@huawei.com>
 <20190112073957.GE2713@desktop>
 <6604f73f-15f8-688d-a361-19503ffa9cf0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6604f73f-15f8-688d-a361-19503ffa9cf0@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 12, 2019 at 05:32:21PM +0800, zhangyi (F) wrote:
> On 2019/1/12 15:39, Eryu Guan Wrote:
> > On Thu, Jan 10, 2019 at 02:12:02PM +0800, zhangyi (F) wrote:
> >> Now, we capture a data corruption problem on ext4 while we're truncating
> >> an extent index block. Imaging that if we are revoking a buffer which
> >> has been journaled by the committing transaction, the buffer's jbddirty
> >> flag will not be cleared in jbd2_journal_forget(), so the commit code
> >> will set the buffer dirty flag again after refile the buffer.
> >>
> >> fsx                               kjournald2
> >>                                   jbd2_journal_commit_transaction
> >> jbd2_journal_revoke                commit phase 1~5...
> >>  jbd2_journal_forget
> >>    belongs to older transaction    commit phase 6
> >>    jbddirty not clear               __jbd2_journal_refile_buffer
> >>                                      __jbd2_journal_unfile_buffer
> >>                                       test_clear_buffer_jbddirty
> >>                                        mark_buffer_dirty
> >>
> >> Finally, if the freed extent index block was allocated again as data
> >> block by some other files, it may corrupt the file data when writing
> >> cached pages later, such as during umount time.
> >>
> >> This patch mark buffer as freed when it already belongs to the
> >> committing transaction in jbd2_journal_forget(), so that commit code
> >> knows it should clear dirty bits when it is done with the buffer.
> >>
> >> This problem can be reproduced by xfstests generic/455 easily with
> >> seeds (3246 3247 3248 3249).
> > 
> > Would you please capture the fsx ops sequences that could reproduce the
> > problem and replay it in a targeted regression test, like what
> > generic/{499,511} do? Thanks!
> > 
> 
> Yes, I will do it. But this problem is timing dependent, so I am afraid
> this targeted regression test cannot always reproduce it (not even
> generic/455 with above seeds).

That's fine, if there're multiple sequences could reproduce the bug, we
could replay them all in a test.

> 
> BTW, we only test and capture this problem on ext4, I am not sure other
> file systems have the same problem or not. So better to categorize this
> test to tests/ext4 group?

If there's nothing specific to ext4, a generic test would be fine.

Thanks!

Eryu
