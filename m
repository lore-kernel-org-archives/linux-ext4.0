Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45896 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727979AbeK2Bmm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 28 Nov 2018 20:42:42 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id E8AB62D564
        for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2018 14:40:48 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Wed, 28 Nov 2018 14:40:49 +0000
Message-ID: <bug-201685-13602-lLib4m50u2@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #62 from Jimmy.Jazz@gmx.net ---
If you don't mind, I'll continue bisecting.

But generating a kernel becomes harder with the genuine kernel. Three times a
raw I was unable to compile the kernel. It fails with,
arch/x86/entry/vdso/vclock_gettime-x32.o:vclock_gettime.c:fonction__vdso_gettimeofday
: erreur : débordement de relocalisation : référence à «
vvar_vsyscall_gtod_data »

If it fails again, I will need to patch it:
--- arch/x86/entry/vdso/Makefile~ 2016-10-02 23:24:33.000000000 +0000
+++ arch/x86/entry/vdso/Makefile  2016-11-16 09:35:13.406216597 +0000
@@ -97,6 +97,7 @@

 CPPFLAGS_vdsox32.lds = $(CPPFLAGS_vdso.lds)
 VDSO_LDFLAGS_vdsox32.lds = -Wl,-m,elf32_x86_64 \
+        -fuse-ld=bfd \
         -Wl,-soname=linux-vdso.so.1 \
         -Wl,-z,max-page-size=4096 \
         -Wl,-z,common-page-size=4096

ld gold is my default.

And sorry, I should have patched l1tf_vmx_mitigation too. My mistake.

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 27830880e7a7..cb4a16292aa7 100644
--- arch/x86/kernel/cpu/bugs.c
+++ arch/x86/kernel/cpu/bugs.c
@@ -664,10 +664,9 @@ void x86_spec_ctrl_setup_ap(void)
 enum l1tf_mitigations l1tf_mitigation __ro_after_init = L1TF_MITIGATION_FLUSH;
 #if IS_ENABLED(CONFIG_KVM_INTEL)
 EXPORT_SYMBOL_GPL(l1tf_mitigation);
-
+#endif
 enum vmx_l1d_flush_state l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
 EXPORT_SYMBOL_GPL(l1tf_vmx_mitigation);
-#endif

 static void __init l1tf_select_mitigation(void)
 {


Neverless the ext4 issue as it seems to be doesn't make sens. I can compile
packages during the test to maintain the cpu's activity on top to ease
reproducing the issue.
Each time I do a reboot, I do a fsck on the ext4 partitions (in both rescue
mode and normal init process) and it's like for some partitions e2fsck is
unable to handle (in any undetermined circumstances) 'Structure needs cleaning'
issue (remember my remark about fsck -D). If that's confirmed, a corrupt fs
could  still be corrupt on the next reboot and misguide us.

In that case, Jens Axboe 4.19.4 patch does its work. I'm bisecting the kernel
on a 4.19.4 patched kernel version. The only fs that's stay corrupt after each
reboot is my backup partition (sig).
Could someone investigate in that direction please ?

I'm using e2fsprogs 1.44.4 package.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
