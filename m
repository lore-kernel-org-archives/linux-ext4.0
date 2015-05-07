From: Amir Goldstein <amir@cellrox.com>
Subject: Re: [RFC][PATCH] sysrq: Emergency Remount R/O in reverse order
Date: Thu, 7 May 2015 09:38:48 +0300
Message-ID: <CAA2m6vdA_sKoo16vzx7Th1OVOae3xOTKtTQGvh-1+=ZXm50BTg@mail.gmail.com>
References: <CAA2m6vfatWKS1CQFpaRbii2AXiZFvQUjVvYhGxWTSpz+2rxDyg@mail.gmail.com>
	<CAA2m6vdqjzws6UjSZnryFBWrcXiKUz2p2gKjg5LftZsF43jeew@mail.gmail.com>
	<20150430153130.GG12374@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Oren Laadan <orenl@cellrox.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: viro@zeniv.linux.org.uk
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150430153130.GG12374@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 30, 2015 at 6:31 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Wed, Apr 29, 2015 at 09:33:45PM +0300, Amir Goldstein wrote:
>> Hi Ted,
>>
>> Did you see my query about emergency remount of loop mounted ext4?
>> Do you have any insights to share?
>
> Your patch makes sense to me.  Doing the remount-ro in reverse order
> that file systems were mounted sounds like the right thing to do.
>
> I can imagine trying to make ext4 handle the situation where it is
> trying to do an unmount, or remount r/o, and the device has gone
> read-only in a similar situation as one where the device has
> disappeared altogether, but it's not going to solve all possible
> issues.  Trying to unmount or remount r/o the most recently mounted
> file system first is simpler and will solve more problems.
>
> Al?

Al,
Any comment?
Anybody else who dares to touch this code?
Anybody who benefits from this change?
Anybody who might be harmed from it?


>
>                                         - Ted
>
>> >
>> > This change fixes a problem where reboot on Android panics the kernel
>> > almost every time when file systems are mounted over loop devices.
>> >
>> > Android reboot command does:
>> > - sync
>> > - echo u > /proc/sysrq-trigger
>> > - syscall_reboot
>> >
>> > The problem is with sysrq emergency remount R/O trying to remount-ro
>> > in wrong order.
>> > since /data is re-mounted ro before loop devices, loop device
>> > remount-ro fails to flush the journal and panics the kernel:
>> >
>> >   EXT4-fs (loop0): Remounting filesystem read-only
>> >   EXT4-fs (loop0): previous I/O error to superblock detected
>> >   loop: Write error at byte offset 0, length 4096.
>> >   Buffer I/O error on device loop0, logical block 0
>> >   lost page write due to I/O error on loop0
>> >   Kernel panic - not syncing: EXT4-fs panic from previous error
>> >
>> > The fix is quite simple. In do_emergency_remount(), use
>> > list_for_each_entry_reverse() on sb list instead of list_for_each_entry().
>> > It makes a lot of sense to umount the file systems in reverse order in
>> > which they were added to sb list.
>> >
>> > Signed-off-by: Amir Goldstein <amir@cellrox.com>
>> > Acked-by: Oren Laadan <orenl@cellrox.com>
>> > ---
>> >  fs/super.c | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/fs/super.c b/fs/super.c
>> > index 2b7dc90..f1315e0 100644
>> > --- a/fs/super.c
>> > +++ b/fs/super.c
>> > @@ -774,7 +774,7 @@ static void do_emergency_remount(struct work_struct
>> > *work)
>> >         struct super_block *sb, *p = NULL;
>> >
>> >         spin_lock(&sb_lock);
>> > -       list_for_each_entry(sb, &super_blocks, s_list) {
>> > +       list_for_each_entry_reverse(sb, &super_blocks, s_list) {
>> >                 if (hlist_unhashed(&sb->s_instances))
>> >                         continue;
>> >                 sb->s_count++;
>> > --
>> > 1.8.2
>> >
