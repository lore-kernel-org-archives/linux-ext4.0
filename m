From: Younger Liu <younger.liu@huawei.com>
Subject: Re: [PATCH] jbd2: invalidate handle if jbd2_journal_restart() fails
Date: Wed, 3 Jul 2013 20:36:53 +0800
Message-ID: <51D41AE5.5080701@huawei.com>
References: <20130623173628.GC16620@thunk.org> <1372009468-11651-1-git-send-email-tytso@mit.edu> <51C965F2.3090704@huawei.com> <20130629234648.GA4560@thunk.org> <51D4177C.6020307@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	<jbacik@fusionio.com>, Jan Kara <jack@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:18125 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab3GCMm4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Jul 2013 08:42:56 -0400
In-Reply-To: <51D4177C.6020307@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013/7/3 20:22, Younger Liu wrote:
> On 2013/6/30 7:46, Theodore Ts'o wrote:
>> On Tue, Jun 25, 2013 at 05:42:10PM +0800, Younger Liu wrote:
>>> If jbd2__journal_restart fails, handle->h_transaction may be NULL.
>>> So we should check handle->h_transaction before 
>>> "journal = transaction->t_journal", Right?
>>
>> Good point, yes.  Here's a new version of the patch which I have in my tree.
>>
>>      	    	  	       	       	      - Ted
>>
>> >From fd8d369f9ad921eb6dc5c56e87e4c6d6106bad56 Mon Sep 17 00:00:00 2001
>> From: Theodore Ts'o <tytso@mit.edu>
>> Date: Sun, 23 Jun 2013 12:59:01 -0400
>> Subject: [PATCH] jbd2: invalidate handle if jbd2_journal_restart() fails
>>
>> If jbd2_journal_restart() fails the handle will have been disconnected
>> from the current transaction.  In this situation, the handle must not
>> be used for for any jbd2 function other than jbd2_journal_stop().
>> Enforce this with by treating a handle which has a NULL transaction
>> pointer as an aborted handle, and issue a kernel warning if
>> jbd2_journal_extent(), jbd2_journal_get_write_access(),
>> jbd2_journal_dirty_metadata(), etc. is called with an invalid handle.
>>
>> This commit also fixes a bug where jbd2_journal_stop() would trip over
>> a kernel jbd2 assertion check when trying to free an invalid handle.
>>
>> Also move the responsibility of setting current->journal_info to
>> start_this_handle(), simplifying the three users of this function.
>>
>> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>> Reported-by: Younger Liu <younger.liu@huawei.com>
>> Cc: Jan Kara <jack@suse.cz>
...
> 
> Thanks for your patch.
> I test the patch in ocfs2 file system,  the results look fine.
> 
> # mkfs.ocfs2 -b 4K -C 32K -T datafiles /dev/sdc
> ...(jounral size is 32M)
> # mount.ocfs2 /dev/sdc /mnt/ocfs2/
> # touch /mnt/ocfs2/1.vhd
> # fallocate -o 0 -l 400G /mnt/ocfs2/1.vhd
> fallocate: /mnt/ocfs2/1.vhd: fallocate failed: Cannot allocate memory
> # tail -f /var/log/messages
> Jul  3 19:40:58 linux-KooNDD kernel: [ 7302.646408] JBD: Ignoring recovery information on journal
> Jul  3 19:40:58 linux-KooNDD kernel: [ 7302.667908] ocfs2: Mounting device (65,160) on (node 10, slot 0) with ordered data mode.
> Jul  3 19:41:19 linux-KooNDD ovsdb-server: 00129|monitor|INFO|Monitor: send HEARTBEART_MESSGE again count = 71400
> Jul  3 19:41:54 linux-KooNDD ovs-brcompatd: 00132|monitor|INFO|Monitor: send HEARTBEART_MESSGE again count = 73200
> Jul  3 19:42:08 linux-KooNDD kernel: [ 7372.278591] JBD: fallocate wants too many credits (2051 > 2048)
> Jul  3 19:42:08 linux-KooNDD kernel: [ 7372.278597] (fallocate,6438,0):__ocfs2_extend_allocation:709 ERROR: status = -12
> Jul  3 19:42:08 linux-KooNDD kernel: [ 7372.278603] (fallocate,6438,0):ocfs2_allocate_unwritten_extents:1504 ERROR: status = -12
> Jul  3 19:42:08 linux-KooNDD kernel: [ 7372.278607] (fallocate,6438,0):__ocfs2_change_file_space:1955 ERROR: status = -12
> Jul  3 19:42:20 linux-KooNDD ovsdb-server: 00130|monitor|INFO|Monitor: send HEARTBEART_MESSGE again count = 72000
> Jul  3 19:42:20 linux-KooNDD ovsdb-server: 00131|vlog|INFO|opened log file /var/log/openvswitch//ovsdb-server.log
> ^C
> 
> If fallocate wants too many journal space, it would issue a kernel warning.
> 
> # cat test.sh
> start=0
> end=500
> while [ ${start} -le ${end} ]
> do
>         echo ${start}
>         touch /mnt/ocfs2/${start}.vhd
>         fallocate -o 0 -l ${start}G /mnt/ocfs2/${start}.vhd
>         ls -l /mnt/ocfs2/
>         du -h /mnt/ocfs2/
>         rm /mnt/ocfs2/${start}.vhd
>         sleep 2
>         start=$((${start}+5))
> done
> #sh test.sh
> 
> the results are fine too.
> 
> Tested-by: Younger Liu <younger.liu@oracle.com>
> 
> 					-- Younger
Sorry, I made a mistake, email is not right. 
It should be:
Tested-by: Younger Liu <younger.liu@huawei.com>

> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> .
> 


