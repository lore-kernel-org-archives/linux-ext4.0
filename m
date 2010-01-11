From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Mon, 11 Jan 2010 21:59:34 GMT
Message-ID: <201001112159.o0BLxYde005906@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33026 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab0AKV7e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Jan 2010 16:59:34 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0BLxYN7005912
	for <linux-ext4@vger.kernel.org>; Mon, 11 Jan 2010 21:59:34 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #18 from Jan Kara <jack@suse.cz>  2010-01-11 21:59:30 ---
Guys, I'm having problems reproducing this. I've checked out 2.10 version of
eglibc but when I run "make check" I get error on:
GCONV_PATH=/local/test1/build/iconvdata LC_ALL=C
LOCPATH=/local/test1/build/localedata   
/local/test1/build/elf/ld-linux-x86-64.so.2 --library-path
/local/test1/build:/local/test1/build/math:/local/test1/build/elf:/local/test1/build/dlfcn:/local/test1/build/nss:/local/test1/build/nis:/local/test1/build/rt:/local/test1/build/resolv:/local/test1/build/crypt:/local/test1/build/nptl
/local/test1/build/localedata/tst_mblen

probably because of:
mblen:de_DE.ISO-8859-1:1:1:2:F:the return value is different from an expected
value

When I configure the package without TLS, I cannot get even that far... So
could you either provide me with a simpler reproduction case or tell me how to
make "make check" do what I need? Thanks...

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
