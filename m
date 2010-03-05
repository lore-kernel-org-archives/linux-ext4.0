From: Enrik Berkhan <Enrik.Berkhan@ge.com>
Subject: Re: possible ext4 related deadlock
Date: Fri, 05 Mar 2010 14:56:28 +0100
Message-ID: <4B910D8C.30301@ge.com>
References: <4B754E5E.603@ge.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060600010305080500040600"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from exprod5og101.obsmtp.com ([64.18.0.141]:46322 "EHLO
	exprod5og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab0CEN6j (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Mar 2010 08:58:39 -0500
In-Reply-To: <4B754E5E.603@ge.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060600010305080500040600
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Enrik Berkhan wrote:
> currently we're experiencing some process hangs that seem to be 
> ext4-related. (Kernel 2.6.28.10-Blackfin, i.e. with Analog Devices
> patches including some memory management changes for NOMMU.)
> 
> The situation is as follows:
> 
> We have two threads writing to an ext4-filesystem. After several hours 
> and accross about 20 systems there happens one hang where
> (reconstructed from Alt-SysRq-W output):
> 
> 1. pdflush waits in start_this_handle
> 2. kjournald2 waits in jdb2_journal_commit_transaction
> 3. thread 1 waits in start_this_handle
> 4. thread 2 waits in
>   ext4_da_write_begin
>     (start_this_handle succeeded)
>     grab_cache_page_write_begin
>       __alloc_pages_internal
>         try_to_free_pages
>           do_try_to_free_pages
>             congestion_wait
> 
> Actually, thread 2 shouldn't be completely blocked, because 
> congestion_wait has a timeout if I understand the code correctly. 
> Unfortunately, I pressed Alt-SysRq-W only once when having a chance to 
> reproduce the problem on a test system with console access.

Meanwhile, I have found out that thread 2 actually isn't completely
blocked but loops in __alloc_pages_internal:

get_page_from_freelist() doesn't return a page;
try_to_free_pages() returns did_some_progress == 0;
later, do_retry == 1 and the loop restarts with goto rebalance;

I have implemented a workaround by limiting the "goto rebalance" retries 
to 3 iterations and triggering a page allocation failure otherwise.

I have changed ext4_{da_,}write_begin() to retry 
grab_cache_page_write_begin() 3 times, too, by calling 
ext4_journal_stop(); schedule_timeout(1) and goto retry;

Using this change the system recovers from the situation on first 
grab_cache_page_write_begin() retry. I have seen that 17 times during a 
test last night.

Interestingly, the show_mem() call triggered in __alloc_pages_internal() 
on page allocation failure shows plenty of memory free, see this example:

> Mar  5 02:26:16 bfp53 [21804.947985] manage_daq: page allocation failure. order:0, mode:0x120052
> Mar  5 02:26:16 bfp53 [21804.954607] Hardware Trace:
> Mar  5 02:26:16 bfp53 [21804.957377]    0 Target : <0x000049ac> { _dump_stack + 0x0 }
> Mar  5 02:26:16 bfp53 [21804.963139]      Source : <0x00037618> { ___alloc_pages_internal + 0x1cc } CALL pcrel
> Mar  5 02:26:16 bfp53 [21804.970996]    1 Target : <0x00037618> { ___alloc_pages_internal + 0x1cc }
> Mar  5 02:26:16 bfp53 [21804.977966]      Source : <0x0000fd2a> { _printk + 0x16 } RTS
> Mar  5 02:26:16 bfp53 [21804.983735]    2 Target : <0x0000fd26> { _printk + 0x12 }
> Mar  5 02:26:16 bfp53 [21804.989226]      Source : <0x0001058e> { _vprintk + 0x116 } RTS
> Mar  5 02:26:16 bfp53 [21804.995165]    3 Target : <0x00010586> { _vprintk + 0x10e }
> Mar  5 02:26:16 bfp53 [21805.005705]      Source : <0xffa00c76> /* kernel dynamic memory */
> Mar  5 02:26:16 bfp53 [21805.013596]    4 Target : <0xffa00c14> /* kernel dynamic memory */
> Mar  5 02:26:16 bfp53 [21805.022158]      Source : <0xffa00a5c> /* kernel dynamic memory */
> Mar  5 02:26:16 bfp53 [21805.030932]    5 Target : <0xffa00a5c> /* kernel dynamic memory */
> Mar  5 02:26:16 bfp53 [21805.040640]      Source : <0xffa00a32> /* kernel dynamic memory */
> Mar  5 02:26:16 bfp53 [21805.048552]    6 Target : <0xffa00a04> /* kernel dynamic memory */
> Mar  5 02:26:16 bfp53 [21805.057211]      Source : <0xffa00c10> /* kernel dynamic memory */
> Mar  5 02:26:16 bfp53 [21805.065086]    7 Target : <0xffa00c0e> /* kernel dynamic memory */
> Mar  5 02:26:17 bfp53 [21805.072947]      Source : <0xffa00efe> /* kernel dynamic memory */
> Mar  5 02:26:17 bfp53 [21805.081598]    8 Target : <0xffa00efa> /* kernel dynamic memory */
> Mar  5 02:26:17 bfp53 [21805.090706]      Source : <0xffa003d2> /* kernel dynamic memory */
> Mar  5 02:26:17 bfp53 [21805.098692]    9 Target : <0xffa003ca> /* kernel dynamic memory */
> Mar  5 02:26:17 bfp53 [21805.104880]      Source : <0x00014024> { _irq_exit + 0x50 } RTS
> Mar  5 02:26:17 bfp53 [21805.110793]   10 Target : <0x0001401e> { _irq_exit + 0x4a }
> Mar  5 02:26:17 bfp53 [21805.116454]      Source : <0x0001402c> { _irq_exit + 0x58 } IF CC JUMP
> Mar  5 02:26:17 bfp53 [21805.123013]   11 Target : <0x0001402a> { _irq_exit + 0x56 }
> Mar  5 02:26:17 bfp53 [21805.128674]      Source : <0x00009d8c> { _idle_cpu + 0x1c } RTS
> Mar  5 02:26:17 bfp53 [21805.134643]   12 Target : <0x00009d70> { _idle_cpu + 0x0 }
> Mar  5 02:26:17 bfp53 [21805.140192]      Source : <0x00014026> { _irq_exit + 0x52 } CALL pcrel
> Mar  5 02:26:17 bfp53 [21805.146756]   13 Target : <0x00014026> { _irq_exit + 0x52 }
> Mar  5 02:26:17 bfp53 [21805.152471]      Source : <0x0001401c> { _irq_exit + 0x48 } IF !CC JUMP
> Mar  5 02:26:17 bfp53 [21805.159064]   14 Target : <0x00014006> { _irq_exit + 0x32 }
> Mar  5 02:26:17 bfp53 [21805.164783]      Source : <0x00014048> { _irq_exit + 0x74 } JUMP.S
> Mar  5 02:26:17 bfp53 [21805.170932]   15 Target : <0x00014048> { _irq_exit + 0x74 }
> Mar  5 02:26:17 bfp53 [21805.176592]      Source : <0x00013d6e> { ___do_softirq + 0xa2 } RTS
> Mar  5 02:26:17 bfp53 [21805.182864] Stack info:
> Mar  5 02:26:17 bfp53 [21805.191811]  SP: [0x02ab9b60] <0x02ab9b60> /* kernel dynamic memory */
> Mar  5 02:26:17 bfp53 [21805.198495]  FP: (0x02ab9b64)
> Mar  5 02:26:17 bfp53 [21805.201403]  Memory from 0x02ab9b60 to 02aba000
> Mar  5 02:26:17 bfp53 [21805.205835] 02ab9b60:[02ab9bbc](02ab9bbc)<0003761c> 03bde680  00000000  00120052  03bde880  00000000
> Mar  5 02:26:17 bfp53 [21805.215086] 02ab9b80: 00120052  00000002  00000042  02ab8000  02ab8000  00000000  00120052  00000000
> Mar  5 02:26:17 bfp53 [21805.224375] 02ab9ba0: 02ab8000  00000010  00000002  00000000  00000000  00000000  00000000 (02ab9bf0)
> Mar  5 02:26:17 bfp53 [21805.233690] 02ab9bc0:<00033300><02f4e3dc> 04a85000 <02f4e344> 00000000  00000080  00004a85  ffffff7f
> Mar  5 02:26:17 bfp53 [21805.243044] 02ab9be0: 02ab9c04 <00a8f76e> 00000000  00000000 (02ab9c44)<00a8892c> 00000000  031423d8
> Mar  5 02:26:17 bfp53 [21805.252333] 02ab9c00: 00000000  00000004  031423d8  000005cc  04a85000  000005cc  00000000  000005cc
> Mar  5 02:26:17 bfp53 [21805.261648] 02ab9c20: 04a84a34  00000000  000005cc  000005cc  04a86000  00000000  00004a85  00000003
> Mar  5 02:26:17 bfp53 [21805.271002] 02ab9c40: 00000000 (02ab9ca4)<00032b08> 02ab8000  00001000 <02f4e3dc> 000005cc  00000000
> Mar  5 02:26:17 bfp53 [21805.280292] 02ab9c60: 04a85000  00001000  0306a260 <02f4e3dc> 04a85000  00000000  00001000  00000000
> Mar  5 02:26:17 bfp53 [21805.289608] 02ab9c80: 02ab9ca0  02ab9c9c  00000000  00a9fc74  000005cc  00000000  00000000  00000000
> Mar  5 02:26:17 bfp53 [21805.298962] 02ab9ca0: 00265100 (02ab9cf0)<00033a6c> 0306a260 <02f4e3dc><02f4e344> 02ab9ce0  00000000
> Mar  5 02:26:17 bfp53 [21805.308252] 02ab9cc0: 04a84a34  00000000  0306a260  02ab9ce0  04a84a34  00000000  00000000  00a9fc74
> Mar  5 02:26:17 bfp53 [21805.317566] 02ab9ce0: 02ab9e94  00000001  000005cc  00001c24 (02ab9d60)<00033e8a><02f4e344> 000021f0
> Mar  5 02:26:17 bfp53 [21805.326919] 02ab9d00: 0306a260  00000000  02ab9e94  00000000  04a84a34  02ab9e10  02ab9dfc <000fda3a>
> Mar  5 02:26:17 bfp53 [21805.336211] 02ab9d20: 04a84a34  00000000  02ab9e58  000021f0  00000000  00000000 <02ab9d70><02f4e3dc>
> Mar  5 02:26:17 bfp53 [21805.345529] 02ab9d40: 00000000  00000001  ffffffff  00000000  00000000  00000000  00000000  000021f0
> Mar  5 02:26:17 bfp53 [21805.354882] 02ab9d60:<02ab9da0><0003440a> 02ab9e10 <02f4e344> 0306a260  02f4e3b0  02ab9e94  00000000
> Mar  5 02:26:17 bfp53 [21805.364168] 02ab9d80: 04a84a34  02ab9e10  02ab9e94  00000001  02ab9e58 <0001410e> 02ab9dbc <02f4e3dc>
> Mar  5 02:26:17 bfp53 [21805.364168] 02ab9d80: 04a84a34  02ab9e10  02ab9e94  00000001  02ab9e58 <0001410e> 02ab9dbc <02f4e3dc>
> Mar  5 02:26:17 bfp53 [21805.373488] 02ab9da0: 02ab9dd8 <00a81c28><02f4e344> 0306a260  02f4e2cc  00000000  04a84a34  00000001
> Mar  5 02:26:17 bfp53 [21805.382834] 02ab9dc0: 02ab9e94  00000000  00040000  00000001  04a84a34  00000000  02ab9e9c <00042f34>
> Mar  5 02:26:17 bfp53 [21805.392127] 02ab9de0: 0306a260  02ab9eec  00e00fb8  02ab9e10  02ab9e94  000021f0  00dda938  02ab9e10
> Mar  5 02:26:17 bfp53 [21805.401446] 02ab9e00:<000fdc24> 00bdcd40  04a84a34  00000000 <000fdc5c> 003cf20e  00000000  00000001
> Mar  5 02:26:17 bfp53 [21805.410791] 02ab9e20: ffffffff  0306a260  00000000  00000000  00000000  00000000  03bde680  00000000
> Mar  5 02:26:17 bfp53 [21805.420082] 02ab9e40: 00000000  001f8c3c  03bde680  00020280  02ab9e50  02ab9e50  04a84a34  00000000
> Mar  5 02:26:17 bfp53 [21805.429405] 02ab9e60:<00013d28> 001f18fc  02ab8000  001f1888  000021f0  02ab9e94 <00013d68> 001f18fc
> Mar  5 02:26:17 bfp53 [21805.438755] 02ab9e80: 00000000  00000000  02ab9ea4 <00008f04> 001f63f4  02b00004  000021f0  02ab9ec4
> Mar  5 02:26:17 bfp53 [21805.448041] 02ab9ea0:<00043514> 0306a260  00000004  02ab9eec  02b00004  00000000  00000000  02ab9ee0
> Mar  5 02:26:17 bfp53 [21805.457364] 02ab9ec0: 02ab9eec  02ab9ef8 <000437f8> 0306a260  02b00004  000021f0  02b00004  00000141
> Mar  5 02:26:17 bfp53 [21805.466714] 02ab9ee0: 00000000  ffffe000  02ab9eec  04a84a34  00000000  00000001  00000000  ffa008d0
> Mar  5 02:26:17 bfp53 [21805.475999] 02ab9f00: 000437c4  00000000  ffffe000  030cf8dc  00e09388  000005a8  00000000  00dda938
> Mar  5 02:26:17 bfp53 [21805.485322] 02ab9f20: 02b00004  003cf20e  00008000  00000000  00000000  02aba000  003cf20e  003cf20e
> Mar  5 02:26:17 bfp53 [21805.494675] 02ab9f40:<00dcdb62> ffa00e46  02001025  003de2bb  003e03f1  003de2ba  003e03ee  00000000
> Mar  5 02:26:17 bfp53 [21805.503958] 02ab9f60: 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
> Mar  5 02:26:17 bfp53 [21805.513281] 02ab9f80: 00000000  00000000  00000000  00000000  00000000  039a0510  039a0508  0360af3c
> Mar  5 02:26:17 bfp53 [21805.522631] 02ab9fa0: 00000020  00000000  00000000  00000000  003f7838  02ab3c7c  02ab3c88  00df09b0
> Mar  5 02:26:17 bfp53 [21805.531916] 02ab9fc0: 00000017  00e00fb8  00df13f8  003cf204  00000004  00000000  000021f0  02b00004
> Mar  5 02:26:17 bfp53 [21805.541236] 02ab9fe0: 00dda938  00000000  000021f0  02b00004  00000017  00000017  00000004  00000006
> Mar  5 02:26:17 bfp53 [21805.550731] Return addresses in stack:
> Mar  5 02:26:17 bfp53 [21805.554584]    frame  1 : <0x0003761c> { ___alloc_pages_internal + 0x1d0 }
> Mar  5 02:26:17 bfp53 [21805.561534]    frame  2 : <0x00033300> { _grab_cache_page_write_begin + 0x50 }
> Mar  5 02:26:17 bfp53 [21805.584838]     address : <0x02f4e3dc> /* kernel dynamic memory */
> Mar  5 02:26:17 bfp53 [21805.592680]     address : <0x02f4e344> /* kernel dynamic memory */
> Mar  5 02:26:17 bfp53 [21805.599028]     address : <0x00a8f76e> { :ext4:_ext4_journal_start_sb + 0x26 }
> Mar  5 02:26:17 bfp53 [21805.606329]    frame  3 : <0x00a8892c> { :ext4:_ext4_da_write_begin + 0xac }
> Mar  5 02:26:17 bfp53 [21805.613392]    frame  4 : <0x00032b08> { _generic_perform_write + 0x98 }
> Mar  5 02:26:17 bfp53 [21805.622262]     address : <0x02f4e3dc> /* kernel dynamic memory */
> Mar  5 02:26:17 bfp53 [21805.630250]     address : <0x02f4e3dc> /* kernel dynamic memory */
> Mar  5 02:26:17 bfp53 [21805.636537]    frame  5 : <0x00033a6c> { _generic_file_buffered_write + 0x50 }
> Mar  5 02:26:17 bfp53 [21805.645740]     address : <0x02f4e3dc> /* kernel dynamic memory */
> Mar  5 02:26:17 bfp53 [21805.653708]     address : <0x02f4e344> /* kernel dynamic memory */
> Mar  5 02:26:17 bfp53 [21805.659928]    frame  6 : <0x00033e8a> { ___generic_file_aio_write_nolock + 0x1ba }
> Mar  5 02:26:17 bfp53 [21805.669659]     address : <0x02f4e344> /* kernel dynamic memory */
> Mar  5 02:26:17 bfp53 [21805.675988]     address : <0x000fda3a> { _sock_recvmsg + 0x96 }
> Mar  5 02:26:17 bfp53 [21805.684148]     address : <0x02ab9d70> /* kernel dynamic memory */
> Mar  5 02:26:17 bfp53 [21805.692186]     address : <0x02f4e3dc> /* kernel dynamic memory */
> Mar  5 02:26:17 bfp53 [21805.700105]     address : <0x02ab9da0> /* kernel dynamic memory */
> Mar  5 02:26:17 bfp53 [21805.706305]     address : <0x0003440a> { _generic_file_aio_write + 0x52 }
> Mar  5 02:26:17 bfp53 [21805.715083]     address : <0x02f4e344> /* kernel dynamic memory */
> Mar  5 02:26:17 bfp53 [21805.721392]     address : <0x0001410e> { _irq_enter + 0xa }
> Mar  5 02:26:17 bfp53 [21805.728914]     address : <0x02f4e3dc> /* kernel dynamic memory */
> Mar  5 02:26:17 bfp53 [21805.735283]     address : <0x00a81c28> { :ext4:_ext4_file_write + 0x40 }
> Mar  5 02:26:17 bfp53 [21805.744015]     address : <0x02f4e344> /* kernel dynamic memory */
> Mar  5 02:26:17 bfp53 [21805.750296]     address : <0x00042f34> { _do_sync_write + 0x90 }
> Mar  5 02:26:17 bfp53 [21805.756313]     address : <0x000fdc24> { _sys_recvfrom + 0x64 }
> Mar  5 02:26:17 bfp53 [21805.762262]     address : <0x000fdc5c> { _sys_recvfrom + 0x9c }
> Mar  5 02:26:17 bfp53 [21805.768263]     address : <0x00013d28> { ___do_softirq + 0x5c }
> Mar  5 02:26:17 bfp53 [21805.774254]     address : <0x00013d68> { ___do_softirq + 0x9c }
> Mar  5 02:26:17 bfp53 [21805.780216]     address : <0x00008f04> { _bfin_handle_irq + 0x1c }
> Mar  5 02:26:17 bfp53 [21805.786449]     address : <0x00043514> { _vfs_write + 0x60 }
> Mar  5 02:26:17 bfp53 [21805.792159]     address : <0x000437f8> { _sys_write + 0x34 }
> Mar  5 02:26:17 bfp53 [21805.800542]     address : <0x00dcdb62> [ /opt/nge/lib/libngus.so.0.0.0 + 0xdb62 ]
> Mar  5 02:26:17 bfp53 [21805.808171] Mem-Info:
> Mar  5 02:26:17 bfp53 [21805.810372] DMA per-cpu:
> Mar  5 02:26:17 bfp53 [21805.812915] CPU    0: hi:   18, btch:   3 usd:  15
> Mar  5 02:26:17 bfp53 [21805.817749] Active_anon:0 active_file:0 inactive_anon:0
> Mar  5 02:26:17 bfp53 [21805.817768]  inactive_file:620 dirty:565 writeback:0 unstable:0
> Mar  5 02:26:17 bfp53 [21805.817786]  free:7162 slab:1112 mapped:0 pagetables:0 bounce:0
> Mar  5 02:26:17 bfp53 [21805.835000] DMA free:28648kB min:984kB low:1228kB high:1476kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:2480kB present:60956kB pages_scanned:0 all_unreclaimable? no
> Mar  5 02:26:17 bfp53 [21805.851771] lowmem_reserve[]: 0 0 0
> Mar  5 02:26:17 bfp53 [21805.855236] DMA: 318*4kB 396*8kB 299*16kB 205*32kB 115*64kB 29*128kB 5*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB 0*32768kB = 28648kB
> Mar  5 02:26:17 bfp53 [21805.868869] 620 total pagecache pages
> Mar  5 02:26:17 bfp53 [21805.876098] 15359 pages RAM
> Mar  5 02:26:17 bfp53 [21805.878803] 673 pages reserved
> Mar  5 02:26:17 bfp53 [21805.881839] 589 pages shared
> Mar  5 02:26:17 bfp53 [21805.884771] 6850 pages non-shared
> Mar  5 02:26:17 bfp53 [21805.888129] ext4_da_write_begin: retrying grab_cache_page_write_begin()

I will attach my workaround patch for reference, too.

Can anybody explain this behaviour and maybe direct me to the root cause?

Of course, this now looks more like a page allocation problem than an 
ext4 one.

Thanks,
Enrik


--------------060600010305080500040600
Content-Type: text/x-diff;
 name="ext4-oom-endless-loop-workaround.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ext4-oom-endless-loop-workaround.diff"

---
 fs/ext4/inode.c |   24 ++++++++++++++++++++++++
 mm/page_alloc.c |    4 +++-
 2 files changed, 27 insertions(+), 1 deletion(-)

Index: linux-2.6.28.10/fs/ext4/inode.c
===================================================================
--- linux-2.6.28.10.orig/fs/ext4/inode.c	2010-03-03 15:29:23.000000000 +0100
+++ linux-2.6.28.10/fs/ext4/inode.c	2010-03-03 15:53:20.000000000 +0100
@@ -1335,6 +1335,7 @@ static int ext4_write_begin(struct file 
 	struct page *page;
  	pgoff_t index;
 	unsigned from, to;
+	int grab_cache_page_retries = 3;
 
  	index = pos >> PAGE_CACHE_SHIFT;
 	from = pos & (PAGE_CACHE_SIZE - 1);
@@ -1354,6 +1355,17 @@ retry:
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page) {
 		ext4_journal_stop(handle);
+
+		/* retry to get memory because the reason for OOM could be
+		 * AOP_FLAG_NOFS! */
+		if (grab_cache_page_retries) {
+			printk(KERN_DEBUG "%s: retrying "
+			       "grab_cache_page_write_begin()\n", __func__);
+			grab_cache_page_retries--;
+			schedule_timeout_uninterruptible(1);
+			goto retry;
+		}
+
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -2584,6 +2596,7 @@ static int ext4_da_write_begin(struct fi
 	unsigned from, to;
 	struct inode *inode = mapping->host;
 	handle_t *handle;
+	int grab_cache_page_retries = 3;
 
 	index = pos >> PAGE_CACHE_SHIFT;
 	from = pos & (PAGE_CACHE_SIZE - 1);
@@ -2614,6 +2627,17 @@ retry:
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page) {
 		ext4_journal_stop(handle);
+
+		/* retry to get memory because the reason for OOM could be
+		 * AOP_FLAG_NOFS! */
+		if (grab_cache_page_retries) {
+			printk(KERN_DEBUG "%s: retrying "
+			       "grab_cache_page_write_begin()\n", __func__);
+			grab_cache_page_retries--;
+			schedule_timeout_uninterruptible(1);
+			goto retry;
+		}
+
 		ret = -ENOMEM;
 		goto out;
 	}
Index: linux-2.6.28.10/mm/page_alloc.c
===================================================================
--- linux-2.6.28.10.orig/mm/page_alloc.c	2010-03-03 15:52:18.000000000 +0100
+++ linux-2.6.28.10/mm/page_alloc.c	2010-03-03 15:52:22.000000000 +0100
@@ -1476,6 +1476,7 @@ __alloc_pages_internal(gfp_t gfp_mask, u
 	int alloc_flags;
 	unsigned long did_some_progress;
 	unsigned long pages_reclaimed = 0;
+	int retries = 3;
 
 	might_sleep_if(wait);
 
@@ -1659,8 +1660,9 @@ nofail_alloc:
 		if (gfp_mask & __GFP_NOFAIL)
 			do_retry = 1;
 	}
-	if (do_retry) {
+	if (do_retry && retries) {
 		congestion_wait(WRITE, HZ/50);
+		retries--;
 		goto rebalance;
 	}
 

--------------060600010305080500040600--
