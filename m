From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: dumpe2fs/dump/restore not working correctly for ext4?
Date: Thu, 4 Mar 2010 10:19:57 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1003041000140.18322@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lucidpixels.com ([75.144.35.66]:42572 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269Ab0CDPT7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Mar 2010 10:19:59 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I need to look into this more obviously and try other dumps etc, but I 
even tried extracting a single (smaller) directory and it also segfaulted, 
has dump been tested properly with ext4?

# restore -f ../p34-root-2010-03-02.ext4dump -r .
Segmentation fault (core dumped)

(gdb) bt full
#0  0x000000000040d03d in ?? ()
No symbol table info available.
#1  0x000000000040d336 in ?? ()
No symbol table info available.
#2  0x000000000040e1a4 in ?? ()
No symbol table info available.
#3  0x0000000000408d5b in ?? ()
No symbol table info available.
#4  0x0000000000407d92 in ?? ()
No symbol table info available.
#5  0x00007f8df3361abd in __libc_start_main () from /lib/libc.so.6
No symbol table info available.
#6  0x0000000000403019 in ?? ()
No symbol table info available.
#7  0x00007fffa98b8bb8 in ?? ()
No symbol table info available.
#8  0x000000000000001c in ?? ()
No symbol table info available.
#9  0x0000000000000005 in ?? ()
No symbol table info available.
#10 0x00007fffa98b8e18 in ?? ()
No symbol table info available.
#11 0x00007fffa98b8e20 in ?? ()
No symbol table info available.
#12 0x00007fffa98b8e23 in ?? ()
No symbol table info available.
#13 0x00007fffa98b8e43 in ?? ()
No symbol table info available.
#14 0x00007fffa98b8e46 in ?? ()
No symbol table info available.
#15 0x0000000000000000 in ?? ()
No symbol table info available.
(gdb)

Justin.
