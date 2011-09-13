From: Valerie Aurora <val@vaaconsulting.com>
Subject: Re: [BUG] ext3: cannot unfreeze a filesystem due to a deadlock
Date: Mon, 12 Sep 2011 20:00:43 -0700
Message-ID: <CAD-Xujm80u_DeFd-edO7RL_6OozZ7mWsrX7auxVMtNbb0LZBOw@mail.gmail.com>
References: <20110907122929.3715.61FB500B@jp.fujitsu.com>
	<20110907173444.GF7725@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49146 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab1IMDAp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Sep 2011 23:00:45 -0400
In-Reply-To: <20110907173444.GF7725@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 7, 2011 at 10:34 AM, Jan Kara <jack@suse.cz> wrote:
> =A0Hello,
>
> =A0Thanks for report!
>
> On Wed 07-09-11 12:29:30, Masayoshi MIZUMA wrote:
>> When I checked the freeze feature for ext3 filesystem using fsfreeze
>> command at 3.1.0-rc4, I think the following deadlock problem happene=
d.
>>
>> How to reproduce:
>> =A0# mkfs -t ext3 /dev/sdd1
>> =A0# mount /dev/sdd1 /MNT
>> =A0# ./fsstress -d /MNT/tmp -n 10 -p 1000 > /dev/null 2>&1 &
>> =A0# fsfreeze -f /MNT
>> =A0# fsfreeze -u /MNT
>>
>> =A0If this deadlock is reproduced, "fsfreeze -u /MNT" does not retur=
n.
>>
>> The detail of deadlock:
>> o [flush-8:16:1523]
>> =A0 wb_do_writeback
>> =A0 =A0wb_writeback
>> =A0 =A0...
>> =A0 =A0 =A0ext3_journalled_writepage
>> =A0 =A0 =A0 journal_start
>> =A0 =A0 =A0 =A0start_this_handle
>> =A0 =A0 =A0 =A0# waiting until journal->j_barrier_count turns 0...
>> =A0 =A0 =A0 =A0# j_barrier_count was incremented by journal_lock_upd=
ates()
>> =A0 =A0 =A0 =A0# via ext3_freeze().
>>
>> o [fsstress:2673]
>> =A0 sys_sync
>> =A0 =A0sync_filesystems
>> =A0 =A0 iterate_supers
>> =A0 =A0 =A0down_read(sb->s_umount)
>> =A0 =A0 =A0sync_one_sb
>> =A0 =A0 =A0 __sync_filesystem
>> =A0 =A0 =A0 =A0writeback_inodes_sb
>> =A0 =A0 =A0 =A0 writeback_inodes_sb_nr
>> =A0 =A0 =A0 =A0 =A0wait_for_completion
>> =A0 =A0 =A0 =A0 =A0 wait_for_common
>> =A0 =A0 =A0 =A0 =A0 # waiting for completion of [flush-8:16:1523]...
>>
>> o [fsfreeze:2749]
>> =A0 sys_ioctl
>> =A0 =A0do_vfs_ioctl
>> =A0 =A0 thaw_super
>> =A0 =A0 # waiting for down_write(sb->s_umount)...
>> =A0 =A0 # [fsfreeze:2673] did down_read(sb->s_umount).
> =A0Yes, this is a classical deadlock that can happen for any filesyst=
em. The
> problem is flusher thread holds s_umount semaphore (either directly, =
or as
> in your case, indirectly via blocked sync) and tries to do some IO wh=
ich
> blocks on frozen filesystem. It's particularly easy to hit for ext3 b=
ecause
> it doesn't do vfs_check_frozen() checks but all other filesystems hav=
e the
> race window as well. Val Henson is working on fixing the problem - sh=
e even
> has some first version of patches I believe.

Yes, if the bug reporter could test the patches I just sent out, that
would be great.  I'm happy to resend privately.  Thanks!

-VAL
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
