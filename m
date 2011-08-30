From: Jan Kara <jack@suse.cz>
Subject: Re: Bug#615998: linux-image-2.6.32-5-xen-amd64: Repeatable "kernel
 BUG at fs/jbd2/commit.c:534" from Postfix on ext4
Date: Wed, 31 Aug 2011 00:12:49 +0200
Message-ID: <20110830221249.GH16202@quack.suse.cz>
References: <20110405230538.GH2832@thunk.org>
 <FD93E462-D97B-411B-BF09-9A64670AC5C2@boeing.com>
 <AF621113-8320-4973-A88A-1FC048EA4293@boeing.com>
 <BANLkTi=5BLA07tvbv3PFcZ0cc8FmBtg+UA@mail.gmail.com>
 <404FD5CC-8F27-4336-B7D4-10675C53A588@boeing.com>
 <20110624134659.GB26380@quack.suse.cz>
 <2F80BF45-28FA-46D3-9A28-CA9416DC5813@boeing.com>
 <20110624200231.GA32176@quack.suse.cz>
 <5DE8D448-A77D-46E8-BF40-15AA7F7CDBE9@boeing.com>
 <79E8C04C-B5A8-49E5-901F-444C8B8A53DB@boeing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Jan Kara <jack@suse.cz>, Sean Ryle <seanbo@gmail.com>,
	Ted Ts'o <tytso@mit.edu>,
	"615998@bugs.debian.org" <615998@bugs.debian.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Sachin Sant <sachinp@in.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57589 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab1H3WMz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Aug 2011 18:12:55 -0400
Content-Disposition: inline
In-Reply-To: <79E8C04C-B5A8-49E5-901F-444C8B8A53DB@boeing.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Fri 26-08-11 16:03:32, Moffett, Kyle D wrote:
> Ping?
> 
> Any more ideas for debugging this issue?
  Sorry for not getting to you earlier.

> I can still trigger it on my VM snapshot very easily, so if you have anything
> you think I should test I would be very happy to give it a shot.
  OK, so in the meantime I found a bug in data=journal code which could be
related to your problem. It is fixed by commit
2d859db3e4a82a365572592d57624a5f996ed0ec which is in 3.1-rc1. Have you
tried that or newer kernel as well?

If the problem still is not fixed, I can provide some debugging patch to
you. We spoke with Josef Bacik how errors like yours could happen so I have
some places to watch...

								Honza

