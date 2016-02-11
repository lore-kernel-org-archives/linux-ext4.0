From: Jan Kara <jack@suse.cz>
Subject: Re: 4.1.15 - ext4 / xattr related crash?
Date: Thu, 11 Feb 2016 09:28:38 +0100
Message-ID: <20160211082838.GI12245@quack.suse.cz>
References: <20160208094950.GH10986@pcnci.linuxbox.cz>
 <20160208112711.GI10986@pcnci.linuxbox.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56914 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbcBKI2W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Feb 2016 03:28:22 -0500
Content-Disposition: inline
In-Reply-To: <20160208112711.GI10986@pcnci.linuxbox.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 08-02-16 12:27:11, Nikola Ciprich wrote:
> One more information, probably worth mentioning - the box
> is running as CEPH storage node (this is noticeable from the
> backtrace), therefore it uses xattrs a lot. Some minutes before
> the hang, I've removed quite a lot of ceph snapshots, probably
> causing lots of file delete operations..

This seems like one of the mbcache scalability issue that were reported
recently. Last version of patches fixing this was posted here:

http://comments.gmane.org/gmane.comp.file-systems.ext4/51155

Ted will likely merge these during the next merge window.

								Honza

> 
> On Mon, Feb 08, 2016 at 10:49:50AM +0100, Nikola Ciprich wrote:
> > Hi,
> > 
> > I've just had server crash that could be ext4 or xattr related..
> > It's running x86_64 4.1.15, updated from 4.0.5 about a week ago.
> > 
> > The box stopped responding, but I have netconsole logged backtraces..
> > 
> > it all stareted with "INFO: rcu_preempt detected stalls on CPUs/tasks:"
> > Feb  8 07:28:38 remrprv1a [139450.378657] INFO: rcu_preempt detected stalls on CPUs/tasks:
> > Feb  8 07:28:38 remrprv1a {
> > Feb  8 07:28:38 remrprv1a }
> > Feb  8 07:28:38 remrprv1a (detected by 3, t=60008 jiffies, g=6904096, c=6904095, q=94)
> > Feb  8 07:28:38 remrprv1a [139450.390575] All QSes seen, last rcu_preempt kthread activity 60004 (4434008039-4433948035), jiffies_till_next_fqs=3, root ->qsmask 0x0
> > Feb  8 07:28:38 remrprv1a [139450.403123] ceph-osd        R
> > Feb  8 07:28:38 remrprv1a running task
> > Feb  8 07:28:38 remrprv1a 0 10554      1 0x00000008
> > Feb  8 07:28:38 remrprv1a [139450.410642]  ffffffff81a3b600
> > Feb  8 07:28:38 remrprv1a ffff88107fc63d78
> > Feb  8 07:28:38 remrprv1a ffffffff8107ab90
> > Feb  8 07:28:38 remrprv1a ffff88107fc75940
> > Feb  8 07:28:38 remrprv1a 
> > Feb  8 07:28:38 remrprv1a [139450.418809]  ffffffff81a3b600
> > Feb  8 07:28:38 remrprv1a ffff88107fc63e38
> > Feb  8 07:28:38 remrprv1a ffffffff810aed8a
> > Feb  8 07:28:38 remrprv1a 0000000000000000
> > Feb  8 07:28:38 remrprv1a 
> > Feb  8 07:28:38 remrprv1a [139450.426963]  0000000000000092
> > Feb  8 07:28:38 remrprv1a ffff88107fc63dd8
> > Feb  8 07:28:38 remrprv1a 0000000000000092
> > Feb  8 07:28:38 remrprv1a 0000000000695920
> > Feb  8 07:28:38 remrprv1a
> > Feb  8 07:28:38 remrprv1a [139450.435133] Call Trace:
> > Feb  8 07:28:38 remrprv1a [139450.437886]  <IRQ>
> > Feb  8 07:28:38 remrprv1a [<ffffffff8107ab90>] sched_show_task+0xc0/0x120
> > Feb  8 07:28:38 remrprv1a [139450.444551]  [<ffffffff810aed8a>] rcu_check_callbacks+0xa5a/0xab0
> > Feb  8 07:28:38 remrprv1a [139450.450961]  [<ffffffff810b2909>] update_process_times+0x39/0x70
> > Feb  8 07:28:38 remrprv1a [139450.457283]  [<ffffffff810c3242>] tick_sched_timer+0x62/0xc0
> > Feb  8 07:28:38 remrprv1a [139450.463245]  [<ffffffff810b3583>] __run_hrtimer+0x73/0x200
> > Feb  8 07:28:38 remrprv1a [139450.469040]  [<ffffffff810c31e0>] ? tick_nohz_handler+0x100/0x100
> > Feb  8 07:28:38 remrprv1a [139450.475440]  [<ffffffff810b3aa2>] hrtimer_interrupt+0x102/0x240
> > Feb  8 07:28:38 remrprv1a [139450.481670]  [<ffffffff81038c69>] local_apic_timer_interrupt+0x39/0x60
> > Feb  8 07:28:38 remrprv1a [139450.488505]  [<ffffffff814c9055>] smp_apic_timer_interrupt+0x45/0x59
> > Feb  8 07:28:38 remrprv1a [139450.495165]  [<ffffffff814c755b>] apic_timer_interrupt+0x6b/0x70
> > Feb  8 07:28:38 remrprv1a [<ffffffff8128001b>] ? delay_tsc+0x4b/0x90
> > Feb  8 07:28:38 remrprv1a [139450.507697]  [<ffffffff8127ffbf>] __delay+0xf/0x20
> > Feb  8 07:28:38 remrprv1a [139450.512791]  [<ffffffff81095b0e>] do_raw_spin_lock+0x8e/0x180
> > Feb  8 07:28:38 remrprv1a [139450.518844]  [<ffffffff814c6545>] _raw_spin_lock+0x15/0x20
> > Feb  8 07:28:38 remrprv1a [139450.524640]  [<ffffffff811ea3d5>] __mb_cache_entry_release+0x75/0x120
> > Feb  8 07:28:38 remrprv1a [139450.531383]  [<ffffffff811eabee>] mb_cache_entry_release+0xe/0x10
> > Feb  8 07:28:38 remrprv1a [139450.537815]  [<ffffffffa018fbd7>] ext4_xattr_cache_insert+0x57/0x80 [ext4]
> > Feb  8 07:28:38 remrprv1a [139450.548968]  [<ffffffffa01916c8>] ext4_xattr_get+0x1b8/0x250 [ext4]
> > Feb  8 07:28:38 remrprv1a [139450.555545]  [<ffffffff811b0099>] ? mntput_no_expire+0x39/0x1c0
> > Feb  8 07:28:38 remrprv1a [139450.561777]  [<ffffffffa01963ff>] ext4_xattr_security_get+0x2f/0x40 [ext4]
> > Feb  8 07:28:38 remrprv1a [139450.568960]  [<ffffffff811b3bb3>] generic_getxattr+0x83/0x90
> > Feb  8 07:28:38 remrprv1a [139450.574931]  [<ffffffff8122fb7d>] cap_inode_need_killpriv+0x2d/0x40
> > Feb  8 07:28:38 remrprv1a [139450.581512]  [<ffffffff81230e96>] security_inode_need_killpriv+0x16/0x20
> > Feb  8 07:28:38 remrprv1a [139450.588518]  [<ffffffff811a8e63>] file_remove_suid+0x53/0xd0
> > Feb  8 07:28:38 remrprv1a [139450.594485]  [<ffffffff81281704>] ? lockref_get_not_dead+0x34/0x50
> > Feb  8 07:28:38 remrprv1a [139450.600975]  [<ffffffff81126507>] __generic_file_write_iter+0x57/0x1b0
> > Feb  8 07:28:38 remrprv1a [139450.607812]  [<ffffffffa0145e76>] ext4_file_write_iter+0x126/0x3c0 [ext4]
> > Feb  8 07:28:38 remrprv1a [139450.614912]  [<ffffffff8119f7b8>] ? path_openat+0xa8/0x6a0
> > Feb  8 07:28:38 remrprv1a [139450.620705]  [<ffffffff8118da3f>] do_iter_readv_writev+0x5f/0x80
> > Feb  8 07:28:38 remrprv1a [139450.627018]  [<ffffffff8118eff2>] do_readv_writev+0x172/0x220
> > Feb  8 07:28:38 remrprv1a [139450.633079]  [<ffffffffa0145d50>] ? ext4_unwritten_wait+0xb0/0xb0 [ext4]
> > Feb  8 07:28:38 remrprv1a [139450.640093]  [<ffffffff81044f9d>] ? __bad_area_nosemaphore+0x20d/0x220
> > Feb  8 07:28:38 remrprv1a [139450.646922]  [<ffffffff8118f0e1>] vfs_writev+0x41/0x50
> > Feb  8 07:28:38 remrprv1a [139450.652362]  [<ffffffff8118f219>] SyS_writev+0x59/0xf0
> > Feb  8 07:28:38 remrprv1a [139450.657807]  [<ffffffff8118dca2>] ? SyS_lseek+0x62/0xb0
> > Feb  8 07:28:38 remrprv1a [139450.663333]  [<ffffffff814c6797>] system_call_fastpath+0x12/0x6a
> > Feb  8 07:28:38 remrprv1a [139450.669648] rcu_preempt kthread starved for 60283 jiffies!
> > 
> > and continued with lots of stalls / softlockups..
> > 
> > as the full log is quite long, I'm not attaching it here, it can be
> > downloaded at http://nik.lbox.cz/download/trace.txt
> > 
> > My question is, is this some known issue, maybe fixed in later kernels? I haven't
> > found anything related in git..
> > 
> > If I could provide any further information, please let me know
> > 
> > BR
> > 
> > nik
> > 
> > 
> > 
> > -- 
> > -------------------------------------
> > Ing. Nikola CIPRICH
> > LinuxBox.cz, s.r.o.
> > 28.rijna 168, 709 00 Ostrava
> > 
> > tel.:   +420 591 166 214
> > fax:    +420 596 621 273
> > mobil:  +420 777 093 799
> > www.linuxbox.cz
> > 
> > mobil servis: +420 737 238 656
> > email servis: servis@linuxbox.cz
> > -------------------------------------
> 
> 
> 
> -- 
> -------------------------------------
> Ing. Nikola CIPRICH
> LinuxBox.cz, s.r.o.
> 28.rijna 168, 709 00 Ostrava
> 
> tel.:   +420 591 166 214
> fax:    +420 596 621 273
> mobil:  +420 777 093 799
> www.linuxbox.cz
> 
> mobil servis: +420 737 238 656
> email servis: servis@linuxbox.cz
> -------------------------------------


-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
