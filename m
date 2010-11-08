From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.36: kernel panic in cascade (Fatal exception in interrupt)
Date: Mon, 8 Nov 2010 20:55:49 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1011082039360.2900@localhost6.localdomain6>
References: <201011032334.30662.thomas@m3y3r.de>  <201011080014.33354.thomas@m3y3r.de>  <alpine.LFD.2.00.1011081047500.2900@localhost6.localdomain6> <1289242528.11571.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, "Ted Ts'o" <tytso@mit.edu>
To: Thomas Meyer <thomas@m3y3r.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1289242528.11571.8.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 8 Nov 2010, Thomas Meyer wrote:

> Am Montag, den 08.11.2010, 10:51 +0100 schrieb Thomas Gleixner: 
> > On Mon, 8 Nov 2010, Thomas Meyer wrote:
> > > > 
> > > > [   300.000697] Pid: 0, comm: kworker/0:0 Not tainted 2.6.36 #2 MS-7250/MS-7250
> > > > [   300.000815] RIP: 0010:[<ffffffff8105faf4>]  [<ffffffff8105faf4>] cascade+0x54/0x7a
> > 
> > Can you please enable
> > 
> > CONFIG_DEBUG_OBJECTS
> > CONFIG_DEBUG_OBJECTS_FREE
> > CONFIG_DEBUG_OBJECTS_TIMERS
> > and set CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT to 1
> > 
> > That should give us more useful data.
> 
> First results:
> 
> WARNING: at lib/debugobjects.c:259 debug_print_object+0x5b/0x63()
> Hardware name: MS-7250
> ODEBUG: free active (active state 0) object type: timer_list

That means that ext4_put_super() is kfree'ing something which has an
active timer embedded. That explains the crash in cascade() very well.

I leave it to the ext4 experts to solve it for real :)

> Modules linked in: floppy radeon ttm drm_kms_helper
> Pid: 2259, comm: umount Not tainted 2.6.36 #4
> Call Trace:
> [<ffffffff810577d2>] warn_slowpath_common+0x80/0x98
> [<ffffffff8105787e>] warn_slowpath_fmt+0x41/0x43
> [<ffffffff812cab46>] debug_print_object+0x5b/0x63
> [<ffffffff812cb024>] debug_check_no_obj_freed+0x94/0x1d3
> [<ffffffff817032d3>] ? _raw_spin_unlock_irq+0x1f/0x2a
> [<ffffffff810e4cd7>] kfree+0x75/0xb6
> [<ffffffff81172c75>] ? ext4_put_super+0x32b/0x33a
> [<ffffffff81172c75>] ext4_put_super+0x32b/0x33a
> [<ffffffff810ed276>] generic_shutdown_super+0x51/0xd2
> [<ffffffff810ed319>] kill_block_super+0x22/0x3a
> [<ffffffff810ecda6>] deactivate_locked_super+0x21/0x41
> [<ffffffff810ed220>] deactivate_super+0x40/0x45
> [<ffffffff811010a5>] mntput_no_expire+0xdd/0x10b
> [<ffffffff8110161a>] sys_umount+0x2d2/0x2fd
> [<ffffffff81705f1e>] ? do_page_fault+0x217/0x244
> [<ffffffff81022a2b>] system_call_fastpath+0x16/0x1b
> 
> I didn't encounter a kernel crash with the DEBUG_OBJECT options enabled.

That's the point of DEBUG_OBJECTs :) It detects and corrects the
problem in most cases and keeps the box alive with a useful error
report.

Thanks,

	tglx