> On Jun 24, 2011, at 16:51, Kyle Moffett wrote:
> > On Jun 24, 2011, at 16:02, Jan Kara wrote:
> >> On Fri 24-06-11 11:03:52, Moffett, Kyle D wrote:
> >>> On Jun 24, 2011, at 09:46, Jan Kara wrote:
> >>>> On Thu 23-06-11 16:19:08, Moffett, Kyle D wrote:
> >>>>> Besides which, line 534 in the Debian 2.6.32 kernel I am using is this
> >>>>> one:
> >>>>>
> >>>>> J_ASSERT(commit_transaction->t_nr_buffers <=
> >>>>>         commit_transaction->t_outstanding_credits);
> >>>>
> >>>> The trouble is that the problem is likely in some journal list shuffling
> >>>> code because if just some operation wrongly estimated the number of needed
> >>>> buffers, we'd fail the assertion in jbd2_journal_dirty_metadata():
> >>>> J_ASSERT_JH(jh, handle->h_buffer_credits > 0);
> >>>
> >>> Hmm, ok...  I'm also going to turn that failing J_ASSERT() into a WARN_ON()
> >>> just to see how much further it gets.  I have an easy script to recreate this
> >>> data volume even if it gets totally hosed anyways, so...
> >>
> >> OK, we'll see what happens.
> >
> > Ok, status update here:
> >
> > I applied a modified version of your patch that prints out the values of both
> > t_outstanding_credits and t_nr_buffers when the assertion triggers.  I replaced
> > the J_ASSERT() that was failing with the exact same WARN_ON() trigger too.
> >
> > The end result is that postfix successfully finished delivering all the emails.
> > Afterwards I unmounted both filesystems and ran "fsck -fy" on them, it reported
> > no errors at all.
> >
> > Looking through the log, the filesystem with the issues is the 32MB one mounted
> > on /var/lib/postfix:
> >  total 61
> >  drwxr-x---  3 postfix postfix  1024 Jun 16 21:02 .
> >  drwxr-xr-x 46 root    root     4096 Jun 20 17:19 ..
> >  d---------  2 root    root    12288 Jun 16 18:35 lost+found
> >  -rw-------  1 postfix postfix    33 Jun 24 16:34 master.lock
> >  -rw-------  1 postfix postfix  1024 Jun 24 16:44 prng_exch
> >  -rw-------  1 postfix postfix  2048 Jun 24 16:34 smtpd_scache.db
> >  -rw-------  1 postfix postfix 41984 Jun 24 16:36 smtp_scache.db
> >
> > In particular, it's the tlsmgr program accessing the smtp_scache file when it
> > dies.
> >
> > Full log below.
> >
> > Cheers,
> > Kyle Moffett
> >
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385234] transaction->t_outstanding_credits = 8
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385247] transaction->t_nr_buffers = 9
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385251] ------------[ cut here ]------------
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385278] WARNING: at /tmp/kdm-deb-kernel/linux-2.6-2.6.32/debian/build/source_amd64_xen/fs/jbd2/transaction.c:1329 jbd2_journal_stop+0x189/0x25d [jbd2]()
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385287] Modules linked in: ip6table_filter ip6_tables act_police cls_flow cls_fw cls_u32 sch_htb sch_hfsc sch_ingress sch_sfq xt_time xt_connlimit xt_realm iptable_raw xt_comment xt_recent xt_policy ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY nf_tproxy_core xt_tcpmss xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLO
 G nfnetlink_log xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack xt_CONNMARK xt_connmark xt_CLASSIFY ipt_LOG xt_tcpudp xt_state iptable_nat nf_nat n
> f_conntrac
> > Jun 24 16:36:05 i-38020f57 kernel: k_ipv4 nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables x_tables ext3 jbd loop snd_pcm snd_timer snd soundcore snd_page_alloc pcspkr evdev ext4 mbcache jbd2 crc16 dm_mod xen_netfront xen_blkfront
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385440] Pid: 3817, comm: tlsmgr Not tainted 2.6.32-5-xen-amd64 #1
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385445] Call Trace:
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385458]  [<ffffffffa0032c81>] ? jbd2_journal_stop+0x189/0x25d [jbd2]
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385467]  [<ffffffffa0032c81>] ? jbd2_journal_stop+0x189/0x25d [jbd2]
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385477]  [<ffffffff8104ef00>] ? warn_slowpath_common+0x77/0xa3
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385486]  [<ffffffffa0032c81>] ? jbd2_journal_stop+0x189/0x25d [jbd2]
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385505]  [<ffffffffa0074c8e>] ? __ext4_journal_stop+0x63/0x69 [ext4]
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385517]  [<ffffffffa0060949>] ? ext4_journalled_write_end+0x160/0x19a [ext4]
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385633]  [<ffffffffa00857c6>] ? ext4_xattr_get+0x1fa/0x27c [ext4]
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385643]  [<ffffffff810b5e91>] ? generic_file_buffered_write+0x18d/0x278
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385650]  [<ffffffff810b632d>] ? __generic_file_aio_write+0x25f/0x293
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385659]  [<ffffffffa0032d42>] ? jbd2_journal_stop+0x24a/0x25d [jbd2]
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385669]  [<ffffffff8100eccf>] ? xen_restore_fl_direct_end+0x0/0x1
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385674]  [<ffffffff810b63ba>] ? generic_file_aio_write+0x59/0x9f
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385682]  [<ffffffff810efa46>] ? do_sync_write+0xce/0x113
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385694]  [<ffffffffa0074c8e>] ? __ext4_journal_stop+0x63/0x69 [ext4]
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385701]  [<ffffffff81065f06>] ? autoremove_wake_function+0x0/0x2e
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385709]  [<ffffffff81102492>] ? notify_change+0x2b3/0x2c5
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385715]  [<ffffffff810f0398>] ? vfs_write+0xa9/0x102
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385720]  [<ffffffff810f0448>] ? sys_pwrite64+0x57/0x77
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385726]  [<ffffffff810ef04d>] ? sys_ftruncate+0x112/0x11d
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385732]  [<ffffffff81011b42>] ? system_call_fastpath+0x16/0x1b
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385737] ---[ end trace 2c615eb111c993ca ]---
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385782] transaction->t_outstanding_credits = 8
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385788] transaction->t_nr_buffers = 9
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385793] ------------[ cut here ]------------
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385804] WARNING: at /tmp/kdm-deb-kernel/linux-2.6-2.6.32/debian/build/source_amd64_xen/fs/jbd2/transaction.c:1329 jbd2_journal_stop+0x189/0x25d [jbd2]()
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.385815] Modules linked in: ip6table_filter ip6_tables act_police cls_flow cls_fw cls_u32 sch_htb sch_hfsc sch_ingress sch_sfq xt_time xt_connlimit xt_realm iptable_raw xt_comment xt_recent xt_policy ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY nf_tproxy_core xt_tcpmss xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLO
 G nfnetlink_log xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack xt_CONNMARK xt_connmark xt_CLASSIFY ipt_LOG xt_tcpudp xt_state iptable_nat nf_nat n
