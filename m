From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: ext2/3: document conditions when reliable operation is possible
Date: Mon, 16 Mar 2009 15:45:36 -0400
Message-ID: <87f94c370903161245u727090a7m93735d1b57971d9f@mail.gmail.com>
References: <20090312092114.GC6949@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	tytso@mit.edu, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:27726 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbZCPTpk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Mar 2009 15:45:40 -0400
In-Reply-To: <20090312092114.GC6949@elf.ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 12, 2009 at 5:21 AM, Pavel Machek <pavel@ucw.cz> wrote:
<snip>
> +Sector writes are atomic (ATOMIC-SECTORS)
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +Either whole sector is correctly written or nothing is written durin=
g
> +powerfail.
> +
> + =A0 =A0 =A0 Unfortuantely, none of the cheap USB/SD flash cards I s=
een do
> + =A0 =A0 =A0 behave like this, and are unsuitable for all linux file=
systems
> + =A0 =A0 =A0 I know.
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 An inherent problem with using flash as=
 a normal block
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 device is that the flash erase size is =
bigger than
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 most filesystem sector sizes. =A0So whe=
n you request a
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 write, it may erase and rewrite the nex=
t 64k, 128k, or
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 even a couple megabytes on the really _=
big_ ones.
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 If you lose power in the middle of that=
, filesystem
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 won't notice that data in the "sectors"=
 _around_ the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 one your were trying to write to got tr=
ashed.

I had *assumed* that SSDs worked like:

1) write request comes in
2) new unused erase block area marked to hold the new data
3) updated data written to the previously unused erase block
4) mapping updated to replace the old erase block with the new one

If it were done that way, a failure in the middle would just leave the
SSD with the old data in it.

If it is not done that way, then I can see your issue.  (I love the
potential performance of SSDs, but I'm beginning to hate the
implementations and spec writing.)

Greg
--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
=46irst 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.p=
df

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
