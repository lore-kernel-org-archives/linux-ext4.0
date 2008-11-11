From: Norbert Preining <preining@logic.at>
Subject: Re: ext3 aborts journal
Date: Tue, 11 Nov 2008 10:43:46 +0100
Message-ID: <20081111094346.GR21495@gamma.logic.tuwien.ac.at>
References: <20081110075704.GA31730@gamma.logic.tuwien.ac.at> <49185AEB.5070302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:45494 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634AbYKKJns (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Nov 2008 04:43:48 -0500
Content-Disposition: inline
In-Reply-To: <49185AEB.5070302@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear Eric,

On Mo, 10 Nov 2008, Eric Sandeen wrote:
> I believe this was fixed by:

thanks, that seems to be in rc4, at least patch did not apply, but the
code in checkpoint.c looks suspiciously like a variant of this patch has
already been applied.

Thanks a lot again

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
TINCLETON (n.)
A man who amuses himself in your lavatory by pulling the chain in
mid-pee and then seeing if he can finish before the flush does.
			--- Douglas Adams, The Meaning of Liff
