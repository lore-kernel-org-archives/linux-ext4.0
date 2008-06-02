From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [RFC][PATCH 6/6] delalloc ENOSPC: improve percpu counter	accounting
 accurate
Date: Mon, 02 Jun 2008 09:19:54 +0900
Message-ID: <48433CAA.1050209@rs.jp.nec.com>
References: <1212363385.4368.69.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:41018 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbYFBAT6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jun 2008 20:19:58 -0400
In-Reply-To: <1212363385.4368.69.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

> Mingming Cao wrote:
> percpu counter: update center counter when sum per-cpu counter
>
> From: Mingming cao <cmm@us.ibm.com>
>
> Delayed allocation need to check free blocks at every write time.
> percpu_counter_read_positive() is not quit accurate
>  but using percpu_counter_sum_positive() for every write
> frequently is quite expensive.

I couldn't compile the latest ext4 patch qeueu.

  LD      fs/ext3/ext3.o
  LD      fs/ext3/built-in.o
  CC      fs/ext4/balloc.o
fs/ext4/balloc.c: In function ‘ext4_has_free_blocks’:
fs/ext4/balloc.c:1629: error: implicit declaration of function ‘percpu_counter_sum_positive_set’


> +		    percpu_counter_sum_positive_set(&sbi->s_freeblocks_counter);

Maybe the above line which in percpucounter-add-sum-and-set-function.patch
is percpu_counter_sum_and_set(&sbi->s_freeblocks_couter).

Thanks,
Akira Fujita
