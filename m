From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e4defrag: Handle device symlinks
Date: Thu, 19 Jul 2012 14:04:22 -0500
Message-ID: <50085A36.3000505@redhat.com>
References: <500859C6.6040401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Kazuya Mio <k-mio@sx.jp.nec.com>, xake@rymdraket.net
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907Ab2GSTEg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jul 2012 15:04:36 -0400
In-Reply-To: <500859C6.6040401@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/19/12 2:02 PM, Eric Sandeen wrote:
> Device nodes are commonly accessed via symlinks, i.e.
> 
> # ls -l /dev/mapper/testvg-testlv 
> lrwxrwxrwx. 1 root root 7 Jul 19 13:01 /dev/mapper/testvg-testlv -> ../dm-0
> 
> Today, e4defrag on such a device will fail:

FWIW this addresses Red Hat Bugzilla #707209

and was

Reported-by: Peter Hjalmarsson <xake@rymdraket.net>

-Eric
