From: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: ext3 on latest -git: BUG: unable to handle kernel NULL pointer dereference at 0000000c
Date: Thu, 17 Jul 2008 15:39:24 +0200
Message-ID: <19f34abd0807170639p838d14blc9a13d2104313f38@mail.gmail.com>
References: <19f34abd0807170551q4fbb862bu270297cfd76a69be@mail.gmail.com>
	 <1b7401870807170613y747baa7by158177047cc7e28@mail.gmail.com>
	 <19f34abd0807170620g39ab942bl592ea3fa3fa0dab@mail.gmail.com>
	 <1b7401870807170634u14492a53k3931ddcddbd1e098@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, sct@redhat.com,
	akpm@linux-foundation.org, adilger@sun.com,
	"Johannes Weiner" <hannes@saeurebad.de>,
	linux-kernel@vger.kernel.org
To: "Josef Bacik" <josef@toxicpanda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:9711 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882AbYGQNjZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jul 2008 09:39:25 -0400
Received: by wf-out-1314.google.com with SMTP id 27so5996237wfd.4
        for <linux-ext4@vger.kernel.org>; Thu, 17 Jul 2008 06:39:25 -0700 (PDT)
In-Reply-To: <1b7401870807170634u14492a53k3931ddcddbd1e098@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 17, 2008 at 3:34 PM, Josef Bacik <josef@toxicpanda.com> wrote:
>> Yeah, the full log exists at
>>
>>    http://folk.uio.no/vegardno/linux/log-1216293934.txt
>>
>> I think this is the interesting part:
>
> Hmm well the journal should have aborted, but it looks like it didn't,
> are you mounting with errors=continue by any chance?  Thanks much,

No, this is the command I used:

        mount -o loop disk mnt

I think this looks interesting:

EXT3-fs error (device loop0) in ext3_reserve_inode_write: IO failure

The code in ext3_reserve_inode_write() is here:

        err = ext3_journal_get_write_access(handle, iloc->bh);
        if (err) {
                brelse(iloc->bh);
                iloc->bh = NULL;
        }

Maybe it should do something different here?

But I don't know :-)

Thanks for helping out!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
