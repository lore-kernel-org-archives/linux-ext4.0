From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: Test results for ext4
Date: Mon, 02 Jun 2008 15:07:08 +0200
Message-ID: <4843F07C.5020306@bull.net>
References: <48402253.8040407@bull.net> <484024EF.7080304@redhat.com> <4840297C.7030809@bull.net> <48402A1F.8080108@redhat.com> <48402B49.7000805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59798 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbYFBNH3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 09:07:29 -0400
In-Reply-To: <48402B49.7000805@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Oh, also for completeness can you specify which xfsprogs you used?
> There were some recent changes made which affect the fs geometry, and
> might affect the results.  So it would be good to fully specify.
OK, to do. To be honest, I didn't update them recently.

>=20
> Also why no fragmentation results for xfs or ext3?
I only forgot to do it.

But I didn't want to make a full comparaison of ext4 to xfs and ext3.
When testing the latest ext4 patch queue with a new kernel, I'd got
sometimes kernel crashes, or system hang, or bad performance.
Running the same tests on ext3 and xfs for which the code is more
stable I think gives me reference numbers for my tests.
In this way, I found in the past a problem in the IO scheduler.

    Val=E9rie



--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
