From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: [RFC PATCH 1/4] ext4: DIO get_block code cleanup
Date: Mon, 28 Dec 2009 22:25:57 -0800
Message-ID: <5df78e1d0912282225q45b3c3bdo177660d5efe51238@mail.gmail.com>
References: <5df78e1d0912151737v3be07575k638edf744e59ee2f@mail.gmail.com>
	 <20091226070303.GH32757@thunk.org>
	 <5df78e1d0912270124k4d20a1afgc2237fe9b29b24e9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michael Rubin <mrubin@google.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:36279 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbZL2G0B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Dec 2009 01:26:01 -0500
Received: from kpbe11.cbf.corp.google.com (kpbe11.cbf.corp.google.com [172.25.105.75])
	by smtp-out.google.com with ESMTP id nBT6Q0WP020304
	for <linux-ext4@vger.kernel.org>; Mon, 28 Dec 2009 22:26:00 -0800
Received: from pwi14 (pwi14.prod.google.com [10.241.219.14])
	by kpbe11.cbf.corp.google.com with ESMTP id nBT6PTIK004420
	for <linux-ext4@vger.kernel.org>; Tue, 29 Dec 2009 00:25:59 -0600
Received: by pwi14 with SMTP id 14so7598399pwi.33
        for <linux-ext4@vger.kernel.org>; Mon, 28 Dec 2009 22:25:57 -0800 (PST)
In-Reply-To: <5df78e1d0912270124k4d20a1afgc2237fe9b29b24e9@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On Sun, Dec 27, 2009 at 1:24 AM, Jiaying Zhang <jiayingz@google.com> wr=
ote:
> Hi Ted,
>
> Thanks a lot for the feedback on Christmas and happy holiday!
>
> On Fri, Dec 25, 2009 at 11:03 PM, =A0<tytso@mit.edu> wrote:
>> On Tue, Dec 15, 2009 at 05:37:53PM -0800, Jiaying Zhang wrote:
>>> ext4: dio get_block code cleanup in prepare for it to be used by bu=
ffer write
>>>
>>> Renaming the dio block allocation flags, variables and functions
>>> introduced in Mingming's "Direct IO for holes and fallocate"
>>> patches so that they can be used by ext4 buffer write as well.
>>>
>>> Signed-off-by: Jiaying Zhang <jiayingz@google.com>
>>
>> Hi Jiaying,
>>
>> Merry Christmas!
>>
>> Sorry, between trying to prepare patches for the 2.6.33 merge window=
,
>> and closing out my current position at the Linux Foundation, and the
>> resulting job transition, this has fallen through the cracks. =A0I'v=
e
>> started looking at your patch now. =A0 A couple of comments so far.
>>
>> 1) The patches were white-space damaged, so applying them is a bit
>> difficult. =A0I gave up entirely on patch #4, which hopefully is a
>> mechnical only patch, but it's also one which is apparently only a
>> cleanup.
>
> Really sorry about this. I guess my email client turned tab into spac=
es.
> The fourth patch is only code moving around. As you said, you can eas=
ily
> regenerate it later so I think we can just leave it out during the re=
view.
>
>>
>> Patch #1 had a combination of mechanical changes (i.e., naming of
>> variables and constants) as well as some non-mechnical changes.
>> Especially in the case of patch #4, when large chunks of code are
>> being moved around, the patch which mechnical changes is very likely
>> to break if other patches are applied (or reverted) compared to
>> whatever version the patch was based off of. =A0If the mechnical cha=
nges
>> are separated out (and clearly described in the commits), then I can
>> easily regenerate the mechnical changes, and not worry about
>> accidentally dropping changes.
>
> I intended to have the first patch only include the mechanical change=
s,
> but left some other changes in it after code rebase. I will move thos=
e
> changes to the second patch in the next version.
>
>>
>> 2) In the first patch, in ext4_sync_file() in fs/ext4/fsync.c, the
>> call to flush_aio_dio_completed_IO() is renamed to
>> flush_completed_IO(). =A0But then in the second patch, a second call=
 to
>> flush_completed_IO() is added at the end of ext4_sync_file(). =A0Tha=
t
>> doesn't look right to me.
>
> The reason I added another flush_completed_IO() at the end of
> ext4_sync_file is to finish uninitialized-to-initialized extent conve=
rsion
> for any buffer writes that may be generated during sync_mapping_buffe=
rs.
> The completed_io_list may not be empty at this time because
> ext4_end_io_buffer_write only queues io_end work that is processed
> by ext4_end_io_work later. Is there any problem that you think this
> change may introduce?
>
I realized that the later sync_mapping_buffers in ext4_sync_file
should only write metadata buffers after reading the function again.
So you are right. We don't need the send flush_completed_IO().

