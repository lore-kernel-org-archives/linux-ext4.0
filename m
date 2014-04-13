From: jon ernst <jonernst07@gmail.com>
Subject: [PATCH] ext4: silence sparse check warning for function ext4_trim_extent.
Date: Sat, 12 Apr 2014 22:25:45 -0400
Message-ID: <CAGW2f1GZ3ns=Fr9Dkp3ixh7uQhiFg0xJmPxY60TmGEUk9E8SBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:55485 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbaDMCcE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Apr 2014 22:32:04 -0400
Received: by mail-qa0-f46.google.com with SMTP id i13so6724286qae.19
        for <linux-ext4@vger.kernel.org>; Sat, 12 Apr 2014 19:32:02 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

By doing "make  M=fs/ext4 C=2"
on commit ad6599ab3ac98a4474544086e048ce86ec15a4d1

sparse reports this warning:
  CHECK   fs/ext4/mballoc.c
fs/ext4/mballoc.c:5019:9: warning: context imbalance in
'ext4_trim_extent' - unexpected unlock


>From Documentation/sparse.txt:

Using sparse for lock checking
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following macros are undefined for gcc and defined during a sparse
run to use the "context" tracking feature of sparse, applied to
locking.  These annotations tell sparse when a lock is held, with
regard to the annotated function's entry and exit.

__must_hold - The specified lock is held on function entry and exit.

__acquires - The specified lock is held on function exit, but not entry.

__releases - The specified lock is held on function entry, but not exit.

If the function enters and exits without the lock held, acquiring and
releasing the lock inside the function in a balanced way, no
annotation is needed.  The tree annotations above are for cases where
sparse would otherwise report a context imbalance.



Signed-off-by: "Jon Ernst" <jonernst07@gmail.com>
---
 fs/ext4/mballoc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 73ccbb3..c8238a2 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5016,6 +5016,8 @@ error_return:
  */
 static int ext4_trim_extent(struct super_block *sb, int start, int count,
                 ext4_group_t group, struct ext4_buddy *e4b)
+__releases(bitlock)
+__acquires(bitlock)
 {
    struct ext4_free_extent ex;
    int ret = 0;
-- 
1.8.1.2
