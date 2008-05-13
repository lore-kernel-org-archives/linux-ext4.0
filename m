From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH e2fsprogs] - fix swap sanity tests in blkid, and blkid	tests
Date: Tue, 13 May 2008 00:32:12 -0600
Message-ID: <20080513063212.GF3627@webber.adilger.int>
References: <48288BEB.6090005@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:45787 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350AbYEMGck (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 May 2008 02:32:40 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m4D6Wc3R004889
	for <linux-ext4@vger.kernel.org>; Mon, 12 May 2008 23:32:39 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K0S00K01NE4S600@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 12 May 2008 23:32:38 -0700 (PDT)
In-reply-to: <48288BEB.6090005@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 12, 2008  13:26 -0500, Eric Sandeen wrote:
> One one other required change, though; mkswap requires at least
> 10 pages of swap, so the image needs to be increased to 10x64k
> if mkswap is to succeed...
> 
> Maybe it'd be better to just dd it out on the fly?

Probably, yes.  Little point in bunzipping bytes that you are just
going to overwrite...

>  	bunzip2 < $SRCDIR/tests/$i.img.bz2 > tests/tmp/test.img.$$
> +	# swap is native-endian, so regenerate before testing
> +	if [ "$i" == "swap0" ]; then
> +		mkswap -v0 tests/tmp/test.img.$$ > /dev/null
> +	elif [ "$i" == "swap1" ]; then
> +		mkswap -v1 -L SWAP-TEST -U 8ff8e77f-8553-485e-8656-58be67a81666 tests/tmp/test.img.$$ >/dev/null
> +	fi

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

