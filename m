From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: deprecate obsoleted mount options v3
Date: Wed, 24 Feb 2010 21:12:40 +0300
Message-ID: <871vgaec4n.fsf_-_@openvz.org>
References: <1266431353-8549-1-git-send-email-dmonakhov@openvz.org>
	<1266432013-9241-3-git-send-email-dmonakhov@openvz.org>
	<E5AA2C0B-42FA-4025-A155-7ACD02EDE261@sun.com>
	<20100218205218.GL5337@thunk.org> <87d401jnml.fsf_-_@openvz.org>
	<57C5D8FD-F729-4C01-8485-6E76E7D2BDE6@sun.com>
	<87bpffpxha.fsf_-_@openvz.org> <20100223201345.GA5166@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: Andreas Dilger <adilger@sun.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:63303 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757382Ab0BXSMp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Feb 2010 13:12:45 -0500
In-Reply-To: <20100223201345.GA5166@thunk.org> (tytso@mit.edu's message of
	"Tue, 23 Feb 2010 15:13:45 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

tytso@mit.edu writes:

> On Tue, Feb 23, 2010 at 10:23:45PM +0300, Dmitry Monakhov wrote:
>> >
>> > I think deprecating an option is not the same as removing it entirely.
>> Ohh.. I've hoped to reuse freed bits for new crap.
>
> What "new crap" are you hoping to will need mount options? 
I want two bits in mount flags. But only one is available
for now. Don't you mind to extend mount flags to 64 bits?
>One of the
> things I want to do long term is to try to reduce/remove mount options
> in general.
>
> If we get general agreement that it's time to just turn on acl's and
> xattr's by default, we can change the default, and in that case
> removing the "noacl/noxattr" might be something that we might not need
> to keep for as long, or maybe at all.  But for things like
> bsddf/minixdf, we do need some kind of deprecation schedule.
>
> The use of Opt_deprecated and Opt_disabled seems a little pointless;
> nothing is using now, and nothing needs it.  All I'd probably do is
> something like this:
>
> static char deprecated_msg[] = "Mount option \"%s\" will be removed by %s\n"
>        "Contact linux-ext4@vger.kernel.org if you think we should keep it.\n"
>
> And then in each option that we want to deprecate, just add:
>
>     ext4_msg(sb, KERN_WARN, deprecated_msg, "bsddf", "2.6.39");
Yess. Definitely this look nicer.


--=-=-=
Content-Disposition: inline;
 filename=0001-ext4-deprecate-obsoleted-mount-options-v3.patch

>From 92ce6a649e6f9a99c9aa34b1650a7a85c8ee5b82 Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Wed, 24 Feb 2010 21:00:49 +0300
Subject: [PATCH] ext4: deprecate obsoleted mount options v3

Declare following list of mount options as deprecated:
 - bsddf, miniddf
 - grpid, bsdgroups, nogrpid, sysvgroups

Declare following list of default mount options as deprecated:
 - bsdgroups

Changes from v1
 - Mark options as deprecated instead of disabling it completely,
   they will be disabled after exportation period.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/super.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d5596ca..2b413c5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1212,6 +1212,8 @@ static ext4_fsblk_t get_sb_block(void **data)
 }
 
 #define DEFAULT_JOURNAL_IOPRIO (IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, 3))
+static char deprecated_msg[] = "Mount option \"%s\" will be removed by %s\n"
+	"Contact linux-ext4@vger.kernel.org if you think we should keep it.\n";
 
 static int parse_options(char *options, struct super_block *sb,
 			 unsigned long *journal_devnum,
@@ -1239,16 +1241,23 @@ static int parse_options(char *options, struct super_block *sb,
 		token = match_token(p, tokens, args);
 		switch (token) {
 		case Opt_bsd_df:
+			ext4_msg(sb, KERN_WARNING, deprecated_msg, p, "2.6.39");
 			clear_opt(sbi->s_mount_opt, MINIX_DF);
 			break;
 		case Opt_minix_df:
+			ext4_msg(sb, KERN_WARNING, deprecated_msg, p, "2.6.39");
 			set_opt(sbi->s_mount_opt, MINIX_DF);
+
 			break;
 		case Opt_grpid:
+			ext4_msg(sb, KERN_WARNING, deprecated_msg, p, "2.6.39");
 			set_opt(sbi->s_mount_opt, GRPID);
+
 			break;
 		case Opt_nogrpid:
+			ext4_msg(sb, KERN_WARNING, deprecated_msg, p, "2.6.39");
 			clear_opt(sbi->s_mount_opt, GRPID);
+
 			break;
 		case Opt_resuid:
 			if (match_int(&args[0], &option))
@@ -2445,8 +2454,11 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
 	if (def_mount_opts & EXT4_DEFM_DEBUG)
 		set_opt(sbi->s_mount_opt, DEBUG);
-	if (def_mount_opts & EXT4_DEFM_BSDGROUPS)
+	if (def_mount_opts & EXT4_DEFM_BSDGROUPS) {
+		ext4_msg(sb, KERN_WARNING, deprecated_msg, "bsdgroups",
+			"2.6.39");
 		set_opt(sbi->s_mount_opt, GRPID);
+	}
 	if (def_mount_opts & EXT4_DEFM_UID16)
 		set_opt(sbi->s_mount_opt, NO_UID32);
 #ifdef CONFIG_EXT4_FS_XATTR
-- 
1.6.6


--=-=-=--
