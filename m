From: "Peter Meier" <meiepeter@gmail.com>
Subject: Re: Trying out 2.6.26-ext4-3
Date: Sun, 27 Jul 2008 13:40:41 +0000
Message-ID: <c354edc90807270640n1d3b4cb9md175dcb8f6d187f9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:23079 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYG0Nkl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Jul 2008 09:40:41 -0400
Received: by wf-out-1314.google.com with SMTP id 27so5172855wfd.4
        for <linux-ext4@vger.kernel.org>; Sun, 27 Jul 2008 06:40:41 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

since my time is running out, I have now resorted to performing
my install on the file system mounted with -o nodelalloc, and I
am going to mount it this way in the running system, too, until I
hear something about this issue being sorted.

FWIW, I could reproduce the problem reliably three times on
newly created file systems when mounted with delayed alloca-
tion enabled, and it went away when I started using nodelalloc,
so it does seem be in connection with this. Unfortunately I did
not have the time to do runs with and without Ming's credit patch,
however. But reading the code without truely understanding it,
the non-da codepath calls the function to figure out the credits
to reserver always with a single page argument, while the da
case potentially hands it a larger number, and the resulting
multiple then exceeds the maximum transaction size.

As a closing note, it would be really cool if someone could put
my mind at ease about being able to enable delayed allocation
on the existing file system later after this is sorted, and about not
missing out anything by not having it from the start. As I under-
stand it right now, the only implications of not running with delalloc
are little more fragmentation because the lack of the batching
effect from delalloc results in missed chances to get contiguous
blocks, and the FS will be slower without it, but otherwise, I'm not
missing anything and can enable delalloc later, right? (Note: A
nice answer might be eligible for the wiki, too - I'd gladly do the
work to add it).


Greetings,
Peter
