From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Punching hole using fallocate is not removing the uninit extent
 from extent tree
Date: Thu, 21 Jun 2012 17:56:55 -0500
Message-ID: <4FE3A6B7.7010706@redhat.com>
References: <CAOiN93=S4jEBJGwDfrTCsQQ2Yzm_BOGHT_pOivcdAkx5gTLxjA@mail.gmail.com> <alpine.LFD.2.00.1206181300470.2394@dhcp-1-248.brq.redhat.com> <CAKYAXd-GEVwdCmZTsToBN04B3Kxjrjp39C9j7it7cT4vX639nA@mail.gmail.com> <CAKYAXd-kdSgH2LuGk=_cGZaYpOZRUaAthTCPi-Y7JYETPJLd2g@mail.gmail.com> <CAKYAXd94Zs7Hi2-E+Z=z7U1ficn7Cks71wofWDU4pUewsWb+4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>,
	Ashish Sangwan <ashishsangwan2@gmail.com>,
	linux-ext4@vger.kernel.org,
	Amit Sahrawat <amit.sahrawat83@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Ted Ts'o" <tytso@mit.edu>
To: Namjae Jeon <linkinjeon@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760537Ab2FUW5C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jun 2012 18:57:02 -0400
In-Reply-To: <CAKYAXd94Zs7Hi2-E+Z=z7U1ficn7Cks71wofWDU4pUewsWb+4w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/21/12 5:44 PM, Namjae Jeon wrote:
> Hi Lukas.
> 
> Have you reproduced this problem ?
> Plz reivew our patch.

Where is the patch in question?  I'm looking at a similar problem that may be related.

-Eric

> Thanks.


