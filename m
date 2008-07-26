From: Girish Shilamkar <Girish.Shilamkar@Sun.COM>
Subject: Re: [E2fsprogs] Compile error on RHEL4/ia64
Date: Sat, 26 Jul 2008 23:52:08 +0530
Message-ID: <1217096528.3293.23.camel@alpha.linsyssoft.com>
References: <1217095878.3293.22.camel@alpha.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
To: Ext4 Mailing List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-2.sun.com ([192.18.19.7]:39557 "EHLO
	sineb-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbYGZSVo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Jul 2008 14:21:44 -0400
Received: from fe-apac-06.sun.com (fe-apac-06.sun.com [192.18.19.177] (may be forged))
	by sineb-mail-2.sun.com (8.13.6+Sun/8.12.9) with ESMTP id m6QIMreL023893
	for <linux-ext4@vger.kernel.org>; Sat, 26 Jul 2008 18:22:54 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 id <0K4M00601KXV1200@mail-apac.sun.com>
 (original mail from Girish.Shilamkar@Sun.COM) for linux-ext4@vger.kernel.org;
 Sun, 27 Jul 2008 02:19:12 +0800 (SGT)
Received: from [192.168.1.100] ([122.163.190.21])
 by mail-apac.sun.com (Sun Java System Messaging Server 6.2-6.01 (built Apr  3
 2006)) with ESMTPSA id <0K4M00FJ4LJYR1BW@mail-apac.sun.com> for
 linux-ext4@vger.kernel.org; Sun, 27 Jul 2008 02:19:12 +0800 (SGT)
In-reply-to: <1217095878.3293.22.camel@alpha.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

CC to mailing list also ...

On Sat, 2008-07-26 at 23:41 +0530, Girish Shilamkar wrote:
> Hi Ted,
> 	While building e2fsprogs on ia64/rhel4 the following compile error was
> flagged:
> 
> Error messages:
> make[4]: Leaving directory `/cache/build/BUILD/e2fsprogs-1.40.7.sun1/lib/uuid'
>         CC clear.c
>         CC compare.c
>         CC copy.c
>         CC gen_uuid.c
> gen_uuid.c: In function `uuid__generate_time':
> gen_uuid.c:493: internal compiler error: in ia64_expand_load_address, at
> config/ia64/ia64.c:1184
> Please submit a full bug report,
> with preprocessed source if appropriate.
> See <URL:http://bugzilla.redhat.com/bugzilla> for instructions.
> Preprocessed source stored into /tmp/ccYkSBN6.out file, please attach this to
> your bugreport.
> make[3]: *** [gen_uuid.o] Error 1
> 
> e2fsprogs, if supported, sets TLS to appropriate TLS type, which happens to be 
> '__thread' for Linux. And hence THREAD_LOCAL is defined as 'static __thread' in 
> uuid_gen.c. But it seems that RHEL4 glibc is incompatible with TLS on ia64, 
> though e2fsprogs detected that '__thread' is usable.
> 
> Further investigation revealed that, With '-O' option it is ok on all 
> (rhel4, rhel5, sles9 & sles10) distros but with optimization 
> level >=2(-O2, -O3, ...) the problem occurs on RHEL4.
> 
> https://bugzilla.lustre.org/show_bug.cgi?id=15514
> has more details about the tests run to verify the above findings,
> comments # 9 and 10.
> 
> Regards,
> Girish