> f_conntrac
> > Jun 24 16:36:05 i-38020f57 kernel: k_ipv4 nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables x_tables ext3 jbd loop snd_pcm snd_timer snd soundcore snd_page_alloc pcspkr evdev ext4 mbcache jbd2 crc16 dm_mod xen_netfront xen_blkfront
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386041] Pid: 3817, comm: tlsmgr Tainted: G        W  2.6.32-5-xen-amd64 #1
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386046] Call Trace:
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386055]  [<ffffffffa0032c81>] ? jbd2_journal_stop+0x189/0x25d [jbd2]
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386064]  [<ffffffffa0032c81>] ? jbd2_journal_stop+0x189/0x25d [jbd2]
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386071]  [<ffffffff8104ef00>] ? warn_slowpath_common+0x77/0xa3
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386077]  [<ffffffff8100eccf>] ? xen_restore_fl_direct_end+0x0/0x1
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386087]  [<ffffffffa0032c81>] ? jbd2_journal_stop+0x189/0x25d [jbd2]
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386098]  [<ffffffffa0033cd6>] ? jbd2_journal_start+0x96/0xc6 [jbd2]
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386113]  [<ffffffffa0070df6>] ? ext4_force_commit+0xa4/0xb3 [ext4]
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386126]  [<ffffffffa0058a37>] ? ext4_sync_file+0x8f/0x25c [ext4]
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386138]  [<ffffffff8110ccd4>] ? vfs_fsync_range+0x73/0x9e
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386146]  [<ffffffff8110cd7e>] ? do_fsync+0x28/0x39
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386153]  [<ffffffff8110cd9d>] ? sys_fdatasync+0xe/0x13
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386163]  [<ffffffff8130d89a>] ? error_exit+0x2a/0x60
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386170]  [<ffffffff81011b42>] ? system_call_fastpath+0x16/0x1b
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386178]  [<ffffffff810092eb>] ? hypercall_page+0x2eb/0x1001
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386185] ---[ end trace 2c615eb111c993cb ]---
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386243] transaction->t_outstanding_credits = 8
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386249] transaction->t_nr_buffers = 9
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386253] ------------[ cut here ]------------
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386263] WARNING: at /tmp/kdm-deb-kernel/linux-2.6-2.6.32/debian/build/source_amd64_xen/fs/jbd2/commit.c:538 jbd2_journal_commit_transaction+0x574/0x118b [jbd2]()
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386311] Modules linked in: ip6table_filter ip6_tables act_police cls_flow cls_fw cls_u32 sch_htb sch_hfsc sch_ingress sch_sfq xt_time xt_connlimit xt_realm iptable_raw xt_comment xt_recent xt_policy ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY nf_tproxy_core xt_tcpmss xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLO
 G nfnetlink_log xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack xt_CONNMARK xt_connmark xt_CLASSIFY ipt_LOG xt_tcpudp xt_state iptable_nat nf_nat n
