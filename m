From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Performance testing results
Date: Wed, 27 Jun 2007 23:52:24 -0400
Message-ID: <46833078.3070609@redhat.com>
References: <1692756695.20070628104652@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: valerie.clement@bull.net, linux-ext4@vger.kernel.org
To: sftf <sftf-misc@mail.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756751AbXF1DxA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jun 2007 23:53:00 -0400
In-Reply-To: <1692756695.20070628104652@mail.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

sftf wrote:
> Hi!
>   IMHO this test is not 100% correct.
>   ext3 | data=writeback
>   ext4 | data=writeback,extents,delalloc
>   xfs  | defaults is ordered !
> 
>  So you have compared ext's in writeback (which fastest mode) vs xfs in ordered.

Actually xfs's default (only) mode is more like writeback than ordered.
  So that's a fair comparison.   I bet it is xfs's barriers that hurt
it, though - while they are pretty much required on a single disk with a
volatile write cache, I think xfs's barrier implementation hurts it more
than barriers for ext*

-Eric
