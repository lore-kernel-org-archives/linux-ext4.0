From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [RFC PATCH] ext4: auto batched discard support at kernel thread
Date: Fri, 2 Dec 2011 17:12:36 +0900
Message-ID: <CAKYAXd9trE9b8LYuJLQ3sYn-3b-56MArTMaG0sMS01TPd+cfvA@mail.gmail.com>
References: <20111202060424.GA26155@july>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, tm@tao.ma, lczerner@redhat.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kyungmin Park <kmpark@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44531 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1LBIMi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Dec 2011 03:12:38 -0500
In-Reply-To: <20111202060424.GA26155@july>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/12/2 Kyungmin Park <kmpark@infradead.org>:
> Hi,
>
> It's proof of concept to run kernel thread for batched discard.
>
> Now it can run fitrim at user level. but it's not clear which deamon =
run this activity.
> In case of android platform, the launcher is candidate
> but user can change the default launcher then it can't use the fitrim=
 any more.
>
> To address this issue. no dependency with platform. run the fitrim at=
 kernel.
> Basically don't bother the user it runs at 2 clock. Please note that =
if it's clean state, it doesn't take much time.
>
> Please give opinions and comments.
I think that it is good approach. If we can adjust wake up time and
cycle, it is more better.
And we can avoid performance degradation by copy merging in mmc/sdd int=
ernal.
On the other hand lifetime of ssd/mmc is decreased by this patch ?
> Thank you,
> Kyungmin Park
> ---
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 5b0e26a..2cad9b3 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -942,6 +942,7 @@ struct ext4_inode_info {
>
> =C2=A0#define EXT4_MOUNT2_EXPLICIT_DELALLOC =C2=A00x00000001 /* User =
explicitly
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0specified delalloc */
> +#define EXT4_MOUNT2_AUTO_DISCARD =C2=A0 =C2=A0 =C2=A0 0x00000002 /* =
Auto batched discard */
>
> =C2=A0#define clear_opt(sb, opt) =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 EXT4_SB(sb)->s_mount_opt &=3D \
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0~EXT4_MOUNT_##opt
> @@ -1249,6 +1250,10 @@ struct ext4_sb_info {
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* record the last minlen when FITRIM is c=
alled. */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_t s_last_trim_minblks;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* timer for periodic auto batched discard */
> + =C2=A0 =C2=A0 =C2=A0 struct timer_list s_auto_discard;
> + =C2=A0 =C2=A0 =C2=A0 struct task_struct *s_auto_discard_thread;
> =C2=A0};
>
> =C2=A0static inline struct ext4_sb_info *EXT4_SB(struct super_block *=
sb)
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 3858767..a2e9920 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -818,6 +818,10 @@ static void ext4_put_super(struct super_block *s=
b)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0ext4_abort(sb, "Couldn't clean up the journal");
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> + =C2=A0 =C2=A0 =C2=A0 if (test_opt2(sb, AUTO_DISCARD)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kthread_stop(sbi->=
s_auto_discard_thread);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 del_timer(&sbi->s_=
auto_discard);
> + =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0 =C2=A0 =C2=A0 =C2=A0del_timer(&sbi->s_err_report);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_release_system_zone(sb);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_mb_release(sb);
> @@ -1144,6 +1148,9 @@ static int ext4_show_options(struct seq_file *s=
eq, struct vfsmount *vfs)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (test_opt(sb, DISCARD) && !(def_mount_o=
pts & EXT4_DEFM_DISCARD))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0seq_puts(seq, =
",discard");
>
> + =C2=A0 =C2=A0 =C2=A0 if (test_opt2(sb, AUTO_DISCARD))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 seq_puts(seq, ",au=
to_batched_discard");
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (test_opt(sb, NOLOAD))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0seq_puts(seq, =
",norecovery");
>
> @@ -1333,7 +1340,7 @@ enum {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Opt_nomblk_io_submit, Opt_block_validity, =
Opt_noblock_validity,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Opt_inode_readahead_blks, Opt_journal_iopr=
io,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Opt_dioread_nolock, Opt_dioread_lock,
> - =C2=A0 =C2=A0 =C2=A0 Opt_discard, Opt_nodiscard,
> + =C2=A0 =C2=A0 =C2=A0 Opt_discard, Opt_nodiscard, Opt_auto_discard,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Opt_init_inode_table, Opt_noinit_inode_tab=
le,
> =C2=A0};
>
> @@ -1407,6 +1414,7 @@ static const match_table_t tokens =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{Opt_dioread_lock, "dioread_lock"},
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{Opt_discard, "discard"},
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{Opt_nodiscard, "nodiscard"},
> + =C2=A0 =C2=A0 =C2=A0 {Opt_auto_discard, "auto_batched_discard"},
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{Opt_init_inode_table, "init_itable=3D%u"}=
,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{Opt_init_inode_table, "init_itable"},
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{Opt_noinit_inode_table, "noinit_itable"},
> @@ -1886,6 +1894,9 @@ set_qf_format:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case Opt_nodis=
card:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0clear_opt(sb, DISCARD);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0break;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case Opt_auto_disc=
ard:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 set_opt2(sb, AUTO_DISCARD);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 break;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case Opt_diore=
ad_nolock:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0set_opt(sb, DIOREAD_NOLOCK);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0break;
> @@ -2763,6 +2774,71 @@ static void print_daily_error_info(unsigned lo=
ng arg)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0mod_timer(&sbi->s_err_report, jiffies + 24=
*60*60*HZ); =C2=A0/* Once a day */
> =C2=A0}
>
> +/*
> + * This function is called once a day to make a trim the device
> + */
> +static int ext4_auto_batched_discard_thread(void *data)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct super_block *sb =3D data;
> + =C2=A0 =C2=A0 =C2=A0 struct ext4_sb_info *sbi =3D EXT4_SB(sb);
> + =C2=A0 =C2=A0 =C2=A0 struct fstrim_range range;
> + =C2=A0 =C2=A0 =C2=A0 struct timeval now;
> + =C2=A0 =C2=A0 =C2=A0 struct tm tm;
> + =C2=A0 =C2=A0 =C2=A0 long next;
> + =C2=A0 =C2=A0 =C2=A0 int ret;
> +
> + =C2=A0 =C2=A0 =C2=A0 set_freezable();
> +
> + =C2=A0 =C2=A0 =C2=A0 for (;;) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (kthread_should=
_stop())
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 break;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (try_to_freeze(=
))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 continue;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 range.start =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 range.len =3D ~(__=
u64)0;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 range.minlen =3D S=
Z_1M;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D ext4_trim_=
fs(sb, &range);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret < 0)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ext4_msg(sb, KERN_NOTICE, "error count: %u", ret);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ext4_msg(sb, KERN_NOTICE, "trimmed size %llu",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 range.l=
en);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 do_gettimeofday(&n=
ow);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 time_to_tm((time_t=
) now.tv_sec, 0, &tm);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Run the every d=
ay at 2 clock */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* XXX need to con=
sider the timezone? */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 next =3D 2 - tm.tm=
_hour;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (next <=3D 0)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 next +=3D 24;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 next *=3D 60*60*HZ=
;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Re-arm the time=
r for next trim */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mod_timer(&sbi->s_=
auto_discard, jiffies + next);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 set_current_state(=
TASK_INTERRUPTIBLE);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 schedule();
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +}
> +
> +static void ext4_auto_batched_discard(unsigned long arg)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct super_block *sb =3D (struct super_block=
 *) arg;
