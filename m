From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: Question about ext4 online defrag test case
Date: Tue, 19 Jan 2010 13:37:04 +0900
Message-ID: <4B5536F0.2060403@rs.jp.nec.com>
References: <4B4EEF94.5000902@rs.jp.nec.com> <87f94c371001141304n18bcd208kd97f08646d37d1e2@mail.gmail.com> <37d33d831001150541o1b674580u14719e72e3ad8e78@mail.gmail.com> <20100116062930.GB25273@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: SandeepKsinha <sandeepksinha@gmail.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:59826 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab0ASEha (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jan 2010 23:37:30 -0500
In-Reply-To: <20100116062930.GB25273@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

(2010/01/16 15:29), tytso@mit.edu wrote:
> On Fri, Jan 15, 2010 at 07:11:28PM +0530, SandeepKsinha wrote:
>>>> I found your comment about ext4 online defrag on Ubuntu BBS by accident.
>>>> https://bugs.launchpad.net/ubuntu/+source/e2fsprogs/+bug/321528
>>>>
>>>> I would like to address this problem so I ran e4defrag on the system
>>>> which was under memory pressure. But unfortunately I could not find the bug.
>>>> If you have already known how to reproduce this kind of problem,
>>>> could you teach me how?
> 
> I'm sorry I wasn't clear.  I don't know of any specific problem with
> the code, but I and some other ext4 developers remain a bit conerned
> about the code because of how it is structured, and the fact that
> there is so much code and there hasn't been a lot of people spent a
> lot of time going through it and cleaning it up.  We also don't have
> good regression tests for the kernel defrag support code.
> 
> This is partially my fault; I haven't had enough time to do more
> testing and code clean up on the defrag code.  I need to spend more
> time doing some testing and code cleanup before I'll be comfortable
> telling people that it is as reliable as other parts of ext4 in terms
> of not potentially losing their data.  Maybe it's just my paranoia....
> 

All right.
I have already fixed all reported bugs so far,
but I recognize that e4defrag needs more tests and review,
so I will continue testing.

BTW, I would like to ask you about e4defrag command merge plan.
The following e4defrag patches have been released.
How are you going to do these patches in future?

1: From Kazuya Mio <k-mio@sx.jp.nec.com>
[RFC][PATCH v2 1/4] e4defrag: output size per extent by -c option
http://marc.info/?l=linux-ext4&m=125602666514382&w=4

2: From Kazuya Mio <k-mio@sx.jp.nec.com>
[RFC][PATCH v2 2/4] e4defrag: fix file blocks calculation
http://marc.info/?l=linux-ext4&m=125602676114522&w=4

3: From Kazuya Mio <k-mio@sx.jp.nec.com>
[RFC][PATCH v2 3/4] e4defrag: avoid unsuccessful return in non-privileged
http://marc.info/?l=linux-ext4&m=125602682614647&w=4

4: From Kazuya Mio <k-mio@sx.jp.nec.com>
[RFC][PATCH v2 4/4] e4defrag: update man page about -c option
http://marc.info/?l=linux-ext4&m=125602694414881&w=4

5: From Eric Sandeen <sandeen@redhat.com>
[PATCH] Skip "rootfs" entry when checking for ext4 filesystem.
http://marc.info/?l=linux-ext4&m=125242643605387&w=4

6: From Akira Fujita <a-fujita@rs.jp.nec.com>
[PATCH 2/2]e4defrag: Fix open flag for original file
# I sent this patch to you on December 3th personally,
  it's not in the linux-ext4 so I attach it in below.
　Manish also send same patch.

Regards,
Akira Fujita


e4defrag: Fix open flag for original file

From: Akira Fujita <a-fujita@rs.jp.nec.com>

e4defrag command uses EXT4_IOC_MOVE_EXT to exchange
blocks between original and donor files.
And there is a read/write access check for original file
in kernel-space, so open it with RDWR flag in user-space.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 misc/e4defrag.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 82e3868..424e0ca 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -1605,7 +1605,7 @@ static int file_defrag(const char *file, const struct stat64 *buf,
         return 0;
     }

-    fd = open64(file, O_RDONLY);
+    fd = open64(file, O_RDWR);
     if (fd < 0) {
         if (mode_flag & DETAIL) {
             PRINT_FILE_NAME(file);

