From: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [patch]check NULL pointer
Date: Fri, 10 Jun 2011 14:34:52 +0800
Message-ID: <1307687692.15392.79.camel@sli10-conroe>
References: <1307590292.15392.71.camel@sli10-conroe>
	 <alpine.LFD.2.00.1106091112560.4138@dhcp-27-109.brq.redhat.com>
	 <4DF0DE02.1090008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Ted Ts'o <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11101 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab1FJGez (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Jun 2011 02:34:55 -0400
In-Reply-To: <4DF0DE02.1090008@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2011-06-09 at 22:51 +0800, Eric Sandeen wrote:
> On 6/9/11 4:24 AM, Lukas Czerner wrote:
> > On Thu, 9 Jun 2011, Shaohua Li wrote:
> > 
> >> orig_data could be NULL.
> > 
> > Now, that is the commit description :). Could you please be more
> > descriptive in the "descritpion" ? Also the subject is not right either,
> > please see Documentation/SubmittingPatches
> 
> Yes; if possible please use the commit message to describe how/why orig_data
> can be NULL; a testcase if one exists; the resulting flaw (null pointer deref?)
> etc.
> 
> something like:
> 
> Subject: [PATCH] ext4: check for NULL orig_data pointer in mount paths
> 
> The orig_data pointer in ext4_fill_super()  and ext4_remount()
> can be null if < ??? >, which can lead to < ??? > in the mount
> and remount paths.  This can be demonstrated by < ??? >.  
> To avoid this, we can simply test for the null pointer
> and return an error in ext4_fill_super() and ext4_remount().
I thought the reason is pretty straightforward, anyway here is the
updated patch.

Subject: [patch]ext4: check NULL pointer for mount and remount

orig_data could be NULL, because the memory allocation of kstrdup() could fail.
Add the NULL check.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index cc5c157..45fc255 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3057,6 +3057,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
 	ext4_group_t first_not_zeroed;
 
+	if (!orig_data)
+		return ret;
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		goto out_free_orig;
@@ -4285,6 +4287,8 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 #endif
 	char *orig_data = kstrdup(data, GFP_KERNEL);
 
+	if (!orig_data)
+		return -ENOMEM;
 	/* Store the original options */
 	lock_super(sb);
 	old_sb_flags = sb->s_flags;