> + =C2=A0 =C2=A0 =C2=A0 struct ext4_sb_info *sbi =3D EXT4_SB(sb);
> +
> + =C2=A0 =C2=A0 =C2=A0 /*
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* The ext4_trim_fs can't run at timer co=
ntext
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* So use the created kthread.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 wake_up_process(sbi->s_auto_discard_thread);
> +}
> +
> =C2=A0/* Find next suitable group and run ext4_init_inode_table */
> =C2=A0static int ext4_run_li_request(struct ext4_li_request *elr)
> =C2=A0{
> @@ -3576,6 +3652,21 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0sbi->s_err_report.function =3D print_daily=
_error_info;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0sbi->s_err_report.data =3D (unsigned long)=
 sb;
>
> + =C2=A0 =C2=A0 =C2=A0 if (test_opt2(sb, AUTO_DISCARD)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 init_timer(&sbi->s=
_auto_discard);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sbi->s_auto_discar=
d.function =3D ext4_auto_batched_discard;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sbi->s_auto_discar=
d.data =3D (unsigned long) sb;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sbi->s_auto_discar=
d_thread =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 kthread_create(ext4_auto_batched_discard_thread, sb,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "ext4-batched-discard");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(sbi->s_=
auto_discard_thread)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 err =3D PTR_ERR(sbi->s_auto_discard_thread);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto failed_mount2;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* One hour is eno=
ugh to know the time */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mod_timer(&sbi->s_=
auto_discard, jiffies + 1*60*60*HZ);
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D percpu_counter_init(&sbi->s_freecl=
usters_counter,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0ext4_count_free_clusters(sb));
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!err) {
> @@ -3848,6 +3939,10 @@ failed_mount_wq:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sbi->s_journal=
 =3D NULL;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0failed_mount3:
> + =C2=A0 =C2=A0 =C2=A0 if (test_opt2(sb, AUTO_DISCARD)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kthread_stop(sbi->=
s_auto_discard_thread);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 del_timer(&sbi->s_=
auto_discard);
> + =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0 =C2=A0 =C2=A0 =C2=A0del_timer(&sbi->s_err_report);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (sbi->s_flex_groups)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_kvfree(sb=
i->s_flex_groups);
> @@ -4546,6 +4641,22 @@ static int ext4_remount(struct super_block *sb=
, int *flags, char *data)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (sbi->s_journal =3D=3D NULL)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_commit_su=
per(sb, 1);
>
> + =C2=A0 =C2=A0 =C2=A0 if (test_opt2(sb, AUTO_DISCARD) && !sbi->s_aut=
o_discard_thread) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 init_timer(&sbi->s=
_auto_discard);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sbi->s_auto_discar=
d.function =3D ext4_auto_batched_discard;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sbi->s_auto_discar=
d.data =3D (unsigned long) sb;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sbi->s_auto_discar=
d_thread =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 kthread_create(ext4_auto_batched_discard_thread, sb,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "ext4-batched-discard");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(sbi->s_=
auto_discard_thread)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 err =3D PTR_ERR(sbi->s_auto_discard_thread);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto restore_opts;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* One hour is eno=
ugh to know the time */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mod_timer(&sbi->s_=
auto_discard, jiffies + 1*60*60*HZ);
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> =C2=A0#ifdef CONFIG_QUOTA
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Release old quota file names */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i < MAXQUOTAS; i++)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
