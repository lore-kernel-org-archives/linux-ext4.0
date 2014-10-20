From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: jbd2: revoke: negative shift exponent in hash()
Date: Mon, 20 Oct 2014 15:23:02 +0400
Message-ID: <5444F096.3010703@samsung.com>
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Michal Marek <mmarek@suse.cz>,
	Sasha Levin <sasha.levin@oracle.com>, x86@kernel.org,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dmitry Vyukov <dvyukov@google.com>,
	Konstantin Khlebnikov <koct9i@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

And one more negative shift, this time in jbd2/revoke.c in hash() function:

================================================================================
UBSan: Undefined behaviour in ../fs/jbd2/revoke.c:142:9
shift exponent -4 is negative
CPU: 3 PID: 1314 Comm: runscript.sh Not tainted 3.18.0-rc1+ #65
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
 0000000000000010 0000000000000000 0000000000000000 ffff8800baba3868
 ffffffff82ade70a 000000000000004a fffffffffffffffc ffff8800baba3878
 ffffffff819a5339 ffff8800baba3928 ffffffff819a5825 ffff8800baba38b8
Call Trace:
dump_stack (/home/andrew/linux/ubsan_x86//lib/dump_stackc:52)
ubsan_epilogue (/home/andrew/linux/ubsan_x86//lib/ubsanc:159)
__ubsan_handle_shift_out_of_bounds (/home/andrew/linux/ubsan_x86//lib/ubsanc:458)
find_revoke_record (/home/andrew/linux/ubsan_x86//fs/jbd2/revokec:142 /home/andrew/linux/ubsan_x86//fs/jbd2/revokec:180)
jbd2_journal_cancel_revoke (/home/andrew/linux/ubsan_x86//fs/jbd2/revokec:449)
do_get_write_access (/home/andrew/linux/ubsan_x86//fs/jbd2/transactionc:992)
jbd2_journal_get_write_access (/home/andrew/linux/ubsan_x86//fs/jbd2/transactionc:1022)
__ext4_journal_get_write_access (/home/andrew/linux/ubsan_x86//fs/ext4/ext4_jbd2c:159)
ext4_file_open (/home/andrew/linux/ubsan_x86//fs/ext4/filec:238)
do_dentry_open (/home/andrew/linux/ubsan_x86//fs/openc:722)
? __inode_permission (/home/andrew/linux/ubsan_x86//fs/nameic:418)
? ext4_check_all_de (/home/andrew/linux/ubsan_x86//fs/ext4/filec:209)
finish_open (/home/andrew/linux/ubsan_x86//fs/openc:784)
? may_open (/home/andrew/linux/ubsan_x86//fs/nameic:2572)
do_last (/home/andrew/linux/ubsan_x86//fs/nameic:3069)
? link_path_walk (/home/andrew/linux/ubsan_x86//fs/nameic:1495 /home/andrew/linux/ubsan_x86//fs/nameic:1757)
? inode_has_perm (/home/andrew/linux/ubsan_x86//security/selinux/hooksc:1620)
path_openat (/home/andrew/linux/ubsan_x86//fs/nameic:699 /home/andrew/linux/ubsan_x86//fs/nameic:3229)
do_filp_open (/home/andrew/linux/ubsan_x86//fs/nameic:3260)
? prepare_creds (/home/andrew/linux/ubsan_x86//kernel/credc:269)
do_open_exec (/home/andrew/linux/ubsan_x86//fs/execc:762)
do_execve_common.isra.21 (/home/andrew/linux/ubsan_x86//fs/execc:1476)
? getname_flags (/home/andrew/linux/ubsan_x86//fs/nameic:160)
SyS_execve (/home/andrew/linux/ubsan_x86//fs/execc:1604)
stub_execve (/home/andrew/linux/ubsan_x86//arch/x86/kernel/entry_64S:649)
================================================================================
