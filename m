From: Amir Goldstein <amir@cellrox.com>
Subject: Re: [RFC][PATCH] sysrq: Emergency Remount R/O in reverse order
Date: Wed, 29 Apr 2015 21:34:47 +0300
Message-ID: <CAA2m6vc71Hj1H70FmFXtM0c7avEYi1ALcpGNvbgWpoEkHWvR3A@mail.gmail.com>
References: <CAA2m6vfatWKS1CQFpaRbii2AXiZFvQUjVvYhGxWTSpz+2rxDyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Oren Laadan <orenl@cellrox.com>, viro@zeniv.linux.org.uk
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAA2m6vfatWKS1CQFpaRbii2AXiZFvQUjVvYhGxWTSpz+2rxDyg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted,

Did you see my query about emergency remount of loop mounted ext4?
Do you have any insights to share?

Thanks,
Amir.

On Fri, Apr 24, 2015 at 10:54 AM, Amir Goldstein <amir@cellrox.com> wrote:
> Hi Al,
>
> This patch is very naive. The fact that it tries to change a behavior
> that pre-dates modern git history suggests that I may be missing something.
>
> I am quite sure that the change of behavior is beneficial to my use case
> which involves loop mounts on Android, hence uploaded for Android:
> https://android-review.googlesource.com/148047
>
> I am not sure about the implications for other use cases, hence this RFC.
> Is there a reason to start remount from root fs, because later remounts
> may hang or take too long before some watchdog kicks in?
>
> Please enlighten me.
> Thanks,
>
> Amir.
>
> ---------- Forwarded message ----------
>
>
> This change fixes a problem where reboot on Android panics the kernel
> almost every time when file systems are mounted over loop devices.
>
> Android reboot command does:
> - sync
> - echo u > /proc/sysrq-trigger
> - syscall_reboot
>
> The problem is with sysrq emergency remount R/O trying to remount-ro
> in wrong order.
> since /data is re-mounted ro before loop devices, loop device
> remount-ro fails to flush the journal and panics the kernel:
>
>   EXT4-fs (loop0): Remounting filesystem read-only
>   EXT4-fs (loop0): previous I/O error to superblock detected
>   loop: Write error at byte offset 0, length 4096.
>   Buffer I/O error on device loop0, logical block 0
>   lost page write due to I/O error on loop0
>   Kernel panic - not syncing: EXT4-fs panic from previous error
>
> The fix is quite simple. In do_emergency_remount(), use
> list_for_each_entry_reverse() on sb list instead of list_for_each_entry().
> It makes a lot of sense to umount the file systems in reverse order in
> which they were added to sb list.
>
> Signed-off-by: Amir Goldstein <amir@cellrox.com>
> Acked-by: Oren Laadan <orenl@cellrox.com>
> ---
>  fs/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/super.c b/fs/super.c
> index 2b7dc90..f1315e0 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -774,7 +774,7 @@ static void do_emergency_remount(struct work_struct *work)
>         struct super_block *sb, *p = NULL;
>
>         spin_lock(&sb_lock);
> -       list_for_each_entry(sb, &super_blocks, s_list) {
> +       list_for_each_entry_reverse(sb, &super_blocks, s_list) {
>                 if (hlist_unhashed(&sb->s_instances))
>                         continue;
>                 sb->s_count++;
> --
> 1.8.2
