From: Wolfgang Walter <linux@stwm.de>
Subject: external journal an data= option
Date: Mon, 21 Nov 2016 16:39:53 +0100
Message-ID: <5330915.k0A4yo7VY8@stwm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

while testing ext4 with an external journal I found the following problem with 
longterm kernel 4.4.30:

I could mount the filesystem without specifying the option data=....

It seems that it is then mounted with data=ordered and indeed this is what

	cat /proc/mounts

shows.

But I could not change any option afterwards with -o remount. It always said 
that data=ordered is not valid with an external journal.

If I mount with explicitly stating data=writeback or data=journal remount 
works fine.

So It seems that ext4 does forbid (at least in 4.4.30) data=ordered as an 
option but uses it implicitly as default mode even with an external journal.

Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
