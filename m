From: CAI Qian <caiqian@redhat.com>
Subject: Re: bisected! (WAS Re: s390x: kernel BUG at fs/ext4/inode.c:1591!)
Date: Wed, 3 Apr 2013 03:14:44 -0400 (EDT)
Message-ID: <1158933859.1177381.1364973284305.JavaMail.root@redhat.com>
References: <2133129347.8273339.1364549222854.JavaMail.root@redhat.com> <87ip46ss0o.fsf@openvz.org> <1211053180.322948.1364797847717.JavaMail.root@redhat.com> <87fvzaspr8.fsf@openvz.org> <874841142.414482.1364875584266.JavaMail.root@redhat.com> <874nfps133.fsf@openvz.org> <876098945.1097253.1364961617725.JavaMail.root@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Steve Best <sbest@redhat.com>, linux-ext4@vger.kernel.org,
	Lukas Czerner <lczerner@redhat.com>, stable@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:38530 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762945Ab3DCHOt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Apr 2013 03:14:49 -0400
In-Reply-To: <876098945.1097253.1364961617725.JavaMail.root@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> > [Text Documents:disable-es_lookup_extent.patch]
With this patch, I cannot reproduce it any more.

CAI Qian
