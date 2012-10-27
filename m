From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Date: Sat, 27 Oct 2012 17:42:07 -0500
Message-ID: <508C633F.4070100@redhat.com>
References: <874nllxi7e.fsf_-_@spindle.srvr.nix> <87pq48nbyz.fsf_-_@spindle.srvr.nix> <508AF3FA.4020506@redhat.com> <87wqydx957.fsf@spindle.srvr.nix> <20121026205618.GC8614@thunk.org> <87objpx84k.fsf@spindle.srvr.nix> <20121026211542.GE8614@thunk.org> <87haphx76u.fsf@spindle.srvr.nix> <20121027002258.GB31030@thunk.org> <873910xevu.fsf@spindle.srvr.nix> <20121027175534.GA7783@thunk.org> <87fw4zzra3.fsf@spindle.srvr.nix> <508C4FE5.1030102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
To: Nix <nix@esperi.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <508C4FE5.1030102@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/27/12 4:19 PM, Eric Sandeen wrote:
> On 10/27/12 1:47 PM, Nix wrote:
>> On 27 Oct 2012, Theodore Ts'o said:
>>
>>> On Sat, Oct 27, 2012 at 01:45:25PM +0100, Nix wrote:
>>>> Ah! it's turned on by journal_async_commit. OK, that alone argues
>>>> against use of journal_async_commit, tested or not, and I'd not have
>>>> turned it on if I'd noticed that.
>>>>
>>>> (So, the combinations I'll be trying for effect on this bug are:
>>>>
>>>>  journal_async_commit (as now)
>>>>  journal_checksum
>>>>  none
>>>
>>> Can you also check and see whether the presence or absence of
>>> "nobarrier" makes a difference?
>>
>> Done. (Also checked the effect of your patches posted earlier this week:
>> no effect, I'm afraid, certainly not under the fails-even-on-3.6.1 test
>> I was carrying out, umount -l'ing /var as the very last thing I did
>> before /sbin/reboot -f.)
>>
>> nobarrier makes a difference that I, at least, did not expect:
>>
>> [no options]                    No corruption
>>
>> nobarrier                       No corruption
>>
>>           journal_checksum      Corruption
>>                                 Corrupted transaction, journal aborted
>>                                 
>> nobarrier,journal_checksum      Corruption
>>                                 Corrupted transaction, journal aborted
>>
>>           journal_async_commit  Corruption
>>                                 Corrupted transaction, journal aborted
>>
>> nobarrier,journal_async_commit  Corruption
>>                                 No corrupted transaction or aborted journal
> 
> That's what we needed.  Woulda been great a few days ago ;)
> 
> In my testing journal_checksum is broken, and my bisection seems to
> implicate
> 
> commit 119c0d4460b001e44b41dcf73dc6ee794b98bd31
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Mon Feb 6 20:12:03 2012 -0500
> 
>     ext4: fold ext4_claim_inode into ext4_new_inode
>     
> as the culprit.  I haven't had time to look into why, yet.

It looks like the inode_bitmap_bh is being modified outside a transaction:

                ret2 = ext4_test_and_set_bit(ino, inode_bitmap_bh->b_data);

It needs a get_write_access / handle_dirty_metadata pair around it.

A hacky patch like this seems to work but it was done 5mins before I have
to be out the door to dinner so it probably needs cleanup or at least
scrutiny.

[PATCH] ext4: fix unjournaled inode bitmap modification

commit 119c0d4460b001e44b41dcf73dc6ee794b98bd31 modified this function
such that the inode bitmap was being modified outside a transaction,
which could lead to corruption, and was discovered when journal_checksum
found a bad checksum in the journal.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

--- ialloc.c.reverted2	2012-10-27 17:31:20.351537073 -0500
+++ ialloc.c	2012-10-27 17:40:18.643553576 -0500
@@ -669,6 +669,10 @@
 		inode_bitmap_bh = ext4_read_inode_bitmap(sb, group);
 		if (!inode_bitmap_bh)
 			goto fail;
+		BUFFER_TRACE(inode_bitmap_bh, "get_write_access");
+		err = ext4_journal_get_write_access(handle, inode_bitmap_bh);
+		if (err)
+			goto fail;
 
 repeat_in_this_group:
 		ino = ext4_find_next_zero_bit((unsigned long *)
@@ -690,6 +694,10 @@
 		ino++;		/* the inode bitmap is zero-based */
 		if (!ret2)
 			goto got; /* we grabbed the inode! */
+		BUFFER_TRACE(inode_bitmap_bh, "call ext4_handle_dirty_metadata");
+		err = ext4_handle_dirty_metadata(handle, NULL, inode_bitmap_bh);
+		if (err)
+			goto fail;
 		if (ino < EXT4_INODES_PER_GROUP(sb))
 			goto repeat_in_this_group;
 	}




> -Eric
> 
>> I didn't expect the last case at all, and it adequately explains why you
>> are mostly seeing corrupted journal messages in your tests but I was
>> not. It also explains why when I saw this for the first time I was able
>> to mount the resulting corrupted filesystem read-write and corrupt it
>> further before I noticed that anything was wrong.
>>
>> It is also clear that journal_checksum and all that relies on it is
>> worse than useless right now, as Eric reported while I was testing this.
>> It should probably be marked CONFIG_BROKEN in future 3.[346].* stable
>> kernels, if CONFIG_BROKEN existed anymore, which it doesn't.
>>
>> It's a shame journal_async_commit depends on a broken feature: it might
>> be notionally unsafe but on some of my systems (without nobarrier or
>> flashy caching controllers) it was associated with a noticeable speedup
>> of metadata-heavy workloads -- though that was way back in 2009...
>> however, "safety first" definitely applies in this case.
>>
> 
