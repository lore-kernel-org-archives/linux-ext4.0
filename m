From: Andrew Lutomirski <andy@luto.us>
Subject: Re: 2.6.32-rc1 oops in ext4
Date: Thu, 1 Oct 2009 12:42:45 -0400
Message-ID: <cb0375e10910010942m31c40ff5kc261deaa87969e55@mail.gmail.com>
References: <cb0375e10909301954y68e18290m97e9fecfbc5aa6e3@mail.gmail.com>
	 <20091001030733.GS24383@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Theodore Tso <tytso@mit.edu>, Andrew Lutomirski <andy@luto.us>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:62926 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbZJAQmm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Oct 2009 12:42:42 -0400
In-Reply-To: <20091001030733.GS24383@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 30, 2009 at 11:07 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Wed, Sep 30, 2009 at 10:54:26PM -0400, Andrew Lutomirski wrote:
>> All I did was boot Fedora 11 and open a Konsole. =A0I'm running
>> 84d88d5d4efc37dfb8a93a4a58d8a227ee86ffa4.
>
> I'm pretty sure this patch should fix things; can you confirm?
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0- Ted
>
> commit 1f94533d9cd75f6d2826018d54a971b9cc085992
> Author: Theodore Ts'o <tytso@mit.edu>
> Date: =A0 Wed Sep 30 22:57:41 2009 -0400
>
> =A0 =A0ext4: fix a BUG_ON crash by checking that page has buffers att=
ached to it
>
> =A0 =A0In ext4_num_dirty_pages() we were calling page_buffers() befor=
e
> =A0 =A0checking to see if the page actually had pages attached to it;=
 this
> =A0 =A0would cause a BUG check crash in the inline function page_buff=
ers().
>
> =A0 =A0Thanks to Markus Trippelsdorf for reporting this bug.
>
> =A0 =A0Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

I patched that onto the same kernel from git and it seems to work.

Tested-by: Andy Lutomirski <luto@mit.edu>

Thanks,
Andy
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