> f_conntrac
> > Jun 24 16:36:05 i-38020f57 kernel: k_ipv4 nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables x_tables ext3 jbd loop snd_pcm snd_timer snd soundcore snd_page_alloc pcspkr evdev ext4 mbcache jbd2 crc16 dm_mod xen_netfront xen_blkfront
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386452] Pid: 992, comm: jbd2/dm-23-8 Tainted: G        W  2.6.32-5-xen-amd64 #1
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386457] Call Trace:
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386466]  [<ffffffffa0034471>] ? jbd2_journal_commit_transaction+0x574/0x118b [jbd2]
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386475]  [<ffffffffa0034471>] ? jbd2_journal_commit_transaction+0x574/0x118b [jbd2]
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386483]  [<ffffffff8104ef00>] ? warn_slowpath_common+0x77/0xa3
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386492]  [<ffffffffa0034471>] ? jbd2_journal_commit_transaction+0x574/0x118b [jbd2]
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386500]  [<ffffffff8130bf48>] ? thread_return+0x79/0xe0
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386506]  [<ffffffff8100e629>] ? xen_force_evtchn_callback+0x9/0xa
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386512]  [<ffffffff8100ece2>] ? check_events+0x12/0x20
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386519]  [<ffffffff8130d2e2>] ? _spin_unlock_irqrestore+0xd/0xe
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386560]  [<ffffffff8105b8c8>] ? try_to_del_timer_sync+0x63/0x6c
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386572]  [<ffffffffa003a98b>] ? kjournald2+0xbe/0x206 [jbd2]
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386578]  [<ffffffff81065f06>] ? autoremove_wake_function+0x0/0x2e
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386587]  [<ffffffffa003a8cd>] ? kjournald2+0x0/0x206 [jbd2]
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386592]  [<ffffffff81065c39>] ? kthread+0x79/0x81
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386599]  [<ffffffff81012baa>] ? child_rip+0xa/0x20
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386604]  [<ffffffff81011d61>] ? int_ret_from_sys_call+0x7/0x1b
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386610]  [<ffffffff8101251d>] ? retint_restore_args+0x5/0x6
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386616]  [<ffffffff81012ba0>] ? child_rip+0x0/0x20
> > Jun 24 16:36:05 i-38020f57 kernel: [5369326.386620] ---[ end trace 2c615eb111c993cc ]---
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.124954] transaction->t_outstanding_credits = 9
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.124967] transaction->t_nr_buffers = 10
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.124971] ------------[ cut here ]------------
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.124998] WARNING: at /tmp/kdm-deb-kernel/linux-2.6-2.6.32/debian/build/source_amd64_xen/fs/jbd2/transaction.c:1329 jbd2_journal_stop+0x189/0x25d [jbd2]()
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.125007] Modules linked in: ip6table_filter ip6_tables act_police cls_flow cls_fw cls_u32 sch_htb sch_hfsc sch_ingress sch_sfq xt_time xt_connlimit xt_realm iptable_raw xt_comment xt_recent xt_policy ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY nf_tproxy_core xt_tcpmss xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLO
 G nfnetlink_log xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack xt_CONNMARK xt_connmark xt_CLASSIFY ipt_LOG xt_tcpudp xt_state iptable_nat nf_nat n
