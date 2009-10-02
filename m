From: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: 2.6.32-rc2: kernel BUG at fs/ext4/inode.c:1184
Date: Fri, 2 Oct 2009 17:30:26 +0200
Message-ID: <20091002173026.1e0fb430@dhcp-lab-109.englab.brq.redhat.com>
References: <20091002131837.14bbb71b@dhcp-lab-109.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbZJBPTv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Oct 2009 11:19:51 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n92FJttG002302
	for <linux-ext4@vger.kernel.org>; Fri, 2 Oct 2009 11:19:55 -0400
Received: from dhcp-lab-109.englab.brq.redhat.com (dhcp-0-151.brq.redhat.com [10.34.0.151])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n92FJsRl020016
	for <linux-ext4@vger.kernel.org>; Fri, 2 Oct 2009 11:19:55 -0400
In-Reply-To: <20091002131837.14bbb71b@dhcp-lab-109.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2 Oct 2009 13:18:37 +0200
Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> After yesterday pull from Linus tree (some ext4 big updates), I entered a bug
> on my fedora 11 root partition. Below is dmesg and .config. Please let me know
> if you want any other info, I can reproduce the issue (but don't especially
> want to as I like my F11 working environment :-)

Uhh, I found this http://marc.info/?t=125436576600002&r=1&w=2 . Next time 
I first google and then send. Sorry for noise.

Stanislaw
