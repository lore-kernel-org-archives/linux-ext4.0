From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Journal under-reservation bug on first >2G file
Date: Wed, 01 Oct 2014 09:43:32 -0500
Message-ID: <542C1314.3030603@redhat.com>
References: <542B1C38.9010409@redhat.com> <542B1EFC.4050500@redhat.com> <C355A8E9-1799-43AB-9F57-4EFE1BBE3767@dilger.ca> <20141001115320.GA2903@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbaJAOnh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Oct 2014 10:43:37 -0400
In-Reply-To: <20141001115320.GA2903@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/1/14 6:53 AM, Theodore Ts'o wrote:
> On Tue, Sep 30, 2014 at 03:36:17PM -0600, Andreas Dilger wrote:
>>>
>>>  1.5a) Always set the large_file feature with a fresh mkfs, insteadl
>>>        of relying on the accident of the resize inode being > 2G!
>>
>> I think that 1.5a is definitely the way to go for new mke2fs, I'm a
>> bit surprised that we didn't do this for "-t ext4" a long time ago
>> given that we've enabled lots of other features automatically.
> 
> Yes, I agree that would be a good thing to do.  I'll make the change
> to mke2fs.conf.
> 
>> There shouldn't be any problem to do this retroactively in e2fsck
>> and potentially at mount time for filesystems that already have some
>> features enabled that are post-large_file (e.g. extents, flex_bg, etc.)
>> This definitely would not impose any compatibility issues, because any
>> kernel that supports those features already understands large_file.
> 
> That sounds like a plan.  If we only enable it automatically at mount
> time (iff we mounted the file system read/write) if any of the ext3 or
> ext4 specific features are enabled, that should be completely safe.

Ok, so do that, and don't bump the reservations? I suppose
the size test & superblock write can be removed, then...

This does bug me a little; at one point we were very carefully not
enabling any new features by mounting with a new kernel; that was
specific to mounting-ext2-with-ext4 etc, but it still feels slightly
inconsistent.  Although I guess we enable it today by mounting-and-
writing-a-big-enough-file.

Something like this should fix it too, though, with less unexpected
behind-your-back behavior:

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3aa26e9..2f94cd6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2563,9 +2563,15 @@ retry_grab:
         * if there is delayed block allocation. But we still need
         * to journalling the i_disksize update if writes to the end
         * of file which has an already mapped buffer.
+        * If this write might need to update the superblock due to the
+        * filesize adding a new superblock feature flag, add that too.
         */
 retry_journal:
-       handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE, 1);
+       handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE,
+                                   EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+                                       EXT4_FEATURE_RO_COMPAT_LARGE_FILE) ?
+                                   1 : 2);
+
        if (IS_ERR(handle)) {
                page_cache_release(page);
                return PTR_ERR(handle);


-ERic
