From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH v2 0/5] ext4: try to fix up es regressions
Date: Thu, 07 Mar 2013 20:08:47 +0400
Message-ID: <87ppzbgpkg.fsf@openvz.org>
References: <1362579435-6333-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <wenqing.lz@taobao.com>, Theodore Ts'o <tytso@mit.edu>
To: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48296 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab3CGQIx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Mar 2013 11:08:53 -0500
Received: by mail-lb0-f174.google.com with SMTP id l12so576516lbo.19
        for <linux-ext4@vger.kernel.org>; Thu, 07 Mar 2013 08:08:51 -0800 (PST)
In-Reply-To: <1362579435-6333-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed,  6 Mar 2013 22:17:10 +0800, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> Hi all,
> 
> The patch series tries to fixup some regressions after applied the extent
> status tree.  These patches have rebased against the latest dev branch of
> ext4 and have been tested by xfstests.
> 
> After rebased the latest dev branch, two patches have been dropped because
> they have been applied into the branch.  A new patch is added, which tries
> to fix up a wrong return value in ext4_split_extent().  Otherwise, there
> are two major changes in this version.  The first one is to improve the
> self-testing-infrastructure according to Dmitry's comment.  The second one
> is to improve the zero out code.
> 
> After applied this patch series, I havn't seen the warning messages from
> self-testing infrastructure except the following cases.
> 
>  - xfstests #13 with bigalloc or with no journal
>  - xfstests #223 with dioread_nolock
> The reason is that when we lookup a block mapping from status tree
> i_data_sem locking won't be taken.  So there is a race window that an 
> unwritten extent could be converted by end_io when we compare the result
> between extent tree and status tree.
> 
> Dmitry, Ted, could you please confirm that this patch series can fix the
> defrag regression?  Thank you so much.  Until now I run #300 and #301 a
> lot times but I failed to hit this regression. :-(
Good work. All my tests now succeed (no error, no warning, no bugons), 
BUT 301'th (in terms of git://oss.sgi.com/xfs/cmds/xfstests.git)
result in massive memory leakage
about 8gb in an hour
#while true; do ./check 301  ;done
I suspect that 'struct ext4_ext_path' is leaked somewhere, I'm not
even sure that it is new one. 


I'll be out of email next week. 

Good luck.
> 
> *Big Note*
> When I am testing this patch series, I found some regressions in dev branch.
> Here is a note.  These regressions could be hitted by running test case
> serveral times.  So If we just run xfstests one time, they could be missed.
> 
>  - xfstests #74 with data=journal
>  - xfstests #83 with bigalloc
> Some threads could be blocked for 120s.
> 
>  - xfstests #247 with data=journal
> Some warning messages are printed by ext4_releasepage.  We hit
> WARN_ON(PageChecked(page)) in this function.  But the test case itself can
> pass.
> 
>  - xfstests #269 with dioread_nolock
> The system will hang
> 
> I don't paste full details here to make description clearly.  I will go on
> tracing these problems.  I am happy to provide full details if some one
> want to take a close look at these problems.
> 
> v2 <- v1:
>  * Improve self-testing infrastructure
>  * Improve zero out code
>  * Fix a wrong return value in ext4_split_extent
> 
> v1: http://permalink.gmane.org/gmane.comp.file-systems.ext4/37338
> 
> Thanks,
> 						- Zheng
> 
> Dmitry Monakhov (1):
>   ext4: add self-testing infrastructure to do a sanity check
> 
> Zheng Liu (4):
>   ext4: improve ext4_es_can_be_merged() to avoid a potential overflow
>   ext4: fix wrong m_len value after unwritten extent conversion
>   ext4: update extent status tree after an extent is zeroed out
>   ext4: fix wrong the number of the allocted blocks in
>     ext4_split_extent
> 
>  fs/ext4/extents.c        |  45 ++++++++--
>  fs/ext4/extents_status.c | 212 +++++++++++++++++++++++++++++++++++++++++++++--
>  fs/ext4/extents_status.h |   9 ++
>  fs/ext4/inode.c          | 106 ++++++++++++++++++++++++
>  4 files changed, 362 insertions(+), 10 deletions(-)
> 
> -- 
> 1.7.12.rc2.18.g61b472e
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
