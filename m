From: Valerie Aurora <val@vaaconsulting.com>
Subject: Re: [RFC PATCH 1/3] VFS: Fix s_umount thaw/write deadlock
Date: Wed, 14 Sep 2011 16:53:38 -0700
Message-ID: <CAD-Xuj=XnUBQ=-gmrdaBj6ABJei25ELR-Mg1XMRw4wEL=JwWcQ@mail.gmail.com>
References: <CAD-Xujmjai2evYC4a4CdNPtjh_9xhbELcZePtGSS54VPRGpznA@mail.gmail.com>
	<CAD-Xujm87Aj6y09GRXPVMZM+9N_7wyte-YNp7t0Wi3R2qH2mHQ@mail.gmail.com>
	<20110914140047.GB7903@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36927 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1INXxk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Sep 2011 19:53:40 -0400
In-Reply-To: <20110914140047.GB7903@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 14, 2011 at 7:00 AM, Jan Kara <jack@suse.cz> wrote:
> On Mon 12-09-11 19:57:11, Valerie Aurora wrote:
>> Val, if you are sending patches as attachments, make them at least
>> text/plain please!

Oops, sorry.

>> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
>> index 04cf3b9..d1dca03 100644
>> --- a/fs/fs-writeback.c
>> +++ b/fs/fs-writeback.c
>> @@ -537,6 +537,9 @@ static long writeback_sb_inodes(struct super_blo=
ck *sb,
>> =A0 =A0 =A0 long write_chunk;
>> =A0 =A0 =A0 long wrote =3D 0; =A0/* count both pages and inodes */
>>
>> + =A0 =A0 if (vfs_is_frozen(sb))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
> =A0Umm, maybe we could make this more robust by skipping the superblo=
ck in
> __writeback_inodes_wb() and just explicitely stopping the writeback w=
hen
> work->sb is set (i.e. writeback is required only for frozen sb) in
> wb_writeback()?

Sorry, I don't quite understand what the goal is here?  I'm happy to
make the change, just want to make sure I'm accomplishing what you
want.

>> =A0 =A0 =A0 while (!list_empty(&wb->b_io)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct inode *inode =3D wb_inode(wb->b_i=
o.prev);
>>
>> @@ -1238,39 +1241,43 @@ EXPORT_SYMBOL(writeback_inodes_sb);
>> =A0 * writeback_inodes_sb_if_idle =A0 =A0 =A0 - =A0 =A0 =A0 start wr=
iteback if none underway
>> =A0 * @sb: the superblock
>> =A0 *
>> - * Invoke writeback_inodes_sb if no writeback is currently underway=
=2E
>> - * Returns 1 if writeback was started, 0 if not.
>> + * Invoke writeback_inodes_sb if no writeback is currently underway
>> + * and no one else holds the s_umount lock. =A0Returns 1 if writeba=
ck
>> + * was started, 0 if not.
>> =A0 */
>> =A0int writeback_inodes_sb_if_idle(struct super_block *sb)
>> =A0{
>> =A0 =A0 =A0 if (!writeback_in_progress(sb->s_bdi)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 down_read(&sb->s_umount);
>> - =A0 =A0 =A0 =A0 =A0 =A0 writeback_inodes_sb(sb);
>> - =A0 =A0 =A0 =A0 =A0 =A0 up_read(&sb->s_umount);
>> - =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> - =A0 =A0 } else
>> - =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (down_read_trylock(&sb->s_umount)) {
> =A0What's exactly the deadlock trylock protects from here? Or is it j=
ust an
> optimization?

The trylock is an optimization Dave Chinner suggested.  The first
version I wrote acquired the lock and then checked vfs_is_frozen().

This function and the similar following one each have one caller,
btrfs in one case and ext4 in the other, and they are both trying to
get more writes to go out to disk in the hope of freeing up disk
space.

>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 writeback_inodes_sb(sb);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 up_read(&sb->s_umount);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> + =A0 =A0 return 0;
>> =A0}
>> =A0EXPORT_SYMBOL(writeback_inodes_sb_if_idle);
>>
>> =A0/**
>> - * writeback_inodes_sb_if_idle =A0 =A0 =A0 - =A0 =A0 =A0 start writ=
eback if none underway
>> + * writeback_inodes_sb_nr_if_idle =A0 =A0- =A0 =A0 =A0 start writeb=
ack if none underway
>> =A0 * @sb: the superblock
>> =A0 * @nr: the number of pages to write
>> =A0 *
>> - * Invoke writeback_inodes_sb if no writeback is currently underway=
=2E
>> - * Returns 1 if writeback was started, 0 if not.
>> + * Invoke writeback_inodes_sb if no writeback is currently underway
>> + * and no one else holds the s_umount lock. =A0Returns 1 if writeba=
ck
>> + * was started, 0 if not.
>> =A0 */
>> =A0int writeback_inodes_sb_nr_if_idle(struct super_block *sb,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u=
nsigned long nr)
>> =A0{
>> =A0 =A0 =A0 if (!writeback_in_progress(sb->s_bdi)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 down_read(&sb->s_umount);
>> - =A0 =A0 =A0 =A0 =A0 =A0 writeback_inodes_sb_nr(sb, nr);
>> - =A0 =A0 =A0 =A0 =A0 =A0 up_read(&sb->s_umount);
>> - =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> - =A0 =A0 } else
>> - =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (down_read_trylock(&sb->s_umount)) {
> =A0The same question here...
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 writeback_inodes_sb_nr(sb,=
 nr);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 up_read(&sb->s_umount);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> + =A0 =A0 return 0;
>> =A0}
>> =A0EXPORT_SYMBOL(writeback_inodes_sb_nr_if_idle);
>>
>> diff --git a/fs/quota/quota.c b/fs/quota/quota.c
>> index b34bdb2..993ce22 100644
>> --- a/fs/quota/quota.c
>> +++ b/fs/quota/quota.c
>> @@ -366,6 +366,18 @@ SYSCALL_DEFINE4(quotactl, unsigned int, cmd, co=
nst char __user *, special,
>> =A0 =A0 =A0 if (IS_ERR(sb))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(sb);
>>
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* It's not clear which quota functions may write to the=
 file
>> + =A0 =A0 =A0* system (all?). =A0Check for a frozen fs and bail out =
now.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 if (vfs_is_frozen(sb)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 drop_super(sb);
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* XXX Should quotactl_block() error path =
do this too? */
> =A0Yes, it does. Thanks for spotting this.

=46ixed, thanks for confirming.

>> + =A0 =A0 =A0 =A0 =A0 =A0 if (pathp && !IS_ERR(pathp))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path_put(pathp);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -EBUSY;
>> + =A0 =A0 }
>> +
>> =A0 =A0 =A0 ret =3D do_quotactl(sb, type, cmds, id, addr, pathp);
>>
>> =A0 =A0 =A0 drop_super(sb);
> ...
>> diff --git a/fs/sync.c b/fs/sync.c
>> index c98a747..db15b11 100644
>> --- a/fs/sync.c
>> +++ b/fs/sync.c
>> @@ -68,7 +68,7 @@ int sync_filesystem(struct super_block *sb)
>> =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0* No point in syncing out anything if the filesystem =
is read-only.
>> =A0 =A0 =A0 =A0*/
>> - =A0 =A0 if (sb->s_flags & MS_RDONLY)
>> + =A0 =A0 if ((sb->s_flags & MS_RDONLY) && !vfs_is_frozen(sb))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0^^^^
> The check should be: (sb->s_flags & MS_RDONLY || vfs_is_frozen(sb))

=46ixed, and I reviewed the other checks for similar mistakes.  Thanks!
I'll resend soon.

-VAL
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