> f_conntrac
> > Jun 24 16:36:07 i-38020f57 kernel: k_ipv4 nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables x_tables ext3 jbd loop snd_pcm snd_timer snd soundcore snd_page_alloc pcspkr evdev ext4 mbcache jbd2 crc16 dm_mod xen_netfront xen_blkfront
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.125158] Pid: 3817, comm: tlsmgr Tainted: G        W  2.6.32-5-xen-amd64 #1
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.125164] Call Trace:
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.125174]  [<ffffffffa0032c81>] ? jbd2_journal_stop+0x189/0x25d [jbd2]
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.125183]  [<ffffffffa0032c81>] ? jbd2_journal_stop+0x189/0x25d [jbd2]
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.125194]  [<ffffffff8104ef00>] ? warn_slowpath_common+0x77/0xa3
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.125203]  [<ffffffffa0032c81>] ? jbd2_journal_stop+0x189/0x25d [jbd2]
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.125222]  [<ffffffffa0074c8e>] ? __ext4_journal_stop+0x63/0x69 [ext4]
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.125338]  [<ffffffffa0060949>] ? ext4_journalled_write_end+0x160/0x19a [ext4]
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.125351]  [<ffffffffa00857c6>] ? ext4_xattr_get+0x1fa/0x27c [ext4]
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.125361]  [<ffffffff810b5e91>] ? generic_file_buffered_write+0x18d/0x278
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.125368]  [<ffffffff810b632d>] ? __generic_file_aio_write+0x25f/0x293
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.125377]  [<ffffffffa0032d42>] ? jbd2_journal_stop+0x24a/0x25d [jbd2]
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.125385]  [<ffffffff8100eccf>] ? xen_restore_fl_direct_end+0x0/0x1
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.125391]  [<ffffffff810b63ba>] ? generic_file_aio_write+0x59/0x9f
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.125398]  [<ffffffff810efa46>] ? do_sync_write+0xce/0x113
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.125410]  [<ffffffffa0074c8e>] ? __ext4_journal_stop+0x63/0x69 [ext4]
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.125418]  [<ffffffff81065f06>] ? autoremove_wake_function+0x0/0x2e
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.125426]  [<ffffffff81102492>] ? notify_change+0x2b3/0x2c5
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.125432]  [<ffffffff810f0398>] ? vfs_write+0xa9/0x102
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.125437]  [<ffffffff810f0448>] ? sys_pwrite64+0x57/0x77
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.125443]  [<ffffffff810ef04d>] ? sys_ftruncate+0x112/0x11d
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.125449]  [<ffffffff81011b42>] ? system_call_fastpath+0x16/0x1b
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.125454] ---[ end trace 2c615eb111c993cd ]---
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.180777] transaction->t_outstanding_credits = 9
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.180787] transaction->t_nr_buffers = 10
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.180792] ------------[ cut here ]------------
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.180810] WARNING: at /tmp/kdm-deb-kernel/linux-2.6-2.6.32/debian/build/source_amd64_xen/fs/jbd2/transaction.c:1329 jbd2_journal_stop+0x189/0x25d [jbd2]()
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.180819] Modules linked in: ip6table_filter ip6_tables act_police cls_flow cls_fw cls_u32 sch_htb sch_hfsc sch_ingress sch_sfq xt_time xt_connlimit xt_realm iptable_raw xt_comment xt_recent xt_policy ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY nf_tproxy_core xt_tcpmss xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLO
 G nfnetlink_log xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack xt_CONNMARK xt_connmark xt_CLASSIFY ipt_LOG xt_tcpudp xt_state iptable_nat nf_nat n
