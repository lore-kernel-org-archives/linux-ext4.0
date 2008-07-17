From: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: ext3 on latest -git: BUG: unable to handle kernel NULL pointer dereference at 0000000c
Date: Thu, 17 Jul 2008 17:16:39 +0200
Message-ID: <19f34abd0807170816p4788a352qc35b42fd7647d00f@mail.gmail.com>
References: <1b7401870807170613y747baa7by158177047cc7e28@mail.gmail.com>
	 <1b7401870807170634u14492a53k3931ddcddbd1e098@mail.gmail.com>
	 <19f34abd0807170639p838d14blc9a13d2104313f38@mail.gmail.com>
	 <20080717135746.GB14133@unused.rdu.redhat.com>
	 <19f34abd0807170725p13e81e3dq4daad32ad2a83931@mail.gmail.com>
	 <20080717141333.GC14133@unused.rdu.redhat.com>
	 <19f34abd0807170735p5d2cba31kec3fb65c5b8c7b3f@mail.gmail.com>
	 <20080717141655.GD14133@unused.rdu.redhat.com>
	 <19f34abd0807170744r79e46a78odfcfbd67687d2ceb@mail.gmail.com>
	 <20080717150812.GU2167@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: "Theodore Tso" <tytso@mit.edu>,
	"Vegard Nossum" <vegard.nossum@gmail.com>,
	"Josef Bacik" <jbacik@redhat.com>,
	"Josef Bacik" <josef@toxicpanda.com>, linux-ext4@vger.kernel.org,
	sct@re
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.180]:41371 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814AbYGQPQl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jul 2008 11:16:41 -0400
Received: by el-out-1112.google.com with SMTP id z25so1245520ele.1
        for <linux-ext4@vger.kernel.org>; Thu, 17 Jul 2008 08:16:40 -0700 (PDT)
In-Reply-To: <20080717150812.GU2167@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 17, 2008 at 5:08 PM, Theodore Tso <tytso@mit.edu> wrote:
> Vegard,
>
> How big is the filesystem?  Is there any chance you can make a
> compressed e2image of the file?  (This will not include file contents,
> but does reveal the names of the file.)  Given the nature of the bug
> which you are reporting, it should be safe to scramble the names of
> the filenames using the -s option if that would make you feel more
> comfortable.

Oh, just 2M. It doesn't contain anything but copies of /bin/bash.

I basically just made a crash-tester script that corrupts a dummy
filesystem on purpose. But it seems that it might be partly my own
fault for not protecting the bits in the filesystem image that say
"oh, proceed on error". But I do have a feeling that the filesystem
should not be able to say this in the first place. Because those bits
can be corrupted legitimately in other ways too!

http://folk.uio.no/vegardno/linux/corrupt.tar.bz2

Is there a way to override the

    "Errors behavior:          Continue"

information which is present in the filesystem?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
