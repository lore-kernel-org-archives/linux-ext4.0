From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Wed, 13 Jan 2010 00:34:00 GMT
Message-ID: <201001130034.o0D0Y0nJ009956@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:51455 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab0AMAeC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jan 2010 19:34:02 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0D0Y0pg009957
	for <linux-ext4@vger.kernel.org>; Wed, 13 Jan 2010 00:34:00 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #24 from carlos.velasco@nimastelecom.com  2010-01-13 00:34:00 ---
Found. It is the test "tst-mutexpi9".

eglibc-2.10.1/nptl# GCONV_PATH=/compile/eglibc-build/iconvdata LC_ALL=C    
/compile/eglibc-build/elf/ld-linux-x86-64.so.2 --library-path
/compile/eglibc-build:/compile/eglibc-build/math:/compile/eglibc-build/elf:/compile/eglibc-build/dlfcn:/compile/eglibc-build/nss:/compile/eglibc-build/nis:/compile/eglibc-build/rt:/compile/eglibc-build/resolv:/compile/eglibc-build/crypt:/compile/eglibc-build/nptl
/compile/eglibc-build/nptl/tst-mutexpi9  >
/compile/eglibc-build/nptl/tst-mutexpi9.out

eglibc-2.10.1/nptl# umount /tmp
Segmentation fault

eglibc-2.10.1/nptl# cat /compile/eglibc-build/nptl/tst-mutexpi9.out
going to fork now

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
