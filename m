From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: After unlinking a large file on ext4, the process stalls for a long time
Date: Tue, 5 Aug 2014 00:55:14 +0200
Message-ID: <6910CF48-15F8-4218-8881-06899D7C56A5@dilger.ca>
References: <53C687B1.30809@free.fr> <21446.38705.190786.631403@quad.stoffel.home> <53C6B38A.3000100@free.fr> <59C3F41A-6AFD-418E-BCE6-2361B8140D9A@dilger.ca> <53C7A5CA.4050903@free.fr> <alpine.LFD.2.00.1407171238060.2312@localhost.localdomain> <53C7B0B7.9030007@free.fr> <20140717133755.GN1491@thunk.org> <53C7F4C2.6070804@free.fr> <alpine.LFD.2.00.1407181127440.12453@localhost.localdomain> <53DF9918.3010206@free.fr>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?Q?Luk=C3=A1=C5=A1_Czerner?= <lczerner@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Mason <mpeg.blue@free.fr>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:37511 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaHDWzT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2014 18:55:19 -0400
Received: by mail-wg0-f49.google.com with SMTP id k14so108234wgh.32
        for <linux-ext4@vger.kernel.org>; Mon, 04 Aug 2014 15:55:18 -0700 (PDT)
In-Reply-To: <53DF9918.3010206@free.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It would be possible to optimize mb_free_blocks() by having it
clear a whole word at a time instead of a series if bits.=20

I thought that was done already, but it doesn't appear to be the case.
Also, it isn't clear that the bit "normalization" is needed anymore.
This was done back in the aniceint times when the buddy bitmaps were st=
ored on disk instead of being regenerated only at mount time.=20

Cheers, Andreas

> On Aug 4, 2014, at 16:30, Mason <mpeg.blue@free.fr> wrote:
>=20
>> On 18/07/2014 11:29, Luk=C3=A1=C5=A1 Czerner wrote:
>>=20
>> Mason wrote:
>>=20
>>> Theodore Ts'o wrote:
>>>=20
>>>> Mason wrote:
>>>>=20
>>>>> unlink("/mnt/hdd/xxx")                  =3D 0 <111.479283>
>>>>>=20
>>>>> 0.01user 111.48system 1:51.99elapsed 99%CPU (0avgtext+0avgdata 77=
2maxresident)k
>>>>> 0inputs+0outputs (0major+434minor)pagefaults 0swaps
>>>>=20
>>>> ... and we're CPU bound inside the kernel.
>>>>=20
>>>> Can you run perf so we can see exactly where we're spending the CP=
U?
>>>> You're not using a journal, so I'm pretty sure what you will find =
is
>>>> that we're spending all of our time in mb_free_blocks(), when it i=
s
>>>> updating the internal mballoc buddy bitmaps.
>>>>=20
>>>> With a journal, this work done by mb_free_blocks() is hidden in th=
e
>>>> kjournal thread, and happens after the commit is completed, so it
>>>> won't block other file system operations (other than burning some
>>>> extra CPU on one of the multiple cores available on a typical x86
>>>> CPU).
>>>>=20
>>>> Also, I suspect the CPU overhead is *much* less on an x86 CPU, whi=
ch
>>>> has native bit test/set/clear instructions, whereas the MIPS
>>>> architecture was designed by Prof. Hennessy at Stanford, who was a
>>>> doctrinaire RISC fanatic, so there would be no bitop instructions.
>=20
> I've attached the output of "mips-linux-gnu-objdump -xd mballoc.o"
> in case someone wants to peek at the generated code.
>=20
>>>> Even though I'm pretty sure what we'll find, knowing exactly *wher=
e*
>>>> in mb_free_blocks() or the function it calls would be helpful in
>>>> knowing what we need to optimize.  So if you could try using perf
>>>> (assuming that the perf is supported MIPS; not sure if it does) th=
at
>>>> would be really helpful.
>=20
> How do you get perf to tell you where in mb_free_blocks we are spendi=
ng
> the most time?
>=20
>>> What command-line do you suggest I run to get the output you expect=
?
>>=20
>> If perf works on your system you can record data with
>>=20
>> perf record -g ./test file <size>
>>=20
>> and then report with
>>=20
>> perf report --stdio
>>=20
>> That should yield some interesting information about where we spend
>> the most time in kernel.
>=20
> I've no idea why, but the unlink operation, which used to take
> 111 seconds to run, now only takes 53...
>=20
> Anyway, here is the requested output.
>=20
> # time perf record -g foo /mnt/hdd/xxx 300
> [ perf record: Woken up 8 times to write data ]
> [ perf record: Captured and wrote 1.909 MB perf.data (~83406 samples)=
 ]