> f_conntrac
> > Jun 24 16:36:07 i-38020f57 kernel: k_ipv4 nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables x_tables ext3 jbd loop snd_pcm snd_timer snd soundcore snd_page_alloc pcspkr evdev ext4 mbcache jbd2 crc16 dm_mod xen_netfront xen_blkfront
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.180969] Pid: 3817, comm: tlsmgr Tainted: G        W  2.6.32-5-xen-amd64 #1
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.180975] Call Trace:
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.180983]  [<ffffffffa0032c81>] ? jbd2_journal_stop+0x189/0x25d [jbd2]
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.180992]  [<ffffffffa0032c81>] ? jbd2_journal_stop+0x189/0x25d [jbd2]
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.180999]  [<ffffffff8104ef00>] ? warn_slowpath_common+0x77/0xa3
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181006]  [<ffffffff8100eccf>] ? xen_restore_fl_direct_end+0x0/0x1
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181015]  [<ffffffffa0032c81>] ? jbd2_journal_stop+0x189/0x25d [jbd2]
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181024]  [<ffffffffa0033cd6>] ? jbd2_journal_start+0x96/0xc6 [jbd2]
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181083]  [<ffffffffa0070df6>] ? ext4_force_commit+0xa4/0xb3 [ext4]
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181094]  [<ffffffffa0058a37>] ? ext4_sync_file+0x8f/0x25c [ext4]
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181104]  [<ffffffff8110ccd4>] ? vfs_fsync_range+0x73/0x9e
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181110]  [<ffffffff8110cd7e>] ? do_fsync+0x28/0x39
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181115]  [<ffffffff8110cd9d>] ? sys_fdatasync+0xe/0x13
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181125]  [<ffffffff8130d89a>] ? error_exit+0x2a/0x60
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181131]  [<ffffffff81011b42>] ? system_call_fastpath+0x16/0x1b
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181137]  [<ffffffff810092eb>] ? hypercall_page+0x2eb/0x1001
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181142] ---[ end trace 2c615eb111c993ce ]---
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181160] transaction->t_outstanding_credits = 9
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181164] transaction->t_nr_buffers = 10
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181168] ------------[ cut here ]------------
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181176] WARNING: at /tmp/kdm-deb-kernel/linux-2.6-2.6.32/debian/build/source_amd64_xen/fs/jbd2/commit.c:538 jbd2_journal_commit_transaction+0x574/0x118b [jbd2]()
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181185] Modules linked in: ip6table_filter ip6_tables act_police cls_flow cls_fw cls_u32 sch_htb sch_hfsc sch_ingress sch_sfq xt_time xt_connlimit xt_realm iptable_raw xt_comment xt_recent xt_policy ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY nf_tproxy_core xt_tcpmss xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLO
 G nfnetlink_log xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack xt_CONNMARK xt_connmark xt_CLASSIFY ipt_LOG xt_tcpudp xt_state iptable_nat nf_nat n
> f_conntrac
> > Jun 24 16:36:07 i-38020f57 kernel: k_ipv4 nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables x_tables ext3 jbd loop snd_pcm snd_timer snd soundcore snd_page_alloc pcspkr evdev ext4 mbcache jbd2 crc16 dm_mod xen_netfront xen_blkfront
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181368] Pid: 992, comm: jbd2/dm-23-8 Tainted: G        W  2.6.32-5-xen-amd64 #1
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181374] Call Trace:
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181383]  [<ffffffffa0034471>] ? jbd2_journal_commit_transaction+0x574/0x118b [jbd2]
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181393]  [<ffffffffa0034471>] ? jbd2_journal_commit_transaction+0x574/0x118b [jbd2]
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181401]  [<ffffffff8104ef00>] ? warn_slowpath_common+0x77/0xa3
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181409]  [<ffffffffa0034471>] ? jbd2_journal_commit_transaction+0x574/0x118b [jbd2]
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181418]  [<ffffffff8130bf48>] ? thread_return+0x79/0xe0
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181424]  [<ffffffff8100e629>] ? xen_force_evtchn_callback+0x9/0xa
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181430]  [<ffffffff8100ece2>] ? check_events+0x12/0x20
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181436]  [<ffffffff8130d2e2>] ? _spin_unlock_irqrestore+0xd/0xe
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181445]  [<ffffffff8105b8c8>] ? try_to_del_timer_sync+0x63/0x6c
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181455]  [<ffffffffa003a98b>] ? kjournald2+0xbe/0x206 [jbd2]
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181461]  [<ffffffff81065f06>] ? autoremove_wake_function+0x0/0x2e
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181470]  [<ffffffffa003a8cd>] ? kjournald2+0x0/0x206 [jbd2]
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181475]  [<ffffffff81065c39>] ? kthread+0x79/0x81
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181482]  [<ffffffff81012baa>] ? child_rip+0xa/0x20
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181487]  [<ffffffff81011d61>] ? int_ret_from_sys_call+0x7/0x1b
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181493]  [<ffffffff8101251d>] ? retint_restore_args+0x5/0x6
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181499]  [<ffffffff81012ba0>] ? child_rip+0x0/0x20
> > Jun 24 16:36:07 i-38020f57 kernel: [5369328.181503] ---[ end trace 2c615eb111c993cf ]---
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
