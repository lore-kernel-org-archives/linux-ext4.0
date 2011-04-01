From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: kernel BUG at fs/jbd2/transaction.c:1086!
Date: Fri, 1 Apr 2011 02:54:42 -0700
Message-ID: <AANLkTin0L8JZgdC-NT5GdX+5_H_DbJWVak8-Mvcn+suc@mail.gmail.com>
References: <alpine.LFD.2.00.1103301651240.17917@dhcp-27-109.brq.redhat.com>
	<20110331164319.GG21524@quack.suse.cz>
	<alpine.LFD.2.00.1103312255270.3020@dhcp-27-109.brq.redhat.com>
	<20110331222306.GI21524@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, Eric Sandeen <esandeen@redhat.com>
To: Jan Kara <jack@suse.cz>, Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:65193 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab1DAJyn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Apr 2011 05:54:43 -0400
Received: by qyk7 with SMTP id 7so202322qyk.19
        for <linux-ext4@vger.kernel.org>; Fri, 01 Apr 2011 02:54:42 -0700 (PDT)
In-Reply-To: <20110331222306.GI21524@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 31, 2011 at 3:23 PM, Jan Kara <jack@suse.cz> wrote:
> On Thu 31-03-11 22:59:24, Lukas Czerner wrote:
>> On Thu, 31 Mar 2011, Jan Kara wrote:
>>
>> > On Wed 30-03-11 17:32:06, Lukas Czerner wrote:
>> > > Hello,
>> > >
>> > > I have hit BUG_ON while running xfstest 234 in the loop
>> > > on the ext4. Backtrace below .
>> > >
>> > > I thought that this problem was solved with
>> > > 67eeb5685d2a211c0252ac7884142e503c759500 however it is still pre=
sent.
>> > > I might be a bit hard to hit, but once you run
>> > >
>> > > while true; do sync; sleep 0.3; done
>> > >
>> > > concurrently it is reproducible almost all the time. I have trie=
d to
>> > > understand what is going on but only thing I can see is this cou=
rse
>> > > of action:
>> > >
>> > > ext4_write_dquot
>> > > =A0 ext4_journal_start <- h_buffer_credits =3D 2
>> > > =A0 dquot_commit
>> > > =A0 =A0 v2_write_dquot
>> > > =A0 =A0 =A0 qtree_write_dquot
>> > > =A0 =A0 =A0 =A0 ext4_quota_write
>> > > =A0 =A0 =A0 =A0 =A0 ext4_handle_dirty_metadata =A0 =A0 =A0<- thi=
s takes one block reserved
>> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0for journal
>> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0h_buffer_credits--
>> > > =A0 =A0 v2_write_file_info
>> > > =A0 =A0 =A0 ext4_quota_write
>> > > =A0 =A0 =A0 =A0 ext4_handle_dirty_metadata =A0 =A0 =A0 =A0<- thi=
s takes second block reserved
>> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0for journal
>> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0h_buffer_credits--
>> > > =A0 ext4_journal_stop
>> > >
>> > > However apparently I am missing something, because according to =
the
>> > > backtrace the second call of jbd2_journal_dirty_metadata() may e=
nd up
>> > > with BUG_ON -> J_ASSERT_JH(jh, handle->h_buffer_credits > 0);
>> > >
>> > > So someone else is touching our handle apparently, but I go not =
exacly
>> > > know what is going on. From my simple debugging printk informati=
on I
>> > > have put with before ext4_handle_dirty_metadata() in ext4_quota_=
write()
>> > > we can see:
>> > >
>> > > [ =A0226.450263] ext4_quota_write: len 48, off 5136, type 0 h_re=
f 1
>> > > credits 2
>> > > [ =A0226.458950] ext4_quota_write: len 24, off 8, type 0 h_ref 1=
 credits 0
>> > >
>> > > It is clear someone changed handle between v2_write_dquot() and
>> > > v2_write_file_info() does anyone have idea what is going on ?
>> > =A0 It's simpler than that I believe. ext4_write_dquot() does also
>> > =A0 =A0 =A0 =A0 inode->i_mtime =3D inode->i_ctime =3D CURRENT_TIME=
;
>> > =A0 =A0 =A0 =A0 ext4_mark_inode_dirty(handle, inode);
>> > and that eats another credit. Looking at the comment before
>> > EXT4_QUOTA_TRANS_BLOCKS, we in fact counted with inode and data up=
date but
>> > didn't count with the info update. It's actually a race that we en=
ded up
>> > doing info update in our transaction - someone marked info dirty a=
nd before
>> > he managed to write it, we went in, saw the dirty flag and wrote i=
t for
>> > him. So the attached patch should fix the problem for you.
>> >
>>
>> The patch fixes the problem, you can add
>>
>> Reported-and-tested-by: Lukas Czerner <lczerner@redhat.com>
>>
>> Ted, could you pick this up ASAP ? Also I think this needs to go int=
o
>> stable as well.
> =A0I'll merge it from my tree next week, OK? I don't think there's so=
 much
