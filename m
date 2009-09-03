From: Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH 3/4]ext4: Return exchanged blocks count to user space in
	failure
Date: Thu, 3 Sep 2009 13:13:03 +0800
Message-ID: <6149e97b0909022213p2b8463fdm796c8687d36ae54c@mail.gmail.com>
References: <4A9DE3EA.1080602@rs.jp.nec.com> <4A9E9521.2010701@gmail.com>
	 <87f94c370909021359p171c6f6dte9b700cd48a5fde0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f204.google.com ([209.85.216.204]:60533 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098AbZICFNB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Sep 2009 01:13:01 -0400
Received: by pxi42 with SMTP id 42so1425988pxi.20
        for <linux-ext4@vger.kernel.org>; Wed, 02 Sep 2009 22:13:03 -0700 (PDT)
In-Reply-To: <87f94c370909021359p171c6f6dte9b700cd48a5fde0@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, Greg,

On Thu, Sep 3, 2009 at 4:59 AM, Greg Freemyer<greg.freemyer@gmail.com> =
wrote:
> Peng,
>
> I have not looked at the code very closely, but can you tell me where
> a file corruption can take place? =C2=A0 Not completing the replaceme=
nt of
> extents with donor extents is one thing. =C2=A0Corrupting the origina=
l file
> contents is another.
The file corruption is mainly because of the half done replacement.

My test case is here:
http://marc.info/?l=3Dlinux-ext4&m=3D124992522305319&w=3D2

With Akira's previous patch
(http://marc.info/?l=3Dlinux-ext4&m=3D124937430627867&w=3D2),
EXT4_IOC_MOVE_EXT does not panic the kernel any more. But it leaves
the orig file's extent tree corrupted.

>
> Clearly we need EXT4_IOC_MOVE_EXT to fail gracefully and not corrupt
> the original file the vast majority of the time.
>
> Greg
>



--=20
Cheers,
Peng Tao
State Key Laboratory of Networking and Switching Technology
Beijing Univ. of Posts and Telecoms.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
