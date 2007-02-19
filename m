From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: loopback mount EXT3 oops
Date: Sun, 18 Feb 2007 16:31:00 -0800
Message-ID: <20070218163100.a4b95b3a.akpm@linux-foundation.org>
References: <1171842762.7918.47.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, adilger@clusterfs.com,
	lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34512 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbXBSAbp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Feb 2007 19:31:45 -0500
In-Reply-To: <1171842762.7918.47.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 19 Feb 2007 10:52:42 +1100 Rusty Russell <rusty@rustcorp.com.au> wrote:

> Hi all,
> 
> 	This happened on 2.6.20-rc6-mm3, so I upgraded to 2.6.20-git14, and
> same thing happened.  Doing a forced fsck on the (corrupted by
> double-mounting I think) filesystem fixed it, but I took a copy before
> doing that.
> 
> Do we care about ext3 barfing on corrupted filesystems?

yup.

> [ 1329.782923] EXT3 FS on loop0, internal journal
> [ 1329.782926] EXT3-fs: recovery complete.
> [ 1329.783186] EXT3-fs: mounted filesystem with ordered data mode.
> [ 1329.921992] EXT3-fs warning (device loop0): ext3_unlink: Deleting nonexistent file (842294), 0
> [ 1329.922516] EXT3-fs warning (device loop0): ext3_unlink: Deleting nonexistent file (842295), 0
> [ 1329.922524] list_add corruption. next->prev should be prev (f6705c9c), but was f21a886c. (next=f21a886c).
> [ 1329.922546] ------------[ cut here ]------------
> [ 1329.922548] kernel BUG at lib/list_debug.c:27!
> [ 1329.922550] invalid opcode: 0000 [#1]
> [ 1329.922551] Modules linked in: loop binfmt_misc i915 ipv6 drm cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative video thermal processor fan button battery asus_acpi backlight ac tsdev keyspan usbserial usbhid af_packet evdev psmouse snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_timer ehci_hcd rtc uhci_hcd iTCO_wdt iTCO_vendor_support snd soundcore snd_page_alloc e1000 intel_agp agpgart usbcore
> [ 1329.922574] CPU:    0
> [ 1329.922575] EIP:    0060:[<c01f0ba0>]    Not tainted VLI
> [ 1329.922576] EFLAGS: 00010286   (2.6.20-git14 #25)
> [ 1329.922581] EIP is at __list_add+0x40/0x60
> [ 1329.922583] eax: 00000070   ebx: f6705c9c   ecx: c011d791   edx: f6352ac0
> [ 1329.922585] esi: f21a88cc   edi: f2056a54   ebp: f2169eac   esp: f2169e94
> [ 1329.922587] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> [ 1329.922589] Process rm (pid: 3494, ti=f2168000 task=f6352ac0 task.ti=f2168000)
> [ 1329.922591] Stack: c03a437c f6705c9c f21a886c f21a886c 00000000 f21a88cc f2169eb4 c01f0bca 
> [ 1329.922597]        f2169ef4 c01ba4fc f2169ed4 f219a5c8 f21a8b54 f21a8c58 f69683c4 f69683c4 
> [ 1329.922602]        f21a87c8 f21a886c f219aba0 00000300 000000ce 00000000 f21a88cc f21a8c58 
> [ 1329.922607] Call Trace:
> [ 1329.922609]  [<c010516a>] show_trace_log_lvl+0x1a/0x30
> [ 1329.922612]  [<c0105231>] show_stack_log_lvl+0xb1/0xe0
> [ 1329.922615]  [<c0105430>] show_registers+0x1d0/0x2d0
> [ 1329.922618]  [<c0105629>] die+0xf9/0x220
> [ 1329.922621]  [<c01057d2>] do_trap+0x82/0xb0
> [ 1329.922623]  [<c0106117>] do_invalid_op+0x97/0xb0
> [ 1329.922626]  [<c031bb5c>] error_code+0x74/0x7c
> [ 1329.922630]  [<c01f0bca>] list_add+0xa/0x10
> [ 1329.922632]  [<c01ba4fc>] ext3_orphan_add+0x17c/0x210
> [ 1329.922636]  [<c01bb5d7>] ext3_unlink+0x127/0x1b0
> [ 1329.922638]  [<c0177938>] vfs_unlink+0x88/0xe0
> [ 1329.922642]  [<c0179688>] do_unlinkat+0xb8/0x140
> [ 1329.922645]  [<c0179720>] sys_unlink+0x10/0x20
> [ 1329.922647]  [<c01040f0>] sysenter_past_esp+0x69/0xb1
> [ 1329.922650]  =======================

I thought Eric fixed that.  Maybe he broke it instead ;)
