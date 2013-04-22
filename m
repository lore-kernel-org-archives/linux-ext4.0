From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4, jbd2: task blocked for more than 120 seconds.
Date: Mon, 22 Apr 2013 07:17:59 -0400
Message-ID: <20130422111759.GB9950@thunk.org>
References: <CAAW1UO8bbhfuw-J=0cxLB0uTps6aecTJe4ro2SgExpcK-SDouw@mail.gmail.com>
 <CAAW1UO_+_z8zyRhX-HZKWHsxiZ8fE54bZvxU_uuXTmMQ3=+qSA@mail.gmail.com>
 <CAAW1UO_fwrryWFMdTh7v5wSKMTdfmDpWqU=bJ0j86AHAGYv77A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Azat Khuzhin <dohardgopro@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43475 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304Ab3DVLSD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Apr 2013 07:18:03 -0400
Content-Disposition: inline
In-Reply-To: <CAAW1UO_fwrryWFMdTh7v5wSKMTdfmDpWqU=bJ0j86AHAGYv77A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Azat,

Could you try and see if the following patch (which is queued for the
next merge window) solves the problem which you are seeing?

     http://patchwork.ozlabs.org/patch/234776/

Thanks!!

						- Ted
