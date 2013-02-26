From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] jbd2: Fix ERR_PTR dereference in jbd2__journal_start
Date: Wed, 27 Feb 2013 03:18:57 +0400
Message-ID: <87mwuqmzoe.fsf@openvz.org>
References: <87obfcs1x6.fsf@openvz.org> <20130222180325.GB21264@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: linux-ext4@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:36176 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab3BZXTC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Feb 2013 18:19:02 -0500
Received: by mail-lb0-f181.google.com with SMTP id gm6so33279lbb.26
        for <linux-ext4@vger.kernel.org>; Tue, 26 Feb 2013 15:19:00 -0800 (PST)
In-Reply-To: <20130222180325.GB21264@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

On Fri, 22 Feb 2013 13:03:25 -0500, "Theodore Ts'o" <tytso@mit.edu> wrote:
> On Fri, Feb 22, 2013 at 09:17:57PM +0400, Dmitry Monakhov wrote:
> > 
> > 301'th xfstests are failed due to :
> > commit d100eef2440fea13e4f09e88b1c8bcbca64beb9f
> > Author: Zheng Liu <wenqing.lz@taobao.com>
> > Date:   Mon Feb 18 00:29:59 2013 -0500
> > 
> >     ext4: lookup block mapping in extent status tree
> > 
> > TESTCASE: https://github.com/dmonakhov/xfstests/commit/7b7efeee30a41109201e2040034e71db9b66ddc0
> 
> Thanks for the heads up.  I haven't updatied the xfstests I've been
> using yet, since I want to make sure I'm comparing apples and oranges
> during the merge window when I'm checking for regressions; I'll update
> my xfstests in a week or two after the merge window settles down, and
> then I'll rerun my baseline tests using the updated xfstests against
> 3.8.0 and 3.9-rc2 or 3.9-rc3.
Ohh. I've found that 303'th test failed for 304e220f0(ext4_for_linus)
EIO result in OOPS due to ERR_PTR dereference see patch attached
It is bad luck that it was not triggered before, but it is always hard
to have good coverage for such dark corners. Obviously this type of
mistypes should be spotted by one of Julia Lawall's magic scripts
I'll check that and try to write new one if it not exist yet.

--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment;
 filename=0001-jbd2-Fix-ERR_PTR-dereference-in-jbd2__journal_start.patch

>From 65344ff34ebbe6dc45c193c3d88e7a74668edfd5 Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Wed, 27 Feb 2013 02:59:37 +0400
Subject: [PATCH] jbd2: Fix ERR_PTR dereference in jbd2__journal_start

If start_this_handle() failed handle will be initialized
to ERR_PTR() and can not be dereferenced.

paging request at fffffffffffffff6
IP: [<ffffffff813c073f>] jbd2__journal_start+0x18f/0x290
PGD 200e067 PUD 200f067 PMD 0
Oops: 0000 [#1] SMP
Modules linked in: cpufreq_ondemand acpi_cpufreq freq_table mperf coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode sg xhci_hcd button sd_mod crc_t10dif aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul ahci libahci pata_acpi ata_generic dm_mirror dm_region_hash dm_log dm_mod
CPU 0 journal commit I/O error

Pid: 2694, comm: fio Not tainted 3.8.0-rc3+ #79                  /DQ67SW
RIP: 0010:[<ffffffff813c073f>]  [<ffffffff813c073f>] jbd2__journal_start+0x18f/0x290
RSP: 0018:ffff880233b8ba58  EFLAGS: 00010292
RAX: 00000000ffffffe2 RBX: ffffffffffffffe2 RCX: 0000000000000006
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff82128f48
RBP: ffff880233b8ba98 R08: 0000000000000000 R09: ffff88021440a6e0

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/jbd2/transaction.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index b7e2385..d6ee5ae 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -382,7 +382,7 @@ handle_t *jbd2__journal_start(journal_t *journal, int nblocks, gfp_t gfp_mask,
 	if (err < 0) {
 		jbd2_free_handle(handle);
 		current->journal_info = NULL;
-		handle = ERR_PTR(err);
+		return ERR_PTR(err);
 	}
 	handle->h_type = type;
 	handle->h_line_no = line_no;
-- 
1.7.1


--=-=-=


> 
> (And furthermore, these new xfstests aren't yet in xfstests upstream
> yet, right?  Any comments from the xfstests maintainer about whether
> they are going to be willing to take your proposed new test cases?)
> 
> So when you say this is a regression, I take it that this test #301
> doesn't fail on commit d100eef2440f^, but it does fail on d100eef2440f,
> correct?
> 
> 						- Ted

--=-=-=--
