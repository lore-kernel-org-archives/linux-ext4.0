From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH] ext4: Make the length of the mb_history file tunable
Date: Sat, 2 May 2009 09:30:11 -0700
Message-ID: <6601abe90905020930w38f8babds2115a2d671eebe8a@mail.gmail.com>
References: <6601abe90904201153q5e66cb30na22a49767245e53f@mail.gmail.com>
	 <1241224297-11223-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Michael Rubin <mrubin@google.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:47154 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272AbZEBQaP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 May 2009 12:30:15 -0400
Received: from wpaz24.hot.corp.google.com (wpaz24.hot.corp.google.com [172.24.198.88])
	by smtp-out.google.com with ESMTP id n42GUEG8008329
	for <linux-ext4@vger.kernel.org>; Sat, 2 May 2009 09:30:14 -0700
Received: from qyk32 (qyk32.prod.google.com [10.241.83.160])
	by wpaz24.hot.corp.google.com with ESMTP id n42GTw16009253
	for <linux-ext4@vger.kernel.org>; Sat, 2 May 2009 09:30:12 -0700
Received: by qyk32 with SMTP id 32so5411356qyk.0
        for <linux-ext4@vger.kernel.org>; Sat, 02 May 2009 09:30:12 -0700 (PDT)
In-Reply-To: <1241224297-11223-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted:

Thanks for sending this out.  It was on my list to re-vamp the patch
to use your suggestion of a mount option, but I didn't get a chance.

I tested it on our 2.6.26+patches kernel, and it works fine.
Curt


