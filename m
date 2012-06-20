From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: Ext4 slow on links
Date: Tue, 19 Jun 2012 23:57:16 -0400 (EDT)
Message-ID: <BA050E9A-2385-4FF9-B41A-3A25F3FF066A@redhat.com>
References: <20120620002014.GA25471@gamma.logic.tuwien.ac.at> <4FE14034.6070800@redhat.com> <20120620002014.GA25471@gamma.logic.tuwien.ac.at> <20120620021912.GA26323@thunk.org> <20120620033831.GA2395@gamma.logic.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Ted Ts'o" <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Norbert Preining <preining@logic.at>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:45118 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab2FTD51 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jun 2012 23:57:27 -0400
In-Reply-To: <20120620033831.GA2395@gamma.logic.tuwien.ac.at>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 19, 2012, at 10:38 PM, Norbert Preining <preining@logic.at> wrote:

> Hi Ted, hi Eric,
> 
> thanks for the answers, here some remarks.
> 
...

> On Di, 19 Jun 2012, Eric Sandeen wrote:
>> As Ted said, the targets might be far-flung.  If you do /bin/ls -l instead
>> of maybe an aliased ls which stats everything to make pretty colors,
>> is that faster?
> 
> Might be the problem, but I saw the same with a program doing
> opendir readdir etc, so no allias or external program involved.
> 
Of course ls -l must stat anyway.  I shouldn't compose emails so late.  :). 

You might see if the dir itself is badly fragmented (if not filefrag, stat in debugfs would show you block mapping) and maybe a blktrace of the actions would show you something interesting as well.

Eric

> Best wishes
> 
> Norbert
> ------------------------------------------------------------------------
> Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
> JAIST, Japan                                 TeX Live & Debian Developer
> DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> ------------------------------------------------------------------------
> NACTION (n.)
> The 'n' with which cheap advertising copywriters replace the word
> 'and' (as in 'fish 'n' chips', 'mix 'n' match', 'assault 'n'
> battery'), in the mistaken belief that this is in some way chummy or
> endearing.
>            --- Douglas Adams, The Meaning of Liff
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