> hurry as the bug has been there for years and you're the first one to
> report it :).
>
> BTW, I've also created the patch below which can slightly improve
> performance of quotas on ext4. The modification of the inode was
> unnecessary as well... Ted, can you merge this patch? It's independen=
t from
> the previous one.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
> --
> From 51741760fe3682ea37bd264471f897bda9d5bd6d Mon Sep 17 00:00:00 200=
1
> From: Jan Kara <jack@suse.cz>
> Date: Thu, 31 Mar 2011 23:12:14 +0200
> Subject: [PATCH] ext4: Remove unnecessary [cm]time update of quota fi=
le
>
> It is not necessary to update [cm]time of quota file on each quota fi=
le
> write and it wastes journal space and IO throughput with inode writes=
=2E So
> just remove the updating from ext4_quota_write() and only update time=
s when
> quotas are being turned off. Userspace cannot get anything reliable f=
rom
> quota files while they are used by the kernel anyway.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
> =A0fs/ext4/ext4_jbd2.h | =A0 =A04 ++--
> =A0fs/ext4/super.c =A0 =A0 | =A0 16 ++++++++++++++--
> =A02 files changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index d8b992e..3163583 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -86,8 +86,8 @@
>
> =A0#ifdef CONFIG_QUOTA
> =A0/* Amount of blocks needed for quota update - we know that the str=
ucture was
> - * allocated so we need to update only inode+data */
> -#define EXT4_QUOTA_TRANS_BLOCKS(sb) (test_opt(sb, QUOTA) ? 2 : 0)
> + * allocated so we need to update only data block */
> +#define EXT4_QUOTA_TRANS_BLOCKS(sb) (test_opt(sb, QUOTA) ? 1 : 0)

Cool :-)
Yongqiang,
Now we only need to account for 2 (user+group) snapshot quota credits f=
or COW.

> =A0/* Amount of blocks needed for quota insert/delete - we do some bl=
ock writes
> =A0* but inode, sb and group updates are done only once */
> =A0#define EXT4_QUOTA_INIT_BLOCKS(sb) (test_opt(sb, QUOTA) ? (DQUOT_I=
NIT_ALLOC*\
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 1f0acd4..baee1b4 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4608,11 +4608,24 @@ static int ext4_quota_on(struct super_block *=
sb, int type, int format_id,
>
> =A0static int ext4_quota_off(struct super_block *sb, int type)
> =A0{
> + =A0 =A0 =A0 struct inode *inode =3D sb_dqopt(sb)->files[type];
> + =A0 =A0 =A0 handle_t *handle;
> +
> =A0 =A0 =A0 =A0/* Force all delayed allocation blocks to be allocated=
=2E
> =A0 =A0 =A0 =A0 * Caller already holds s_umount sem */
> =A0 =A0 =A0 =A0if (test_opt(sb, DELALLOC))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sync_filesystem(sb);
>
> + =A0 =A0 =A0 /* Update modification times of quota files when usersp=
ace can
> + =A0 =A0 =A0 =A0* start looking at them */
> + =A0 =A0 =A0 handle =3D ext4_journal_start(inode, 1);
> + =A0 =A0 =A0 if (IS_ERR(handle))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 inode->i_mtime =3D inode->i_ctime =3D CURRENT_TIME;
> + =A0 =A0 =A0 ext4_mark_inode_dirty(handle, inode);
> + =A0 =A0 =A0 ext4_journal_stop(handle);
> +
> +out:
> =A0 =A0 =A0 =A0return dquot_quota_off(sb, type);
> =A0}
>
> @@ -4708,9 +4721,8 @@ out:
> =A0 =A0 =A0 =A0if (inode->i_size < off + len) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0i_size_write(inode, off + len);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4_I(inode)->i_disksize =3D inode->i=
_size;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_mark_inode_dirty(handle, inode);
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 inode->i_mtime =3D inode->i_ctime =3D CURRENT_TIME;
> - =A0 =A0 =A0 ext4_mark_inode_dirty(handle, inode);
> =A0 =A0 =A0 =A0mutex_unlock(&inode->i_mutex);
> =A0 =A0 =A0 =A0return len;
> =A0}
> --
> 1.7.1
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
