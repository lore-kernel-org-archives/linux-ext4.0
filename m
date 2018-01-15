From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: e2fsck -D lead to severely damaged filesystem
Date: Mon, 15 Jan 2018 08:23:29 +0100
Message-ID: <20180115072329.GA20942@pcnci.linuxbox.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: nik@linuxbox.cz
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gwu.lbox.cz ([62.245.111.132]:55872 "EHLO gwu.lbox.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751934AbeAOHzx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 15 Jan 2018 02:55:53 -0500
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
        by gwu.lbox.cz (Sendmail) with ESMTPS id w0F7NTFE019194
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
        for <linux-ext4@vger.kernel.org>; Mon, 15 Jan 2018 08:23:29 +0100
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello dear ext4 developers,

I'd like to ask about following problem I hit yesterday
(and which I'm a bit responsible for, I guess).

we were dealing with slow access to directories with lots of
files (large maildirs), so after some  tests, I came to conclusion
that optimizing directories using e2fsck -D (on unmounted FS of course)
helps a lot. So after testing this on our test box, I did it on production
mailserver mail volume. The I decided to do some tests on newer kernel,
so I rebooted test box and got lots of fs errors..

I checked production box, and it got bad as well:

lots  of dx_probe:829: inode #15949784: block 35579: comm deliver: Directory hole found
messages.. 


so I unmounted fs again, run fsck, and got zillion of:

Inode 18378187 ref count is 2, should be 1.  Fix? yes

Unattached inode 18378194
Connect to /lost+found? yes

messages.. 


after ~3 hours, I gave up, and recovered FS from backup.. checking fs after
"repair" showed that some of large mailboxes vanished completely (and appeared in lost+found)

I think I can rule out hardware problem, since it appeared on two completely different
systems after some action.. but I'll try to prepare new test environment and reproduce it.

What I think might be my big mistake is that I was using quite old e2fsprogs - 1.42.6,
kernel was 4.4.52 (which I know is also a bit old, we're already testig 4.14.x)

My question is, was that  some known e2fsck problem which got fixed in new version?

Or did I do something wrong?

I'm going to retry using 1.43.8, but still I'd be a bit calmer to know it was known problem
and got fixed :)

If I could provide some more information, please let me know..

BR

nik

PS: both systems were running latest centos 6 (but with newer kernel and e2fsprogs)


-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28.rijna 168, 709 00 Ostrava

tel.:   +420 591 166 214
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