On Fri, May 1, 2009 at 5:31 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> From: Curt Wohlgemuth <curtw@google.com>
>
> In memory-constrained systems with many partitions, the ~68K for each
> partition for the mb_history buffer can be excessive.
>
> This patch adds a new mount option, mb_history_length, as well as a
> way of setting the default via a module parameter (or via a sysfs
> parameter in /sys/module/ext4/parameter/default_mb_history_length).
> If the mb_history_length is set to zero, the mb_history facility is
> disabled entirely.
>
> Signed-off-by: Curt Wohlgemuth <curtw@google.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>
> I completely revamped how how tunable is set. =A0The combination of a
> mount option plus a default which can be tuned via a sysfs file or a
> module parameter is cleaner, and certainly requires less code. =A0(No=
 need
> to open-code new file in /proc, which should be avoided if at all
> possible.)
>
> Anyway, this is what I've dropped into the ext4 patch queue.
>
> =A0fs/ext4/mballoc.c | =A0 13 +++++++------
> =A0fs/ext4/super.c =A0 | =A0 18 +++++++++++++++++-
> =A02 files changed, 24 insertions(+), 7 deletions(-)
>
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index dbd47ea..df75855 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2413,7 +2413,8 @@ static void ext4_mb_history_release(struct supe=
r_block *sb)
>
> =A0 =A0 =A0 =A0if (sbi->s_proc !=3D NULL) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0remove_proc_entry("mb_groups", sbi->s_=
proc);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 remove_proc_entry("mb_history", sbi->s_=
proc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sbi->s_mb_history_max)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 remove_proc_entry("mb_h=
istory", sbi->s_proc);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0kfree(sbi->s_mb_history);
> =A0}
> @@ -2424,17 +2425,17 @@ static void ext4_mb_history_init(struct super=
_block *sb)
> =A0 =A0 =A0 =A0int i;
>
> =A0 =A0 =A0 =A0if (sbi->s_proc !=3D NULL) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 proc_create_data("mb_history", S_IRUGO,=
 sbi->s_proc,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&ext=
4_mb_seq_history_fops, sb);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sbi->s_mb_history_max)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 proc_create_data("mb_hi=
story", S_IRUGO, sbi->s_proc,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0&ext4_mb_seq_history_fops, sb);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0proc_create_data("mb_groups", S_IRUGO,=
 sbi->s_proc,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &ext4=
_mb_seq_groups_fops, sb);
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 sbi->s_mb_history_max =3D 1000;
> =A0 =A0 =A0 =A0sbi->s_mb_history_cur =3D 0;
> =A0 =A0 =A0 =A0spin_lock_init(&sbi->s_mb_history_lock);
> =A0 =A0 =A0 =A0i =3D sbi->s_mb_history_max * sizeof(struct ext4_mb_hi=
story);
> - =A0 =A0 =A0 sbi->s_mb_history =3D kzalloc(i, GFP_KERNEL);
> + =A0 =A0 =A0 sbi->s_mb_history =3D i ? kzalloc(i, GFP_KERNEL) : NULL=
;
> =A0 =A0 =A0 =A0/* if we can't allocate history, then we simple won't =
use it */
> =A0}
>
> @@ -2444,7 +2445,7 @@ ext4_mb_store_history(struct ext4_allocation_co=
ntext *ac)
> =A0 =A0 =A0 =A0struct ext4_sb_info *sbi =3D EXT4_SB(ac->ac_sb);
> =A0 =A0 =A0 =A0struct ext4_mb_history h;
>
> - =A0 =A0 =A0 if (unlikely(sbi->s_mb_history =3D=3D NULL))
> + =A0 =A0 =A0 if (sbi->s_mb_history =3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
>
> =A0 =A0 =A0 =A0if (!(ac->ac_op & sbi->s_mb_history_filter))
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 7903f20..39223a5 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -47,6 +47,13 @@
> =A0#include "xattr.h"
> =A0#include "acl.h"
>
> +static int default_mb_history_length =3D 1000;
> +
> +module_param_named(default_mb_history_length, default_mb_history_len=
gth,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int, 0644);
> +MODULE_PARM_DESC(default_mb_history_length,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"Default number of entries saved for=
 mb_history");
> +
> =A0struct proc_dir_entry *ext4_proc_root;
> =A0static struct kset *ext4_kset;
>
> @@ -1042,7 +1049,7 @@ enum {
> =A0 =A0 =A0 =A0Opt_journal_update, Opt_journal_dev,
> =A0 =A0 =A0 =A0Opt_journal_checksum, Opt_journal_async_commit,
> =A0 =A0 =A0 =A0Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_dat=
a_writeback,
> - =A0 =A0 =A0 Opt_data_err_abort, Opt_data_err_ignore,
> + =A0 =A0 =A0 Opt_data_err_abort, Opt_data_err_ignore, Opt_mb_history=
_length,
> =A0 =A0 =A0 =A0Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_of=
fgrpjquota,
> =A0 =A0 =A0 =A0Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noqu=
ota,
> =A0 =A0 =A0 =A0Opt_ignore, Opt_barrier, Opt_nobarrier, Opt_err, Opt_r=
esize,
> @@ -1088,6 +1095,7 @@ static const match_table_t tokens =3D {
> =A0 =A0 =A0 =A0{Opt_data_writeback, "data=3Dwriteback"},
> =A0 =A0 =A0 =A0{Opt_data_err_abort, "data_err=3Dabort"},
> =A0 =A0 =A0 =A0{Opt_data_err_ignore, "data_err=3Dignore"},
> + =A0 =A0 =A0 {Opt_mb_history_length, "mb_history_length=3D%u"},
> =A0 =A0 =A0 =A0{Opt_offusrjquota, "usrjquota=3D"},
> =A0 =A0 =A0 =A0{Opt_usrjquota, "usrjquota=3D%s"},
> =A0 =A0 =A0 =A0{Opt_offgrpjquota, "grpjquota=3D"},
> @@ -1329,6 +1337,13 @@ static int parse_options(char *options, struct=
 super_block *sb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case Opt_data_err_ignore:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0clear_opt(sbi->s_mount=
_opt, DATA_ERR_ABORT);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case Opt_mb_history_length:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (match_int(&args[0],=
 &option))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (option < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sbi->s_mb_history_max =3D=
 option;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> =A0#ifdef CONFIG_QUOTA
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case Opt_usrjquota:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0qtype =3D USRQUOTA;
> @@ -2345,6 +2360,7 @@ static int ext4_fill_super(struct super_block *=
sb, void *data, int silent)
> =A0 =A0 =A0 =A0sbi->s_commit_interval =3D JBD2_DEFAULT_MAX_COMMIT_AGE=
 * HZ;
> =A0 =A0 =A0 =A0sbi->s_min_batch_time =3D EXT4_DEF_MIN_BATCH_TIME;
> =A0 =A0 =A0 =A0sbi->s_max_batch_time =3D EXT4_DEF_MAX_BATCH_TIME;
> + =A0 =A0 =A0 sbi->s_mb_history_max =3D default_mb_history_length;
>
> =A0 =A0 =A0 =A0set_opt(sbi->s_mount_opt, BARRIER);
>
> --
> 1.6.0.4
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
