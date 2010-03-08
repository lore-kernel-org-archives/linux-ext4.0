From: Andreas Sundstrom <sunkan@zappa.cx>
Subject: Re: discard + LVM
Date: Mon, 08 Mar 2010 07:53:43 +0100
Message-ID: <4B949EF7.20302@zappa.cx>
References: <4B922929.5020006@zappa.cx> <4B933BD6.80100@redhat.com> <yq18wa4c9qn.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from alva.zappa.cx ([213.88.132.89]:55612 "EHLO alva.zappa.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab0CHGxt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Mar 2010 01:53:49 -0500
In-Reply-To: <yq18wa4c9qn.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Martin K. Petersen wrote:
>>>>>> "Eric" == Eric Sandeen <sandeen@redhat.com> writes:
>
> Eric> Andreas Sundstrom wrote:
>>> Hi..
>>>
>>> I have an OCZ agility SSD drive with FW 1.5 that supports the
>>> TRIM command.
>>>
>>> I can see that it works on a plain partition.  But it does not
>>> seem to work together with LVM.
>>>
>>> So I'm wondering if this is expected and whether it is something
>>> that will be worked on to get fixed?
>
> Eric> It is expected, as lvm is not yet passing discard requests.
>
> I'm working on this.  Missed the 2.6.34 merge window so I'm aiming at
>  2.6.35.

Ah, that sounds good. I tried mailing the dm-devel list but my mail
didn't seem to make it. Let me know if you need testing done for this,
I should be able to test it if you want.

/Andreas