>>
>> I need to look at the code more closely, which I will do later. =A0I=
n
>> the mean time, I've added the first three patches which you sent to
>> the unstable portion of the ext4 patch queue. =A0When run against th=
e
>> xfsqa regression test suite, it quickly shows a failure:
>>
>> BUG: unable to handle kernel NULL pointer dereference at 00000004
>> IP: [<c0262b58>] __journal_remove_journal_head+0xf/0xcf
>> *pdpt =3D 0000000019b91001 *pde =3D 0000000000000000
>> Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
>> last sysfs file:
>> Modules linked in:
>>
>> Pid: 6536, comm: jbd2/sdb-8 Not tainted 2.6.32-06814-g26716e4 #225 /
>> EIP: 0060:[<c0262b58>] EFLAGS: 00010246 CPU: 0
>> EIP is at __journal_remove_journal_head+0xf/0xcf
>> EAX: de570e40 EBX: 00000000 ECX: 00000000 EDX: de570e40
>> ESI: de570e40 EDI: 00000002 EBP: d8a94e5c ESP: d8a94e54
>> =A0DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>> Process jbd2/sdb-8 (pid: 6536, ti=3Dd8a94000 task=3Ddf3bbf90 task.ti=
=3Dd8a94000)
>> Stack:
>> =A0de570e40 de570e40 d8a94e68 c0262c87 d4b7c140 d8a94e8c c025fe4b 00=
000001
>> <0> d8a94e9c d4b7c140 d8f630c0 00000000 cf6ba540 d8a94e9c d8a94eac c=
025fed9
>> <0> dbc50d80 dbc50d80 00000000 dc754800 00000000 dc754800 d8a94f5c c=
025e20a
>> Call Trace:
>> =A0[<c0262c87>] ? jbd2_journal_remove_journal_head+0x1e/0x2d
>> =A0[<c025fe4b>] ? journal_clean_one_cp_list+0x68/0xbd
>> =A0[<c025fed9>] ? __jbd2_journal_clean_checkpoint_list+0x39/0x7b
>> =A0[<c025e20a>] ? jbd2_journal_commit_transaction+0x2c5/0x1173
>> =A0[<c017bb17>] ? trace_hardirqs_off+0xb/0xd
>> =A0[<c01631ec>] ? try_to_del_timer_sync+0x5e/0x66
>> =A0[<c062eae5>] ? _spin_unlock_irqrestore+0x41/0x4d
>> =A0[<c017d019>] ? trace_hardirqs_on+0xb/0xd
>> =A0[<c01631ec>] ? try_to_del_timer_sync+0x5e/0x66
>> =A0[<c01635bb>] ? del_timer_sync+0x78/0x88
>> =A0[<c0263b66>] ? kjournald2+0x116/0x309
>> =A0[<c016d9b0>] ? autoremove_wake_function+0x0/0x34
>> =A0[<c0263a50>] ? kjournald2+0x0/0x309
>> =A0[<c016d785>] ? kthread+0x64/0x69
>> =A0[<c016d721>] ? kthread+0x0/0x69
>> =A0[<c012567b>] ? kernel_thread_helper+0x7/0x10
>> Code: f6 ff eb 15 89 d8 e8 97 91 f7 ff eb 0c e8 71 ff ff ff 89 da e8=
 8c 3e f8 ff 5b 5d c3 55 89 e5 56 53 0f 1f 44 00 00 8b 58 24 89 c6 <83>=
 7b 04 00 79 04 0f 0b eb fe f0 ff 40 34 83 7b 04 00 0f 85 a1
>> EIP: [<c0262b58>] __journal_remove_journal_head+0xf/0xcf SS:ESP 0068=
:d8a94e54
>> CR2: 0000000000000004
>>
>
> From the stack trace, the problem seems to be caused by
> the use of bh->b_private to hold end_io in my patch. I noticed
> that b_private is used by jdb2 to hold journal handle so the
> introduced change is disabled if the ext4 is mounted with
> data=3Djournal. As I understand, with data=3Dordered, any buffer
> heads held in the journal should be metadata. But I guess either
> this is not sure or there is some case where I also changed
> b_private field for metadata write.

I had another look at my patch and found that there might be some
case that we still call ext4_end_io_buffer_write() even with
data=3Djournal mode. Could you try the patch below on top of
my previous three patches and see whether it fixes the problem?
Or even better, I would like to run the xfsqa test myself if you
could point me to the instructions on how to get and run it.

Thanks a lot!

 fs/ext4/extents.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: git-ext4/fs/ext4/extents.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- git-ext4.orig/fs/ext4/extents.c     2009-12-15 16:03:15.000000000 -=
0800
+++ git-ext4/fs/ext4/extents.c  2009-12-28 22:17:12.000000000 -0800
@@ -3052,7 +3052,8 @@ ext4_ext_handle_uninitialized_extents(ha
                        io->flag =3D EXT4_IO_UNWRITTEN;
                else
                        EXT4_I(inode)->i_state |=3D EXT4_STATE_DIO_UNWR=
ITTEN;
-               set_buffer_uninit(bh_result);
+               if (test_opt(inode->i_sb, DIOREAD_NOLOCK))
+                       set_buffer_uninit(bh_result);
                goto out;
        }
        /* IO end_io complete, convert the filled extent to written */
@@ -3305,7 +3306,8 @@ int ext4_ext_get_blocks(handle_t *handle
                                EXT4_I(inode)->i_state |=3D
                                        EXT4_STATE_DIO_UNWRITTEN;;
                }
-               set_buffer_uninit(bh_result);
+               if (test_opt(inode->i_sb, DIOREAD_NOLOCK))
+                       set_buffer_uninit(bh_result);
        }
        err =3D ext4_ext_insert_extent(handle, inode, path, &newex, fla=
gs);
        if (err) {

Jiaying

>
> Jiaying
>
>> Removing your three patches makes the failure go away. =A0I'll analy=
ze
>> this some more later this weekend.
>>
>> Best regards,
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
