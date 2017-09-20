From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [EXT4][Oops]kernel panics when running fsfuzzer
Date: Wed, 20 Sep 2017 16:44:40 +1000
Message-ID: <87lgl9lvhj.fsf@concordia.ellerman.id.au>
References: <1505741461.6990.11.camel@abdul.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        chandan <chandan@linux.vnet.ibm.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-next <linux-next@vger.kernel.org>,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org
To: Abdul Haleem <abdhalee@linux.vnet.ibm.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1505741461.6990.11.camel@abdul.in.ibm.com>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Abdul Haleem <abdhalee@linux.vnet.ibm.com> writes:

> Hi,
>
> next kernel panics when running fsfuzzer test on ext4 file system.
>
> Machine Type: Power 7 PowerVM LPAR
> kernel : 4.13.0-next-20170915
> config : attached
> Test: fsfuzzer
>
> dmesg:
> -----
> EXT4-fs (loop1): couldn't mount RDWR because of unsupported optional
> features (e4000000)
> JBD2: no valid journal superblock found
> EXT4-fs (loop1): error loading journal
> EXT4-fs (loop1): mounted filesystem with ordered data mode. Opts: (null)
> EXT4-fs error (device loop1): ext4_mb_generate_buddy:756: group 0, block
> bitmap and bg descriptor inconsistent: 1077 vs 1045 free clusters
> Unable to handle kernel paging request for data at address 0x00000008
> Faulting instruction address: 0xd0000000084b0424
> Oops: Kernel access of bad area, sig: 11 [#1]
> BE SMP NR_CPUS=2048 NUMA pSeries
> Dumping ftrace buffer: 
>    (ftrace buffer empty)
> Modules linked in: cramfs(E) dlci(E) 8021q(E) garp(E) mrp(E) af_key(E)
> ieee802154_socket(E) ieee802154(E) rpcrdma(E) ib_isert(E)
> iscsi_target_mod(E) ib_iser(E) libiscsi(E) ib_srpt(E) target_core_mod(E)
> ib_srp(E) hidp(E) ib_ipoib(E) cmtp(E) kernelcapi(E) rdma_ucm(E)
> ib_ucm(E) bnep(E) ib_uverbs(E) rfcomm(E) bluetooth(E) ib_umad(E)
> rdma_cm(E) ecdh_generic(E) rfkill(E) ib_cm(E) iw_cm(E) pptp(E) gre(E)
> l2tp_ppp(E) l2tp_netlink(E) l2tp_core(E) ip6_udp_tunnel(E) udp_tunnel(E)
> pppoe(E) pppox(E) ppp_generic(E) slhc(E) crypto_user(E) ib_core(E)
> nfnetlink(E) scsi_transport_iscsi(E) atm(E) sctp(E) dccp_ipv4(E)
> netlink_diag(E) dccp_diag(E) ip6table_filter(E) af_packet_diag(E)
> unix_diag(E) tcp_diag(E) udp_diag(E) ebtable_filter(E) bridge(E) sg(E)
> ibmveth(E) rpadlpar_io(E) loop(E) xt_CHECKSUM(E) iptable_mangle(E)
>  ipt_MASQUERADE(E) nf_nat_masquerade_ipv4(E) iptable_nat(E)
> nf_nat_ipv4(E) nf_nat(E) nf_conntrack_ipv4(E) nf_defrag_ipv4(E)
> xt_conntrack(E) nf_conntrack(E) ipt_REJECT(E) nf_reject_ipv4(E) tun(E)
> stp(E) llc(E) rpaphp(E) kvm_pr(E) kvm(E) ebtables(E) ip6_tables(E)
> dccp(E) inet_diag(E) iptable_filter(E) nfsd(E) auth_rpcgss(E) nfs_acl(E)
> lockd(E) grace(E) sunrpc(E) binfmt_misc(E) ip_tables(E) ext4(E)
> mbcache(E) jbd2(E) sd_mod(E) ibmvscsi(E) scsi_transport_srp(E) [last
> unloaded: netlink_diag]
> CPU: 15 PID: 32523 Comm: jbd2/loop1-8 Tainted: G        W   E
> 4.13.0-next-20170915-autotest #1

These would be easier to read if they weren't word-wrapped.

> task: c000000189664900 task.stack: c0000009f122c000
> NIP:  d0000000084b0424 LR: d0000000084a8040 CTR: c000000000373fe0
> REGS: c0000009f122f590 TRAP: 0300   Tainted: G        W   E > (4.13.0-next-20170915-autotest)
> MSR:  800000000280b032 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI>  CR: 28002022
> XER: 20000000  
> CFAR: c000000000008718 DAR: 0000000000000008 DSISR: 40000000 SOFTE: 1 
> GPR00: d0000000084a8040 c0000009f122f810 d0000000084bf010 > c00000093b66a7d0 
> GPR04: f0000000024ed980 c00000093b66a578 c00000093b66a578 > 0000000000000001 
> GPR08: 0000000000000000 0000000000000000 0000000000000000 > d0000000084b2738 
> GPR12: c000000000373fe0 c00000000e939d80 c000000000118350 > c0000013f0bc22c0 
> GPR16: c0000009f65e4000 c0000009f122fb20 0000000000000000 > c00000108a749824 
> GPR20: c0000009f791cf9c 0000000000000000 c0000009f791cf60 > d0000000084b6cb0 
> GPR24: 0000000000000000 c00000108a749880 0000000000000000 > c0000009f791d300 
> GPR28: c00000093b66a7d0 c0000009f122c000 0000000000000000 > c0000013f8f389b8 
> NIP [d0000000084b0424] .jbd2_journal_put_journal_head+0x94/0x22c [jbd2]
> LR [d0000000084a8040] .__jbd2_journal_remove_checkpoint+0x70/0x200 > [jbd2]
> Call Trace:
> [c0000009f122f810] [d0000000084b04ec] .jbd2_journal_put_journal_head +0x15c/0x22c [jbd2] (unreliable)
> [c0000009f122f890] [d0000000084a8040] .__jbd2_journal_remove_checkpoint +0x70/0x200 [jbd2]
> [c0000009f122f930] [d0000000084a8b98] .__jbd2_log_wait_for_space +0x368/0x3d0 [jbd2]
> [c0000009f122f9c0] [d0000000084a8c5c] .__jbd2_journal_clean_checkpoint_list+0x5c/0xc0 > [jbd2]
> [c0000009f122fa60] [d0000000084a4e2c] .jbd2_journal_commit_transaction +0x33c/0x2f80 [jbd2]
> [c0000009f122fc90] [d0000000084ad160] .jbd2_journal_init_inode +0x390/0x5a0 [jbd2]
> [c0000009f122fd70] [c0000000001184ac] .kthread+0x15c/0x1a0
> [c0000009f122fe30] [c00000000000b4e4] .ret_from_kernel_thread+0x58/0x74
> Instruction dump:
> 7c2004ac 7d40f8a8 7d4a4878 7d40f9ad 40c2fff4 38210080 e8010010 ebc1fff0 
> ebe1fff8 7c0803a6 4e800020 ebdf0040 <e93e000a> 79290fe0 0b090000 e93e0028 
> ---[ end trace bd674540a2bf235c ]---

The instruction dump is:

lwsync
ldarx   r10,0,r31	# probably bit_spin_unlock() in jbd_unlock_bh_journal_head()
andc    r10,r10,r9
stdcx.  r10,0,r31
bne-    0xfffffffffffffff4
addi    r1,r1,128
ld      r0,16(r1)
ld      r30,-16(r1)
ld      r31,-8(r1)
mtlr    r0
blr			# return

ld      r30,64(r31)
lwa     r9,8(r30)	# <-- POP, r30 is NULL
rldicl  r9,r9,1,63
tdnei   r9,0		# Most likely a BUG_ON()
ld      r9,40(r30)

Perhaps:

	J_ASSERT_JH(jh, jh->b_jcount >= 0);

And given:

struct journal_head {
	/*
	 * Points back to our buffer_head. [jbd_lock_bh_journal_head()]
	 */
	struct buffer_head *b_bh;

	/*
	 * Reference count - see description in journal.c
	 * [jbd_lock_bh_journal_head()]
	 */
	int b_jcount;


ie. b_jcount is 8 bytes into the struct, that looks likely.

So we had a jh that was NULL.


Is it reproducible?

cheers