> 0.04user 0.08system 0:53.54elapsed 0%CPU (0avgtext+0avgdata 3616maxre=
sident)k
> 0inputs+0outputs (0major+984minor)pagefaults 0swaps
>=20
> # perf report --stdio > report.txt
> (Complete report attached as report.txt.xz)
>=20
> What can I do to improve the latency of unlinking large files?
> Would sparse_super2 help at all?
>=20
>=20
> # Events: 14K cycles
> #
> # Overhead  Command      Shared Object                        Symbol
> # ........  .......  .................  ............................
> #
>    33.94%      foo  [kernel.kallsyms]  [k] mb_free_blocks
>               |
>               --- mb_free_blocks
>                   ext4_free_blocks
>                   ext4_ext_rm_leaf
>                   ext4_ext_truncate
>                   ext4_truncate
>                   ext4_evict_inode
>                   evict
>                   do_unlinkat
>                   stack_done
>=20
>    21.11%      foo  [kernel.kallsyms]  [k] __find_get_block
>               |
>               --- __find_get_block
>                  |         =20
>                  |--99.94%-- ext4_free_blocks
>                  |          ext4_ext_rm_leaf
>                  |          ext4_ext_truncate
>                  |          ext4_truncate
>                  |          ext4_evict_inode
>                  |          evict
>                  |          do_unlinkat
>                  |          stack_done
>                   --0.06%-- [...]
>=20
>     8.33%      foo  [kernel.kallsyms]  [k] radix_tree_lookup_slot
>               |
>               --- radix_tree_lookup_slot
>                   find_get_page
>                   __find_get_block_slow
>                   __find_get_block
>                   ext4_free_blocks
>                   ext4_ext_rm_leaf
>                   ext4_ext_truncate
>                   ext4_truncate
>                   ext4_evict_inode
>                   evict
>                   do_unlinkat
>                   stack_done
>=20
>     6.99%      foo  [kernel.kallsyms]  [k] mb_find_buddy
>               |
>               --- mb_find_buddy
>                   mb_free_blocks
>                   ext4_free_blocks
>                   ext4_ext_rm_leaf
>                   ext4_ext_truncate
>                   ext4_truncate
>                   ext4_evict_inode
>                   evict
>                   do_unlinkat
>                   stack_done
>=20
>     4.21%      foo  [kernel.kallsyms]  [k] trace_preempt_off
>               |
>               --- trace_preempt_off
>                  |         =20
>                  |--99.99%-- __find_get_block
>                  |          ext4_free_blocks
>                  |          ext4_ext_rm_leaf
>                  |          ext4_ext_truncate
>                  |          ext4_truncate
>                  |          ext4_evict_inode
>                  |          evict
>                  |          do_unlinkat
>                  |          stack_done
>                   --0.01%-- [...]
>=20
>     4.19%      foo  [kernel.kallsyms]  [k] ext4_free_blocks
>               |
>               --- ext4_free_blocks
>                   ext4_ext_rm_leaf
>                   ext4_ext_truncate
>                   ext4_truncate
>                   ext4_evict_inode
>                   evict
>                   do_unlinkat
>                   stack_done
>=20
>     4.14%      foo  [kernel.kallsyms]  [k] sub_preempt_count
>               |
>               --- sub_preempt_count
>                  |         =20
>                  |--99.69%-- __find_get_block
>                  |          ext4_free_blocks
>                  |          ext4_ext_rm_leaf
>                  |          ext4_ext_truncate
>                  |          ext4_truncate
>                  |          ext4_evict_inode
>                  |          evict
>                  |          do_unlinkat
>                  |          stack_done
>                   --0.31%-- [...]
>=20
>     3.97%      foo  [kernel.kallsyms]  [k] __find_get_block_slow
>               |
>               --- __find_get_block_slow
>                   __find_get_block
>                   ext4_free_blocks
>                   ext4_ext_rm_leaf
>                   ext4_ext_truncate
>                   ext4_truncate
>                   ext4_evict_inode
>                   evict
>                   do_unlinkat
>                   stack_done
>=20
>     3.53%      foo  [kernel.kallsyms]  [k] __rcu_read_unlock
>               |
>               --- __rcu_read_unlock
>                  |         =20
>                  |--100.00%-- find_get_page
>                  |          __find_get_block_slow
>                  |          __find_get_block
>                  |          ext4_free_blocks
>                  |          ext4_ext_rm_leaf
>                  |          ext4_ext_truncate
>                  |          ext4_truncate
>                  |          ext4_evict_inode
>                  |          evict
>                  |          do_unlinkat
>                  |          stack_done
>                   --0.00%-- [...]
>=20
>     3.26%      foo  [kernel.kallsyms]  [k] trace_preempt_on
>               |
>               --- trace_preempt_on
>                   sub_preempt_count
>                  |         =20
>                  |--100.00%-- __find_get_block
>                  |          ext4_free_blocks
>                  |          ext4_ext_rm_leaf
>                  |          ext4_ext_truncate
>                  |          ext4_truncate
>                  |          ext4_evict_inode
>                  |          evict
>                  |          do_unlinkat
>                  |          stack_done
>                   --0.00%-- [...]
>=20
>     2.06%      foo  [kernel.kallsyms]  [k] find_get_page
>               |
>               --- find_get_page
>                  |         =20
>                  |--100.00%-- __find_get_block_slow
>                  |          __find_get_block
>                  |          ext4_free_blocks
>                  |          ext4_ext_rm_leaf
>                  |          ext4_ext_truncate
>                  |          ext4_truncate
>                  |          ext4_evict_inode
>                  |          evict
>                  |          do_unlinkat
>                  |          stack_done
>                   --0.00%-- [...]
>=20
>     1.39%      foo  [kernel.kallsyms]  [k] add_preempt_count
>               |
>               --- add_preempt_count
>                  |         =20
>                  |--99.99%-- __find_get_block
>                  |          ext4_free_blocks
>                  |          ext4_ext_rm_leaf
>                  |          ext4_ext_truncate
>                  |          ext4_truncate
>                  |          ext4_evict_inode
>                  |          evict
>                  |          do_unlinkat
>                  |          stack_done
>                   --0.01%-- [...]
>=20
>     1.26%      foo  [kernel.kallsyms]  [k] __rcu_read_lock
>               |
>               --- __rcu_read_lock
>                   find_get_page
>                   __find_get_block_slow
>                   __find_get_block
>                   ext4_free_blocks
>                   ext4_ext_rm_leaf
>                   ext4_ext_truncate
>                   ext4_truncate
>                   ext4_evict_inode
>                   evict
>                   do_unlinkat
>                   stack_done
>=20
> --=20
> Regards.
>=20
> <report.txt.xz>
> <mballoc.dump.xz>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
